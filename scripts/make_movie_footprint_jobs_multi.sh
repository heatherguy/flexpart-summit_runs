#!/bin/bash

# job running script:
RUN_SCRIPT=$(dirname $(readlink -f ${0}))/run_movie_footprint_job_multi.sh

# all model runs: 
for DIR in $(\ls -1 multi/ | egrep -o 'REL_[0-9]+?' | sort -u)
do
  # make directory for output:
  mkdir -p movies_footprint_multi/${DIR}
  # run job script:
  \cp ${RUN_SCRIPT} movies_footprint_multi/${DIR}/run_movie_footprint_job.sh
  chmod 755 movies_footprint_multi/${DIR}/run_movie_footprint_job.sh
  # update script:
  sed -i "s|XXXXX|${DIR}|g" \
    movies_footprint_multi/${DIR}/run_movie_footprint_job.sh
done
