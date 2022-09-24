#! /bin/sh

echo " $(free -h | head -n 2 | tail -n 1 | awk '{print $3"/"$2}') "
