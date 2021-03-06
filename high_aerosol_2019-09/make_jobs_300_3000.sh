#!/bin/bash

# template directory:
TEMPL_DIR=$(dirname $(readlink -f ${0}))/../templates/bwd
# directory in to which directories will be copied / models will be run:
OUT_DIR=$(dirname $(readlink -f ${0}))/300_3000
# job running script:
RUN_SCRIPT=$(dirname $(readlink -f ${0}))/../scripts/run_job.sh

# start time (2019-09-27 12:00):
START_TIME=1569582000
# end time (2019-09-16 12:00):
END_TIME=1568631600
# interval between runs (6 hours):
RUN_INT=21600
# run length (14 days):
RUN_LEN=1209600

# data type, ei or ea:
DATA_TYPE='ea'

# make sure OUT_DIR exists:
mkdir -p ${OUT_DIR}

while [ ${START_TIME} -ge ${END_TIME} ]
do
  # start date:
  SD=$(date -d @${START_TIME} +%Y%m%d)
  # start hour:
  SH=$(date -d @${START_TIME} +%H%M%S)
  # run end time:
  ET=$((${START_TIME} - ${RUN_LEN}))
  # end date:
  ED=$(date -d @${ET} +%Y%m%d)
  # end hour:
  EH=$(date -d @${ET} +%H%M%S)
  # for each output height:
  for REL_HEIGHT in 3 15 60 400 1000 1500 2000 3000
  do
    # run dir:
    RD="${OUT_DIR}/${SD}${SH}-${ED}${EH}_REL_${REL_HEIGHT}_300_3000"
    # create directory for this run:
    rm -fr ${RD}
    \cp -r ${TEMPL_DIR} ${RD}
    # update pathnames:
    sed -i "s|XXX|${RD}|g" ${RD}/pathnames
    sed -i "s|XX|${DATA_TYPE}|g" ${RD}/pathnames
    # update outgrid file:
    sed -i "s|XXX|300,3000|g" ${RD}/options/OUTGRID
    sed -i "s|-179.00|-179.50|g" ${RD}/options/OUTGRID
    # update release file:
    sed -i "s|XXXXXXXX|${SD}|g" ${RD}/options/RELEASES
    sed -i "s|XXXXXX|${SH}|g" ${RD}/options/RELEASES
    sed -i "s|XXX|${REL_HEIGHT}|g" ${RD}/options/RELEASES
    # update command file:
    sed -i "s|XXXEDXXX|${SD}|g" ${RD}/options/COMMAND
    sed -i "s|XXETXX|${SH}|g" ${RD}/options/COMMAND
    sed -i "s|XXXSDXXX|${ED}|g" ${RD}/options/COMMAND
    sed -i "s|XXSTXX|${EH}|g" ${RD}/options/COMMAND
    # run job script:
    \cp ${RUN_SCRIPT} ${RD}/run_job.sh
    # increase run time:
    sed -i "s|0:20:00|0:40:00|g" ${RD}/run_job.sh
    chmod 755 ${RD}/run_job.sh
  done
  # increment run start time:
  START_TIME=$((${START_TIME} - ${RUN_INT}))
done
