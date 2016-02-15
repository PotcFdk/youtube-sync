# youtube-sync
Script for keeping an up-to-date offline mirror of a YouTube channel or playlist.  
Uses [youtube-dl](https://github.com/rg3/youtube-dl/) for interacting with YouTube.

### What can this script do that youtube-dl can't?
This script improves the management of a local copy of an entire YouTube channel.  
It will handle collisions, no-more-available videos and it will also keep a video's title up-to-date.

### How does this work?
We split the management into three sections:

#### Section 1: raw sync
This downloads a channel's videos to files, named by the video ID.  
Example: `https://www.youtube.com/watch?v=M8-vje-bq9c` will end up in `SYNC/LADYBABY/ID/M8-vje-bq9c.mkv`

But wait, I hear you say:  
>How does that make anything easier?  
>I can't work with these IDs! I need the video titles to be able to find a video that I want to watch!

That's what the other two sections are for.

#### Section 2: cached video titles
This goes through all of your video files (`SYNC/.../ID/[videoid].mkv`) and looks up the current video title.  
These titles are cached in `SYNC/.../TITLE/[videoid]`.
If the video is still up, the video title will be updated. If it has been taken down, the old title is left untouched.

#### Section 3: symlinks
Here's where sections 1 and 2 come together.  
This step updates symlinks in `SYNC/.../TITLE/[videotitle].mkv` that point at the correct file in `SYNC/.../ID/[videoid].mkv`.  
That way, you will have a directory with files (symlinks) that contain the video's up-to-date title.
