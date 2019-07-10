#!/bin/bash

ffmpeg -r 10 -pattern_type glob -i "/home/roels/fig4/pyplot_s=5_2019-06-26T*.png" 2019-06-26_s5_1m.mp4
