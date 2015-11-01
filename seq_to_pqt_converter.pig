-- script takes SequenceFile path as input param
-- splits the key by '_' and writes the elements including the value part into output_file

REGISTER /opt/cloudera/parcels/CDH/lib/pig/piggybank.jar
REGISTER /opt/cloudera/parcels/CDH/lib/parquet-pig-1.3.1.jar;
REGISTER /opt/cloudera/parcels/CDH/lib/parquet-column-1.3.1.jar;
REGISTER /opt/cloudera/parcels/CDH/lib/parquet-common-1.3.1.jar;
REGISTER /opt/cloudera/parcels/CDH/lib/parquet-format-2.0.0.jar;
REGISTER /opt/cloudera/parcels/CDH/lib/parquet-hadoop-1.3.1.jar;
REGISTER /opt/cloudera/parcels/CDH/lib/parquet-pig-1.3.1.jar;
REGISTER /opt/cloudera/parcels/CDH/lib/parquet-encoding-1.3.1.jar;


DEFINE SequenceFileLoader org.apache.pig.piggybank.storage.SequenceFileLoader();
data = LOAD ‘$input' USING SequenceFileLoader() AS(key : chararray, content :  chararray);
describe data;

splt = foreach data generate FLATTEN(STRSPLIT($0, '_')) AS (id:chararray, field: chararray ), $1 AS (content: chararray) ;
describe splt;

STORE  splt INTO 'output_file.parquet' USING parquet.pig.ParquetStorer;

