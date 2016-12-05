#!/bin/bash

# repo: https://github.com/100ideas/screenlapse
# forked from https://github.com/espy/Screenlapse
#
# notes
#
# adjusting non-divis-2 aspect ratios
# http://stackoverflow.com/questions/20847674/ffmpeg-libx264-height-not-divisible-by-2#20848224
#
# Set width to 1280, and height will automatically be calculated to preserve the aspect ratio, and the height will be divisible by 2:
# -vf scale=1280:-2

renderFilm()
{

if [ "$TARGETWIDTH" = "" ] ; then
	ffmpeg -r $FRAMERATE -i %d.jpg -b:v 15000k $FILENAME.mov
else
	ffmpeg -r $FRAMERATE -i %d.jpg -b:v 15000k -vf scale=$TARGETWIDTH:-2 $FILENAME.mov
fi

}

control_c()
# run if user hits control-c
{
	printf "\n\nScreen recording stopped."
	printf "Saved $TOTALSHOTS screenshots."
	FILM12FPS=$(($TOTALSHOTS / 12))
	FILM24FPS=$(($TOTALSHOTS / 24))
 	printf "That's $FILM12FPS seconds of film at 12fps and $FILM24FPS seconds at 24fps."
	hash ffmpeg 2>/dev/null || { echo >&2 "No ffmpeg installed, exiting."; exit 1; }
	# echo "FFMPEG detected. Would you like to render the screenshots as a movie?"
	# select yn in "Yes" "No"; do
  #   		case $yn in
  #       		Yes ) (renderFilm); break;;
  #       		No ) exit;;
  #   		esac
	# done
	echo "FFMPEG detected. rendering..."
		(renderFilm)
		mv "$FILENAME.mov" ../
		open "../$FILENAME.mov"
 	exit $?
}

# trap keyboard interrupt (control-c)
trap control_c SIGINT

printf "saves screenshots, makes screenlapse in ~/Movies/screenlapse\n\n"

if [ -z "$1" ]; then
	read -p "Please enter a filename (Default: timelapse): " FILENAME
	if [ "$FILENAME" = "" ] ; then
		FILENAME=timelapse
	fi
else
	FILENAME=$1
fi
FILENAME=$(date '+%Y-%m-%d')_$FILENAME

read -p "Please enter the shooting interval in seconds (Default: 4): " INTERVAL
if [ "$INTERVAL" = "" ] ; then
	INTERVAL=4
fi

read -p "Enter start value for file numbering (Default: 1)" STARTNUMBER
if [ "$STARTNUMBER" = "" ] ; then
	STARTNUMBER=1
fi

read -p "Please enter a framerate (12): " FRAMERATE
if [ "$FRAMERATE" = "" ] ; then
	FRAMERATE=12
fi

read -p "Optional: resize movie width to (1280? 720?):" TARGETWIDTH

printf "Now taking screenshots every $INTERVAL seconds, starting at $STARTNUMBER.jpg."
TOTALSHOTS=0
here="$HOME/Movies/screenlapse"
if [ -d "$here/$FILENAME" ]; then
	FILENAME="$FILENAME"_$(date '+%H%M%S')
fi
here=$here/$FILENAME

mkdir "$here"
cd "$here"
printf "\nScreenshots will be saved to $here\n"

i=$STARTNUMBER;
while true; do
	screencapture -t jpg -x $i.jpg;
	# if [ "$TARGETWIDTH" != "" ] ; then
	# 	sips $i.jpg --resampleWidth $TARGETWIDTH --out $i.jpg &> /dev/null
	# fi
	TOTALSHOTS=$i
	printf "\rTook $TOTALSHOTS screenshots so far. pause: Ctrl-Z <-> fg, quit: Ctrl-C"
	let i++;sleep $INTERVAL;
done;