# youtube-sync

Script for maintaining an up-to-date offline mirror of a YouTube channel or playlist.  
Uses [youtube-dl](https://github.com/rg3/youtube-dl/) for interacting with YouTube.  
Usage help [here](#usage) (though, you should read all of that stuff below to know what's going on!).

youtube-sync is developed and maintained [on GitHub](https://github.com/PotcFdk/youtube-sync)  

**/!\ This project is a WIP and it shouldn't be considered stable. /!\**  
In fact, [future changes](https://github.com/PotcFdk/youtube-sync/issues?q=is%3Aissue+is%3Aopen+label%3Aenhancement) might change the way `youtube-sync` works, both internally and interface-wise. This README will always be kept up-to-date to reflect the current state of how everything works.

### What can this script do that youtube-dl can't?
This script improves the management of a local copy of an entire YouTube channel.  
It will handle collisions, no-more-available videos and it will also keep a video's metadata up-to-date.

### How does this work?
We split the management into three sections:

#### Section 1: raw sync
This downloads a channel's videos to files, named by the video ID.  
Example: `https://www.youtube.com/watch?v=M8-vje-bq9c` will end up in `SYNC/LADYBABY/ID/M8-vje-bq9c.mkv`

But wait, I hear you say:  
>How does that make anything easier?  
>I can't work with these IDs! I need the video titles to be able to find a video that I want to watch!

That's what the other two sections are for.

#### Section 2: cached video metadata
This goes through all of your video files (`SYNC/.../ID/[videoid].mkv`) and looks up the current video metadata. Currently, titles and descriptions are saved.  
This data is cached in `SYNC/.../META/[videoid].type`.
If the video is still up, the metadata will be updated. If it has been taken down, the old metadata is left untouched.

#### Section 3: symlinks
Here's where sections 1 and 2 come together.  
This step updates symlinks in `SYNC/.../LINK/[videotitle].mkv` so that they point at the correct file in `SYNC/.../ID/[videoid].mkv`.  
That way, you will have a directory with files (symlinks) that contain the video's up-to-date title.

### How can I keep my local copy up-to-date?
Just re-do the three steps above:  
* Step 1 will download all missing videos that have been added to the channel since your last sync. Old videos are left untouched and will stay in your local copy, even if they are deleted from the YouTube channel.  
* Step 2 will update all cached video metadata. If an old video has been taken down, the old metadata will be left untouched.  
* Step 3 will remove all symlinks and rebuild them using the title cache from step 2. This way, you will always have a directory where the videos have the most up-to-date video title in their file name.  

## Usage

Note: This list is an incomplete list. For all commands, run `./youtube-sync help`.  

`./youtube-sync setup NAME URL` - Create a profile ("working directory") in `SYNC/[NAME]`.  
`./youtube-sync update NAME` - Update the content of the profile "NAME" (located in in `SYNC/[NAME]/META`).  

## I want to see an example!
Sure thing, here you go, the basic workflow for the initial sync of a channel (`https://www.youtube.com/channel/UCKlfTlx0oY6BiCH7Qvabrhg`):  


#### Step 1: setup a profile
This will create a profile for grabbing all videos from the channel and saving them to `SYNC/LADYBABY`:  
`./youtube-sync setup LADYBABY https://www.youtube.com/channel/UCKlfTlx0oY6BiCH7Qvabrhg`

And this is how our directory tree looks like after the above command finishes:

```
$ tree SYNC/
SYNC/
└── LADYBABY
    ├── ID
    │   ├── 0wowOJv4KnI.mkv
    │   ├── 3zWwd8n2JVI.mkv
    │   ├── FD9jZGRLhgM.mkv
    │   ├── FGwD7APkGMA.mkv
    │   ├── G5qKciYpkgo.mkv
    │   ├── H8eaZ3awQ_w.mkv
    │   ├── iPb4fns-hvY.mkv
    │   ├── jXEd-Xmo9Rs.mkv
    │   ├── KZSBZ3zAZKA.mkv
    │   ├── M8-vje-bq9c.mkv
    │   ├── MDi-P0G9VMU.mkv
    │   ├── NtwJ-YMyShY.mkv
    │   ├── OBGi4SOfzgQ.mkv
    │   ├── PLEjiiZc3kQ.mkv
    │   ├── rtliSSbOCoA.mkv
    │   ├── t7LFwrCS1ws.mkv
    │   ├── tH-U-rFWnVQ.mkv
    │   └── vpTnIGxzLkI.mkv
    └── META
        └── source

3 directories, 19 files
```

#### Step 2: update
```
$ ./youtube-sync update LADYBABY
[youtube:channel] UCKlfTlx0oY6BiCH7Qvabrhg: Downloading channel page
[youtube:playlist] UUKlfTlx0oY6BiCH7Qvabrhg: Downloading webpage
[download] Downloading playlist: Uploads from LADYBABY
[youtube:playlist] playlist Uploads from LADYBABY: Downloading 20 videos
[download] Downloading video 1 of 20
[youtube] yhT2-oX5kzk: Downloading webpage
[youtube] yhT2-oX5kzk: Downloading video info webpage
[youtube] yhT2-oX5kzk: Extracting video information
[youtube] yhT2-oX5kzk: Downloading MPD manifest
[download] Destination: SYNC/LADYBABY/ID/yhT2-oX5kzk.mkv.f137
[download] 100% of 118.57MiB in 00:04
[download] Destination: SYNC/LADYBABY/ID/yhT2-oX5kzk.mkv.f251
[download] 100% of 4.21MiB in 00:00
[ffmpeg] Merging formats into "SYNC/LADYBABY/ID/yhT2-oX5kzk.mkv"
WARNING: Your copy of avconv is outdated, update avconv to version 10-0 or newer if you encounter any errors.
Deleting original file SYNC/LADYBABY/ID/yhT2-oX5kzk.mkv.f137 (pass -k to keep)
Deleting original file SYNC/LADYBABY/ID/yhT2-oX5kzk.mkv.f251 (pass -k to keep)
[download] Downloading video 2 of 20
[...]
[download] Finished downloading playlist: Uploads from LADYBABY
(1/20) Updating metadata: 0wowOJv4KnI... [OK]
(2/20) Updating metadata: 3zWwd8n2JVI... [OK]
[...]
(19/20) Updating metadata: vpTnIGxzLkI... [OK]
(20/20) Updating metadata: yhT2-oX5kzk... [OK]
Creating link: 0wowOJv4KnI -> LADYBABYチャンネル　Vol.3　THE潜入！レコーディング編.0wowOJv4KnI.mkv
Creating link: 3zWwd8n2JVI -> LADYBABY「アゲアゲマネー ～おちんぎん大作戦～／Age-Age Money」 Music Clip.3zWwd8n2JVI.mkv
[...]
Creating link: vpTnIGxzLkI -> LADYBABY NYC LIVE at SOB's Oct 11 2015.vpTnIGxzLkI.mkv
Creating link: yhT2-oX5kzk -> LADYBABY「セシボン・キブン／C'est si bon Kibun」Music Clip.yhT2-oX5kzk.mkv
```

Directory tree after the above command finishes:

```
$ tree SYNC/
SYNC/
└── LADYBABY
    ├── ID
    │   ├── 0wowOJv4KnI.mkv
    │   ├── 3zWwd8n2JVI.mkv
    [...]
    │   ├── tH-U-rFWnVQ.mkv
    │   └── vpTnIGxzLkI.mkv
    ├── LINK
    │   ├── KARAOKE DAM「ニッポン饅頭 -Nippon Manju」Funny Ver..PLEjiiZc3kQ.mkv -> ../ID/PLEjiiZc3kQ.mkv
    │   ├── KARAOKE JOYSOUND「ニッポン饅頭 -Nippon Manju」Music Clip Ver..FGwD7APkGMA.mkv -> ../ID/FGwD7APkGMA.mkv
    │   ├── LADYBABY LIVE Die Essigfabrik Köln (Deutschland) _ Dez. 5 2015.KZSBZ3zAZKA.mkv -> ../ID/KZSBZ3zAZKA.mkv
    [...]
    │   ├── [れいver.] ニッポン饅頭 振り付け講座.iPb4fns-hvY.mkv -> ../ID/iPb4fns-hvY.mkv
    │   ├── おまけ [ミキティー本物] ニッポン饅頭 振り付け講座.t7LFwrCS1ws.mkv -> ../ID/t7LFwrCS1ws.mkv
    │   └── 【重大発表】4.13 3rdシングル発売 ＆ 4.15 国内初ワンマンライブ決定.jXEd-Xmo9Rs.mkv -> ../ID/jXEd-Xmo9Rs.mkv
    └── META
        ├── 0wowOJv4KnI.description
        ├── 0wowOJv4KnI.title
        [...]
        ├── rtliSSbOCoA.description
        ├── rtliSSbOCoA.title
        ├── source
        ├── t7LFwrCS1ws.description
        ├── t7LFwrCS1ws.title
        ├── tH-U-rFWnVQ.description
        ├── tH-U-rFWnVQ.title
        ├── vpTnIGxzLkI.description
        └── vpTnIGxzLkI.title

4 directories, 73 files
```

The metadata is saved in the text files in /META:  
```
$ cat SYNC/LADYBABY/META/0wowOJv4KnI.title
LADYBABYチャンネル　Vol.3　THE潜入！レコーディング編

$ cat SYNC/LADYBABY/META/0wowOJv4KnI.description
あらゆるカルチャーを継承、破壊、そして創造する新感覚エンタメユニットLADYBA­BY。
[...]
LADYBABY公式サイト　http://www.clearstone.co.jp/ladybaby/
出演依頼・取材依頼はこちら→ladybaby@clearstone.co.jp
```
