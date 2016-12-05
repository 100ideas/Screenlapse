Screenlapse - record timelapse of your desktop
===========

Starting & Stopping
-------------------
Start with `$ screenlapse <optional_name>`.

Stop with `ctrl-c`.

Pause with `ctrl-z` & `fg` to resume.

A bash script for os x that continuously captures screenshots, then assembles them into a timelapse video with ffmpg. Forked from [espy/Screenlapse](https://github.com/espy/Screenlapse)

Install
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

Options
-------------

If you're in a hurry, just smash the enter key three times to start recording with defaults, otherwise, you can set these parameters:
* __Filename__: The name of the `.mov` file and subfolder in which screencap images are saved. Default is `timelapse`. The date is prepended to the name.
  * __example__: `$ screenlapse bash-sed-hacking` saves screenshots to `$HOME/Pictures/screenlapse/<YYYY-MM-DD>_bash-sed-hacking/`, starting with `0.jpg`. If the directory already exists, it scans for the highest `<int>.jpg` file present and uses `<int+1>.jpg`.
  * __caveat__: only true if script is run on the __same day__, otherwise new folder is created.
* __Interval__: number of seconds between each screenshot. Default is 4.
* __Target width__: Whatever you want the width if the resulting images/video to be, i.e "640". Correct aspect ratio is maintained. Defaults to your screen resolution.
* __Framerate__: Target framerate of the .mov. Default is 12.
* #TODO follow the unix way, make these command line args

The root path in which screenlapses are saved is `$HOME/Pictures/screenlapse`. Change this in the script to suit your needs.
