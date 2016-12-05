Screenlapse - record timelapse of your desktop
===========

Usage: `screenlapse [name]`

A bash script for os x that makes a timelapse video of your screen with ffmpg, forked from [espy/Screenlapse](https://github.com/espy/Screenlapse)

What it does
------------

* Takes incrementally numbered screenshots of your main monitor at a definable interval, and at a definable resolution.
* If you have ffmpeg installed, it will let you render these screenshots to a .mov file at an arbitrary framerate.

How to use it
-------------

1. get [homebrew](http://brew.sh) if you don't have it.
2. clone, make executable
```bash
$ brew install ffmpeg
$ git clone https://github.com/100ideas/screenlapse.git
$ cd screenlapse
$ chmod +x screenlapse.sh
```
3. install script to PATH, or if you use [fish](http://fishshell.com) shell, add this function to fish.config:
```fishshell
function screenlapse; bash "<PATH_TO_SCRIPT>/screenlapse.sh" $argv; end
```
4. alternatively, rename to 'screenlapse.command' and you can double-click in finder to launch (neat idea @espy)
5.


If you're in a hurry, just smash the enter key three times to start recording with defaults, otherwise, you can set these parameters:
* __Filename__: The name of the `.mov` file and subfolder in which screencap images are saved. Default is `timelapse`. The date is prepended to the name.
* __Interval__: number of seconds between each screenshot. Default is 4.
* __Starting value for incremental numbering__: if you exited the script before and want to resume now, put the name of the last screenshot +1 here (if your last screenshot was 2214.jpg, enter 2215 here). Default is 1.
  * #TODO add logic that does this automatically if the directory exists
* __Target width__: Whatever you want the width if the resulting images/video to be, i.e "640". Correct aspect ratio is maintained. Defaults to your screen resolution.
* __Framerate__: Target framerate of the .mov. Default is 12.
* #TODO follow the unix way, make these command line args

You can then stop the screenshotting with `ctrl-c`. Use `ctrl-z` to pause and `fg` to resume.
