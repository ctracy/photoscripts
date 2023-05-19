#!/bin/sh

# use something like this to change dates if camera is way off:
# exiftool "-AllDates+=6:11:26 0" .
# shifts by 6 years, 11 months, 26 days
# see cheatsheet at https://ryanmo.co/2014/09/28/exiftool-cheatsheet/

/opt/local/bin/exiftool "-DateTimeOriginal>FileModifyDate" *
