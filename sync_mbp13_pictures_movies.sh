#!/bin/sh

# use built-in rsync (OS X 10.4 and later):
RSYNC="/usr/bin/rsync -E"

# sudo runs the backup as root
# --eahfs enables HFS+ mode
# -a turns on archive mode (recursive copy + retain attributes)
# -x don't cross device boundaries (ignore mounted volumes)
# -S handle sparse files efficiently
# --showtogo shows the number of files left to process
# --delete deletes any files that have been deleted locally
# $* expands to any extra command line options you may give

#sudo $RSYNC -i -a -x -h -S --log-file=backup.log --delete \
#  --progress --stats --exclude-from backup_excludes.txt $* / /Volumes/mbp15-backup

# notes:
#  --delete doesn't work correctly if you use shell expansion (dir/*) need to refer to just directory
#  due to sudo, root's public key is used not the user running the script

sudo $RSYNC -a -v --no-o --no-g -x -h -S --log-file=/Users/Shared/sync-mbp13-pictures.log --delete Shannon@mbp13-wifi.tracy.lan:/Users/Shared/Pictures /Users/Shared/

#sudo chmod -R -N /Users/Shared/Pictures/*
#sudo xattr -c -r /Users/Shared/Pictures/*
sudo chown -R ctracy:staff /Users/Shared/Pictures

sudo $RSYNC -a -v --no-o --no-g -x -h -S --log-file=/Users/Shared/sync-mbp13-movies.log --delete Shannon@mbp13-wifi.tracy.lan:/Users/Shared/Movies /Users/Shared/

#sudo chmod -R -N /Users/Shared/Movies/*
#sudo xattr -c -r /Users/Shared/Movies/*
sudo chown -R ctracy:staff /Users/Shared/Movies

sudo $RSYNC -a -v --no-o --no-g -x -h -S --log-file=/Users/Shared/sync-mbp13-audio.log --delete Shannon@mbp13-wifi.tracy.lan:/Users/Shared/Audio /Users/Shared/

#sudo chmod -R -N /Users/Shared/Audio/*
#sudo xattr -c -r /Users/Shared/Audio/*
sudo chown -R ctracy:staff /Users/Shared/Audio

sudo $RSYNC -a -v --no-o --no-g -x -h -S --log-file=/Users/Shared/sync-mbp13-hd-movies.log --delete /Users/Shared/HD-Movies Shannon@mbp13-wifi.tracy.lan:/Users/Shared/



