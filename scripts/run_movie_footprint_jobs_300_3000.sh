#!/bin/bash

ALL_DIRS=$(\ls -1d movies_footprint_300_3000/*)

for DIR in ${ALL_DIRS}
do
  pushd ${DIR}
  if [ ! -e *.mp4 ] ; then
    qsub run_movie_footprint_job.sh
  fi
  popd
done
