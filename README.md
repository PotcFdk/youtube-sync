# youtube-sync

Script for maintaining an up-to-date offline mirror of a YouTube channel or playlist.  
Uses [youtube-dl](https://github.com/rg3/youtube-dl/) for interacting with YouTube.  
Usage help [here](#usage) (though, you should read all of that stuff below to know what's going on!).

youtube-sync is developed and maintained [on GitHub](https://github.com/PotcFdk/youtube-sync)  

**/!\ This project is a WIP and it shouldn't be considered stable. /!\**  
In fact, [future changes](https://github.com/PotcFdk/youtube-sync/issues?q=is%3Aissue+is%3Aopen+label%3Aenhancement) might change the way `youtube-sync` works, both internally and interface-wise. This README will always be kept up-to-date to reflect the current state of how everything works.

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

### How can I keep my local copy up-to-date?
Just re-do the three steps above:  
* Step 1 will download all missing videos that have been added to the channel since your last sync. Old videos are left untouched and will stay in your local copy, even if they are deleted from the YouTube channel.  
* Step 2 will update all cached video titles. If an old video has been taken down, the old video title will be left untouched.  
* Step 3 will remove all symlinks and rebuild them using the title cache from step 2. This way, you will always have a directory where the videos have the most up-to-date video title in their file name.  

## Usage

`./youtube-sync.sh NAME URL` - Create a working directory in `SYNC/[NAME]` and download all videos of `URL` to `SYNC/[NAME]/ID/[videoid].mkv`.  
`./youtube-update-titles.sh NAME` - Update the video title cache in `SYNC/[NAME]/TITLE`.  
`./youtube-rebuild-links.sh NAME` - Recreate all symlinks in `SYNC/[NAME]/LINK` using the video title cache.  

## I want to see an example!
Sure thing, here you go, the basic workflow for the initial sync of a channel (`https://www.youtube.com/channel/UCKlfTlx0oY6BiCH7Qvabrhg`):  


#### Step 1: sync videos
This will grab all videos from the channel and create a working directory in `SYNC/LADYBABY`:  
`./youtube-sync.sh LADYBABY https://www.youtube.com/channel/UCKlfTlx0oY6BiCH7Qvabrhg`

And this is how our directory tree looks like after the above command finishes:

```
$ tree SYNC/
SYNC/
└── LADYBABY
    └── ID
        ├── 0wowOJv4KnI.mkv
        ├── 3zWwd8n2JVI.mkv
        ├── FD9jZGRLhgM.mkv
        ├── FGwD7APkGMA.mkv
        ├── G5qKciYpkgo.mkv
        ├── H8eaZ3awQ_w.mkv
        ├── iPb4fns-hvY.mkv
        ├── jXEd-Xmo9Rs.mkv
        ├── KZSBZ3zAZKA.mkv
        ├── M8-vje-bq9c.mkv
        ├── MDi-P0G9VMU.mkv
        ├── NtwJ-YMyShY.mkv
        ├── OBGi4SOfzgQ.mkv
        ├── PLEjiiZc3kQ.mkv
        ├── rtliSSbOCoA.mkv
        ├── t7LFwrCS1ws.mkv
        ├── tH-U-rFWnVQ.mkv
        └── vpTnIGxzLkI.mkv

2 directories, 18 files
```

#### Step 2: update video title cache
```
$ ./youtube-update-titles.sh LADYBABY
Checking video title for 0wowOJv4KnI...
New video title: LADYBABYチャンネル　Vol.3　THE潜入！レコーディング編
Checking video title for 3zWwd8n2JVI...
New video title: LADYBABY「アゲアゲマネー ～おちんぎん大作戦～／Age-Age Money」 Music Clip
Checking video title for FD9jZGRLhgM...
New video title: LADYBABYチャンネル　Vol.2　「ステージに立つために」
Checking video title for FGwD7APkGMA...
New video title: KARAOKE JOYSOUND「ニッポン饅頭 -Nippon Manju」Music Clip Ver.
Checking video title for G5qKciYpkgo...
New video title: [ビアちゃんver.] ニッポン饅頭 振り付け講座
Checking video title for H8eaZ3awQ_w...
New video title: [りえver.] ニッポン饅頭 振り付け講座
Checking video title for iPb4fns-hvY...
New video title: [れいver.] ニッポン饅頭 振り付け講座
Checking video title for jXEd-Xmo9Rs...
New video title: 【重大発表】4.13 3rdシングル発売 ＆ 4.15 国内初ワンマンライブ決定
Checking video title for KZSBZ3zAZKA...
New video title: LADYBABY LIVE Die Essigfabrik Köln (Deutschland) _ Dez. 5 2015
Checking video title for M8-vje-bq9c...
New video title: LADYBABY「ニッポン饅頭 _ Nippon Manju」Music Clip
Checking video title for MDi-P0G9VMU...
New video title: [ LADYBABY ] ニッポン饅頭 振り付け講座 Nippon Manju dancing school
Checking video title for NtwJ-YMyShY...
New video title: LADYBABYチャンネル　Vol.1　「ステージ衣装はどこ？」
Checking video title for OBGi4SOfzgQ...
New video title: LADYBABY LIVE @HYPER JAPAN 27-29 Nov 2015
Checking video title for PLEjiiZc3kQ...
New video title: KARAOKE DAM「ニッポン饅頭 -Nippon Manju」Funny Ver.
Checking video title for rtliSSbOCoA...
New video title: LADYBABYチャンネル　Vol.0　「誕生編」
Checking video title for t7LFwrCS1ws...
New video title: おまけ [ミキティー本物] ニッポン饅頭 振り付け講座
Checking video title for tH-U-rFWnVQ...
New video title: LADYBABY 'OVERTURE' ～MEMORIES of 2015 ～
Checking video title for vpTnIGxzLkI...
New video title: LADYBABY NYC LIVE at SOB's Oct 11 2015
```

Directory tree after the above command finishes:

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
    └── TITLE
        ├── 0wowOJv4KnI
        ├── 3zWwd8n2JVI
        ├── FD9jZGRLhgM
        ├── FGwD7APkGMA
        ├── G5qKciYpkgo
        ├── H8eaZ3awQ_w
        ├── iPb4fns-hvY
        ├── jXEd-Xmo9Rs
        ├── KZSBZ3zAZKA
        ├── M8-vje-bq9c
        ├── MDi-P0G9VMU
        ├── NtwJ-YMyShY
        ├── OBGi4SOfzgQ
        ├── PLEjiiZc3kQ
        ├── rtliSSbOCoA
        ├── t7LFwrCS1ws
        ├── tH-U-rFWnVQ
        └── vpTnIGxzLkI

3 directories, 36 files
```

The video titles are saved in these text files:  
```
$ cat SYNC/LADYBABY/TITLE/0wowOJv4KnI
LADYBABYチャンネル　Vol.3　THE潜入！レコーディング編
```

#### Step 3: rebuild symlinks
```
$ ./youtube-rebuild-links.sh LADYBABY
Creating link: SYNC/LADYBABY/TITLE/0wowOJv4KnI -> LADYBABYチャンネル　Vol.3　THE潜入！レコーディング編.mkv
Creating link: SYNC/LADYBABY/TITLE/3zWwd8n2JVI -> LADYBABY「アゲアゲマネー ～おちんぎん大作戦～／Age-Age Money」 Music Clip.mkv
Creating link: SYNC/LADYBABY/TITLE/FD9jZGRLhgM -> LADYBABYチャンネル　Vol.2　「ステージに立つために」.mkv
Creating link: SYNC/LADYBABY/TITLE/FGwD7APkGMA -> KARAOKE JOYSOUND「ニッポン饅頭 -Nippon Manju」Music Clip Ver..mkv
Creating link: SYNC/LADYBABY/TITLE/G5qKciYpkgo -> [ビアちゃんver.] ニッポン饅頭 振り付け講座.mkv
Creating link: SYNC/LADYBABY/TITLE/H8eaZ3awQ_w -> [りえver.] ニッポン饅頭 振り付け講座.mkv
Creating link: SYNC/LADYBABY/TITLE/iPb4fns-hvY -> [れいver.] ニッポン饅頭 振り付け講座.mkv
Creating link: SYNC/LADYBABY/TITLE/jXEd-Xmo9Rs -> 【重大発表】4.13 3rdシングル発売 ＆ 4.15 国内初ワンマンライブ決定.mkv
Creating link: SYNC/LADYBABY/TITLE/KZSBZ3zAZKA -> LADYBABY LIVE Die Essigfabrik Köln (Deutschland) _ Dez. 5 2015.mkv
Creating link: SYNC/LADYBABY/TITLE/M8-vje-bq9c -> LADYBABY「ニッポン饅頭 _ Nippon Manju」Music Clip.mkv
Creating link: SYNC/LADYBABY/TITLE/MDi-P0G9VMU -> [ LADYBABY ] ニッポン饅頭 振り付け講座 Nippon Manju dancing school.mkv
Creating link: SYNC/LADYBABY/TITLE/NtwJ-YMyShY -> LADYBABYチャンネル　Vol.1　「ステージ衣装はどこ？」.mkv
Creating link: SYNC/LADYBABY/TITLE/OBGi4SOfzgQ -> LADYBABY LIVE @HYPER JAPAN 27-29 Nov 2015.mkv
Creating link: SYNC/LADYBABY/TITLE/PLEjiiZc3kQ -> KARAOKE DAM「ニッポン饅頭 -Nippon Manju」Funny Ver..mkv
Creating link: SYNC/LADYBABY/TITLE/rtliSSbOCoA -> LADYBABYチャンネル　Vol.0　「誕生編」.mkv
Creating link: SYNC/LADYBABY/TITLE/t7LFwrCS1ws -> おまけ [ミキティー本物] ニッポン饅頭 振り付け講座.mkv
Creating link: SYNC/LADYBABY/TITLE/tH-U-rFWnVQ -> LADYBABY 'OVERTURE' ～MEMORIES of 2015 ～.mkv
Creating link: SYNC/LADYBABY/TITLE/vpTnIGxzLkI -> LADYBABY NYC LIVE at SOB's Oct 11 2015.mkv
```

Directory tree after the above command finishes:

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
    ├── LINK
    │   ├── KARAOKE DAM「ニッポン饅頭 -Nippon Manju」Funny Ver..mkv -> SYNC/LADYBABY/ID/SYNC/LADYBABY/TITLE/PLEjiiZc3kQ.mkv
    │   ├── KARAOKE JOYSOUND「ニッポン饅頭 -Nippon Manju」Music Clip Ver..mkv -> SYNC/LADYBABY/ID/SYNC/LADYBABY/TITLE/FGwD7APkGMA.mkv
    │   ├── LADYBABY LIVE Die Essigfabrik Köln (Deutschland) _ Dez. 5 2015.mkv -> SYNC/LADYBABY/ID/SYNC/LADYBABY/TITLE/KZSBZ3zAZKA.mkv
    │   ├── LADYBABY LIVE @HYPER JAPAN 27-29 Nov 2015.mkv -> SYNC/LADYBABY/ID/SYNC/LADYBABY/TITLE/OBGi4SOfzgQ.mkv
    │   ├── LADYBABY NYC LIVE at SOB's Oct 11 2015.mkv -> SYNC/LADYBABY/ID/SYNC/LADYBABY/TITLE/vpTnIGxzLkI.mkv
    │   ├── LADYBABY 'OVERTURE' ～MEMORIES of 2015 ～.mkv -> SYNC/LADYBABY/ID/SYNC/LADYBABY/TITLE/tH-U-rFWnVQ.mkv
    │   ├── LADYBABYチャンネル　Vol.0　「誕生編」.mkv -> SYNC/LADYBABY/ID/SYNC/LADYBABY/TITLE/rtliSSbOCoA.mkv
    │   ├── LADYBABYチャンネル　Vol.1　「ステージ衣装はどこ？」.mkv -> SYNC/LADYBABY/ID/SYNC/LADYBABY/TITLE/NtwJ-YMyShY.mkv
    │   ├── LADYBABYチャンネル　Vol.2　「ステージに立つために」.mkv -> SYNC/LADYBABY/ID/SYNC/LADYBABY/TITLE/FD9jZGRLhgM.mkv
    │   ├── LADYBABYチャンネル　Vol.3　THE潜入！レコーディング編.mkv -> SYNC/LADYBABY/ID/SYNC/LADYBABY/TITLE/0wowOJv4KnI.mkv
    │   ├── LADYBABY「アゲアゲマネー ～おちんぎん大作戦～／Age-Age Money」 Music Clip.mkv -> SYNC/LADYBABY/ID/SYNC/LADYBABY/TITLE/3zWwd8n2JVI.mkv
    │   ├── LADYBABY「ニッポン饅頭 _ Nippon Manju」Music Clip.mkv -> SYNC/LADYBABY/ID/SYNC/LADYBABY/TITLE/M8-vje-bq9c.mkv
    │   ├── [ LADYBABY ] ニッポン饅頭 振り付け講座 Nippon Manju dancing school.mkv -> SYNC/LADYBABY/ID/SYNC/LADYBABY/TITLE/MDi-P0G9VMU.mkv
    │   ├── [ビアちゃんver.] ニッポン饅頭 振り付け講座.mkv -> SYNC/LADYBABY/ID/SYNC/LADYBABY/TITLE/G5qKciYpkgo.mkv
    │   ├── [りえver.] ニッポン饅頭 振り付け講座.mkv -> SYNC/LADYBABY/ID/SYNC/LADYBABY/TITLE/H8eaZ3awQ_w.mkv
    │   ├── [れいver.] ニッポン饅頭 振り付け講座.mkv -> SYNC/LADYBABY/ID/SYNC/LADYBABY/TITLE/iPb4fns-hvY.mkv
    │   ├── おまけ [ミキティー本物] ニッポン饅頭 振り付け講座.mkv -> SYNC/LADYBABY/ID/SYNC/LADYBABY/TITLE/t7LFwrCS1ws.mkv
    │   └── 【重大発表】4.13 3rdシングル発売 ＆ 4.15 国内初ワンマンライブ決定.mkv -> SYNC/LADYBABY/ID/SYNC/LADYBABY/TITLE/jXEd-Xmo9Rs.mkv
    └── TITLE
        ├── 0wowOJv4KnI
        ├── 3zWwd8n2JVI
        ├── FD9jZGRLhgM
        ├── FGwD7APkGMA
        ├── G5qKciYpkgo
        ├── H8eaZ3awQ_w
        ├── iPb4fns-hvY
        ├── jXEd-Xmo9Rs
        ├── KZSBZ3zAZKA
        ├── M8-vje-bq9c
        ├── MDi-P0G9VMU
        ├── NtwJ-YMyShY
        ├── OBGi4SOfzgQ
        ├── PLEjiiZc3kQ
        ├── rtliSSbOCoA
        ├── t7LFwrCS1ws
        ├── tH-U-rFWnVQ
        └── vpTnIGxzLkI

4 directories, 54 files
```
