#!/bin/bash

# records timelapse of desktop. frames and movie saved in ~/Movies/screenlapse
#
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
#
# printf format spec http://www.pixelbeat.org/programming/gcc/format_specs.html
#   ffmpeg apparently uses it (see -i %d param argument)?

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
	RECORDING=false; # break main WHILE loop in case of unexpected program error
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
		printf "\n\ndone... movie saved to $BASE/$FILENAME.mov\n"
 	exit $?
}

# trap keyboard interrupt (control-c)
trap control_c SIGINT

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

# read -p "Enter start value for file numbering (Default: 1)" STARTNUMBER
# if [ "$STARTNUMBER" = "" ] ; then
# 	STARTNUMBER=1
# fi

STARTNUMBER=1

read -p "Please enter a framerate (12): " FRAMERATE
if [ "$FRAMERATE" = "" ] ; then
	FRAMERATE=12
fi

read -p "Optional: resize movie width to (1280? 720?):" TARGETWIDTH

printf "RECORDING: screenshots $INTERVAL seconds, starting at $STARTNUMBER.jpg."

BASE="$HOME/Movies/screenlapse"
if [ -d "$BASE/$FILENAME" ]; then

	cd "$BASE/$FILENAME"
	# find the highest-numbered jpg file without letters in its filename
	STARTNUMBER=$(find . -iname '*.jpg' -or -iname '*.JPEG' -maxdepth 1 | cut -c3- | awk '{print tolower($0)}' | grep -E '[:alpha:]+.*\.(jpg|jpeg)$' -v | sed -E 's/\.(jpg|jpeg)$//g' | sort -nr | head -n1)
	let STARTNUMBER++
else
	mkdir "$BASE/$FILENAME"
	cd "$BASE/$FILENAME"
fi


printf "\nScreenshots will be saved to $BASE/$FILENAME\n"

i=$STARTNUMBER
TOTALSHOTS=0
RECORDING=true
while [ "$RECORDING" = true ]; do
	screencapture -t jpg -x $i.jpg;
	# if [ "$TARGETWIDTH" != "" ] ; then
	# 	sips $i.jpg --resampleWidth $TARGETWIDTH --out $i.jpg &> /dev/null
	# fi
	TOTALSHOTS=$i
	printf "\rTook $TOTALSHOTS screenshots so far. pause: Ctrl-Z <-> fg, quit: Ctrl-C"
	let i++;sleep $INTERVAL;
done;
