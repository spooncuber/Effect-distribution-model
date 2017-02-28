#!/bin/bash

CMD="ffmpeg -loop 1 -i title1.png -t 4 -r 25 -y clips/title1.mpg"

echo $CMD
eval $CMD || (echo failed title1; exit 1)

CMD="ffmpeg -loop 1 -i title2.png -t 6 -r 25 -y clips/title2.mpg"

echo $CMD
eval $CMD || (echo failed title2; exit 1)

V1s=260.0
V1e=286.8
V2s=85.0
V2e=90.2

S0t="'Pedestrian trajectories deflect in response to each other.'"
S0s=10
S0e=13.7
S1ta="'We build a data-driven model using a KDE to predict'"
S1tb="'who caused a deflection in a trajectory.'"
S1s=13.7
S1e=19.5
S2ta="'Prediction of focus agent (blue +) occurs where the'"
S2tb="'blue line turns green.'"
S2s=19.5
S2e=25.8
S3ta="'Model predicts likelihood that each person causes'"
S3tb="'deflection of focus agent (red dot is max likelihood).'"
S3s=25.8
S3e=32.1
S4ta="'The model also anticipates off-screen pedestrians'"
S4tb="'(red dot at right side of screen).'"
S4s=36.8

FILTER="-filter_complex \"
[2:v] trim=$V1s:$V1e, setpts=PTS-$V1s/TB [s1];
[2:v] trim=$V2s:$V2e, setpts=PTS-$V2s/TB [s2];
[0:v] [1:v] [s1] [s2] concat=4:1:0,
split=6 [aa] [bb] [cc] [dd] [ee] [ff];
[aa] trim=0:$S0s [one];
[bb] trim=$S0s:$S0e, setpts=PTS-$S0s/TB, drawtext=fontfile=/usr/share/fonts/truetype/freefont/FreeSerif.ttf:x=40:y=520:fontsize=30:box=1:boxcolor=black@1.0:fontcolor=white:text=$S0t [two];
[cc] trim=$S1s:$S1e, setpts=PTS-$S1s/TB,
drawtext=fontfile=/usr/share/fonts/truetype/freefont/FreeSerif.ttf:x=40:y=490:fontsize=30:box=1:boxcolor=black@1.0:fontcolor=white:text=$S1ta,
drawtext=fontfile=/usr/share/fonts/truetype/freefont/FreeSerif.ttf:x=40:y=520:fontsize=30:box=1:boxcolor=black@1.0:fontcolor=white:text=$S1tb
[three];
[dd] trim=$S2s:$S2e, setpts=PTS-$S2s/TB,
drawtext=fontfile=/usr/share/fonts/truetype/freefont/FreeSerif.ttf:x=40:y=490:fontsize=30:box=1:boxcolor=black@1.0:fontcolor=white:text=$S2ta,
drawtext=fontfile=/usr/share/fonts/truetype/freefont/FreeSerif.ttf:x=40:y=520:fontsize=30:box=1:boxcolor=black@1.0:fontcolor=white:text=$S2tb
[four];
[ee] trim=$S3s:$S3e, setpts=PTS-$S3s/TB,
drawtext=fontfile=/usr/share/fonts/truetype/freefont/FreeSerif.ttf:x=40:y=490:fontsize=30:box=1:boxcolor=black@1.0:fontcolor=white:text=$S3ta,
drawtext=fontfile=/usr/share/fonts/truetype/freefont/FreeSerif.ttf:x=40:y=520:fontsize=30:box=1:boxcolor=black@1.0:fontcolor=white:text=$S3tb
[five];
[ff] trim=$S4s, setpts=PTS-$S4s/TB,
drawtext=fontfile=/usr/share/fonts/truetype/freefont/FreeSerif.ttf:x=40:y=490:fontsize=30:box=1:boxcolor=black@1.0:fontcolor=white:text=$S4ta,
drawtext=fontfile=/usr/share/fonts/truetype/freefont/FreeSerif.ttf:x=40:y=520:fontsize=30:box=1:boxcolor=black@1.0:fontcolor=white:text=$S4tb
[six];
[one] [two] [three] [four] [five] [six] concat=6:1:0
\""

CMD="ffmpeg
-i clips/title1.mpg
-i clips/title2.mpg
-i EDM-completed.mp4 
$FILTER
-r 24 -y -an EDM-iros.mp4"

echo $CMD
eval $CMD || (echo failed final video; exit 1)
