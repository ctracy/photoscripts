#!/bin/sh
	
PREFERENCE=""
	
function workID {
    ID=$1
    master=$(sqlite3 "$DB" "Select masteruuid from RKVersion where uuid = '$ID';")
    name=$(sqlite3 "$DB" "Select name from RKVersion where uuid = '$ID';")
    imagePath=$(sqlite3 "$DB" "Select imagePath from RKMaster where uuid = '$master';")
    isRef=$(sqlite3 "$DB" "Select fileIsReference from RKMaster where uuid = '$master';")
    if [ 0 -eq $isRef ] ; then
	imagePath="$LIBRARY/Master/$imagePath"
	isRef=false
    else
	imagePath="/$imagePath"
	isRef=true
    fi
    echo "Name: '$name'\nFile referenced: $isRef\nPath: '$imagePath'\n"
}

function setPreference {
# $1 key $2 Prefernce file
    PREFERENCE=$(osascript \
	-e 'tell application "System Events"'\
		-e "return value of property list item \"$1\" of ¬
		property list file ((path to preferences as Unicode text) & \"$2\")" \
		    -e 'end tell')
    if [ ${PREFERENCE:0:1} = "~" ] ; then
	PREFERENCE="$HOME${PREFERENCE:1}"
    fi
}

setPreference "LibraryPath" "com.apple.Aperture.plist"
LIBRARY="$PREFERENCE"
DB="$LIBRARY/Database/Library.apdb"

echo "\nStart script\n"
theList=$(osascript \
    -e 'tell application "Aperture"' \
    -e 'set theList to "" ' \
    -e 'set imageSel to (get selection)' \
    -e 'if imageSel is {} then' \
    -e '   return ""' \
    -e 'else' \
    -e '   repeat with i from 1 to count of imageSel' \
    -e '      set theList to theList &  (id of item i of imageSel as rich text) & " "' \
    -e '   end repeat' \
    -e '   return theList ' \
    -e 'end if' \
    -e 'end tell'  )


if [ -z "$theList" ] ; then
    echo "No picture selected, Cancel"
    exit
else
    for ID in $theList ;do
	workID $ID
    done
fi
exit 0
