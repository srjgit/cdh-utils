## generate initial configs
solrctl instancedir --generate $HOME/rawidx_configs

## modify the solrconfig.xml file & update in section to hdfs path
## <directoryFactory name="DirectoryFactory" class="${solr.directoryFactory:org.apache.solr.core.HdfsDirectoryFactory}">
##    <str name="solr.hdfs.home">hdfs://mycdh-nnha/solr</str>
##
## ensure path is created : hadoop fs -ls /solr/

cd $HOME
# solrctl instancedir --delete rawidx
solrctl instancedir --create rawidx rawidx_configs/
# solrctl collection --delete rawidx
solrctl collection --create rawidx -s 2 -r 2
# check http://localhost:8983/solr/#/

###### collection created, now over to MR indexing ######
cd $HOME/rawidx_configs

hadoop --config /etc/hadoop/conf.cloudera.mapreduce1 jar /opt/cloudera/parcels/CDH-5.3.2-1.cdh5.3.2.p0.10/jars/search-mr-1.0.0-cdh5.3.2-job.jar org.apache.solr.hadoop.MapReduceIndexerTool --morphline-file /opt/cloudera/parcels/CDH-5.3.2-1.cdh5.3.2.p0.10/share/doc/search-1.0.0+cdh5.3.2+0/examples/solr-nrt/test-morphlines/readLine.conf --collection rawidx --solr-home-dir $HOME/rawidx_configs --output-dir hdfs://mycdh-nnha/user/sreejith/rawidx --shards 1 hdfs:///user/sreejith/rawdata_path/part-\*

