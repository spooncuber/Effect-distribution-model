#!/bin/bash

CMD="ffmpeg -loop 1 -i title1.png -t 4 -r 25 -y clips/title1.mpg"

echo $CMD
eval $CMD || (echo failed title1; exit 1)

CMD="ffmpeg -loop 1 -i title2.png -t 6 -r 25 -y clips/title2.mpg"

echo $CMD
eval $CMD || (echo failed title2; exit 1)

#V1s=260.0
#V1e=286.8
#V2s=85.0
#V2e=90.2

V1s=115.0
V1e=133.0
V2s=83.0
V2e=90.0
V3s=207.0
V3e=217.0
V4s=379.0
V4e=390.0

#S0t="'Pedestrian trajectories deflect in response to each other.'"
#S0s=10
#S0e=13.7
#S1ta="'We build a data-driven model using a KDE to predict'"
#S1tb="'who caused a deflection in a trajectory.'"
#S1s=13.7
#S1e=19.5
#S2ta="'Prediction of focus agent (blue +) occurs where the'"
#S2tb="'blue line turns green.'"
#S2s=19.5
#S2e=25.8
#S3ta="'Model predicts likelihood that each person causes'"
#S3tb="'deflection of focus agent (red dot is max likelihood).'"
#S3s=25.8
#S3e=32.1
#S4ta="'The model also anticipates off-screen pedestrians'"
#S4tb="'(red dot at right side of screen).'"
#S4s=36.8

S0t="'Pedestrian trajectories deflect in response to each other.'"
S0s=10
S0e=14.0
S1ta="'We build a data-driven model using a KDE to predict'"
S1tb="'who caused a deflection in a trajectory.'"
S1s=14.0
S1e=19.0
S2ta="'Prediction of focus agent (blue +) occurs where the'"
S2tb="'blue line turns green (avoiding case).'"
S2s=19.0
S2e=23.0
S3ta="'Model predicts likelihood that each person causes'"
S3tb="'deflection of focus agent (red dot is max likelihood).'"
S3s=23.0
S3e=27.0
S4ta="'The model also anticipates off-screen pedestrians'"
S4tb="'(red dot at right side of screen).'"
S4s=28.0
S4e=34.0
S4ta="'The pedestrian is influencing by environment obstacle,'"
S4tb="'which is a limitation here.'"
S5s=35.0
S5e=44.0
S4ta="'The pedestrian is influenced by many pedestrians'"
S4tb="'at once, which is remains a hard problem.'"
S6s=45.0
S6e=55.0


FILTER="-filter_complex \"
[2:v] trim=$V1s:$V1e, setpts=PTS-$V1s/TB [s1];
[2:v] trim=$V2s:$V2e, setpts=PTS-$V2s/TB [s2];
[2:v] trim=$V3s:$V3e, setpts=PTS-$V3s/TB [s3];
[2:v] trim=$V4s:$V4e, setpts=PTS-$V4s/TB [s4];
[0:v] [1:v] [s1] [s2] [s3] [s4] concat=6:1:0,
split=6 [aa] [bb] [cc] [dd] [ee] [ff];
[aa] trim=0:$S0s [one];
[bb] trim=$S0s:$S0e, setpts=PTS-$S0s/TB, drawtext=fontfile=/usr/share/fonts/truetype/freefont/FreeSerif.ttf:x=40:y=20:fontsize=30:box=1:boxcolor=black@1.0:fontcolor=white:text=$S0t [two];
[cc] trim=$S1s:$S1e, setpts=PTS-$S1s/TB,
drawtext=fontfile=/usr/share/fonts/truetype/freefont/FreeSerif.ttf:x=40:y=20:fontsize=30:box=1:boxcolor=black@1.0:fontcolor=white:text=$S1ta,
drawtext=fontfile=/usr/share/fonts/truetype/freefont/FreeSerif.ttf:x=40:y=50:fontsize=30:box=1:boxcolor=black@1.0:fontcolor=white:text=$S1tb
[three];
[dd] trim=$S2s:$S2e, setpts=PTS-$S2s/TB,
drawtext=fontfile=/usr/share/fonts/truetype/freefont/FreeSerif.ttf:x=40:y=20:fontsize=30:box=1:boxcolor=black@1.0:fontcolor=white:text=$S2ta,
drawtext=fontfile=/usr/share/fonts/truetype/freefont/FreeSerif.ttf:x=40:y=50:fontsize=30:box=1:boxcolor=black@1.0:fontcolor=white:text=$S2tb
[four];
[ee] trim=$S3s:$S3e, setpts=PTS-$S3s/TB,
drawtext=fontfile=/usr/share/fonts/truetype/freefont/FreeSerif.ttf:x=40:y=20:fontsize=30:box=1:boxcolor=black@1.0:fontcolor=white:text=$S3ta,
drawtext=fontfile=/usr/share/fonts/truetype/freefont/FreeSerif.ttf:x=40:y=50:fontsize=30:box=1:boxcolor=black@1.0:fontcolor=white:text=$S3tb
[five];
[ff] trim=$S4s, setpts=PTS-$S4s/TB,
drawtext=fontfile=/usr/share/fonts/truetype/freefont/FreeSerif.ttf:x=40:y=20:fontsize=30:box=1:boxcolor=black@1.0:fontcolor=white:text=$S4ta,
drawtext=fontfile=/usr/share/fonts/truetype/freefont/FreeSerif.ttf:x=40:y=50:fontsize=30:box=1:boxcolor=black@1.0:fontcolor=white:text=$S4tb
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
