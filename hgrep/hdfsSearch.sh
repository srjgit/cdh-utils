#!/bin/bash 
## ./hdfsSearch.sh <hdfs:///input-data-location> <search-string>

INPUT=$1
PAT=$2
if [[ -z "$INPUT" ]]; then
    echo "input path required"
    echo "./hdfsSearch.sh <hdfs:///input-data-location> <search-string>"
    exit
fi
if [[ -z "$PAT" ]]; then
    echo "search pattern required"
    echo "./hdfsSearch.sh <hdfs:///input-data-location> <search-string>"
    exit
fi
HADOOP_BIN=/Users/msreejith/Desktop/Projects/hadoop/bin
HADOOP_STREAMING_LOC=/Users/msreejith/Desktop/Projects/hadoop/contrib/streaming/
${HADOOP_BIN}/hadoop fs -rm -r -f hdfs:///tmp/grepOut

echo "running search: ${HADOOP_BIN}/hadoop ${HADOOP_STREAMING_LOC}/hadoop-streaming-2.5.0-cdh5.3.2.jar -D mapred.reduce.tasks=0 -input $INPUT -mapper \"python hdfsGrep.py $PAT\" -file hdfsGrep.py -output /tmp/grepOut"

${HADOOP_BIN}/hadoop jar ${HADOOP_STREAMING_LOC}/hadoop-streaming-2.5.0-cdh5.3.2.jar -D mapred.reduce.tasks=0 -input $INPUT -mapper "python hdfsGrep.py \"$PAT\"" -file hdfsGrep.py -output /tmp/grepOut -file ${HADOOP_STREAMING_LOC}/hadoop-streaming-2.5.0-cdh5.3.2.jar

