#!/bin/sh
echo "**************************************************************"
echo "* Shell script to update the file size parameter of master"
echo "* images in the Aperture database to the actual values on disk"
echo "**************************************************************"

# Argument 1: "full/path/to/image_file_or_folder"
# The argument must be:
# &amp;nbsp; 1. surrounded in double quotes to prevent shell expansion of wildcard characters
# &amp;nbsp; 2. a full path to the target from the volume root excluding the initial backslash (/)
#      because this is how Aperture keeps image file paths in the DB

### Check argument count
if [ $# -lt 1 ]
then
  echo "Error in $0 - Invalid Argument Count"
  echo "Syntax: $0 /full/path/to/image_file_or_folder"
  echo ""
  exit 1
fi

### Set variables
IMAGEPATH=$1;
IMAGENAME=$(basename "$1")
IMAGEFOLD=$(dirname "$1")

### Retrieve Aperture DB Location
# Code for retrieving Aperture DB location is reused from
# http://fiveyears62.com/2010/05/10/new-database-access-the-database-isnt-locked-anymore-in-aperture-3-0-3/
PREFERENCE=""
function setPreference {
    PREFERENCE=$(osascript \
    -e 'tell application "System Events"'\
    -e "return value of property list item \"$1\" of ¬
    property list file ((path to preferences as Unicode text) &amp; \"$2\")" \
    -e 'end tell')
    if [ ${PREFERENCE:0:1} = "~" ] ; then
	PREFERENCE="$HOME${PREFERENCE:1}"
    fi
}
setPreference "LibraryPath" "com.apple.Aperture.plist"
LIBRARY="$PREFERENCE"
DB="$LIBRARY/Database/Library.apdb"
echo "...Using database $DB"

# IFS is Bash's internal field separator, 
# Needs to be set to a newline character instead of the default value of
# whitespace character otherwise find command output will not be properly parsed
OLDIFS=$IFS
IFS=$'\n'

### Retrieve list of files and start processing
FILELIST=$(find "$IMAGEFOLD" -name "$IMAGENAME")

i=0
for f in $FILELIST
do
  # Retrieve file size on disk
  FILESIZE=$(stat -f "%z" "$f")

  # Retrieve file size in Aperture DB
  FILESIZEINDB=$(sqlite3 "$DB" "SELECT fileSize FROM RKMaster WHERE imagePath = '$f';")

  # If a record is found, and if values don't match update the value in DB
  if [ $FILESIZEINDB ]
  then
    if [ $FILESIZEINDB -ne $FILESIZE ]
    then
      updateresult=$(sqlite3 "$DB" "UPDATE RKMaster SET fileSize = '$FILESIZE' WHERE imagePath = '$f';")
      echo "Updating $f db record: Size in db is ${FILESIZEINDB}, size on disk is ${FILESIZE}"
      let i++ 
    else
      echo "Skipping $f: File size match."
    fi
  else
    echo "Skipping $f: Image not in Aperture."
  fi  
done

echo "$i records updated"

# Restore IFS
IFS=$OLDIFS

exit 0
