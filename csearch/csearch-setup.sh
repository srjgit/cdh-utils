## BEGIN generate initial configs to setup Instance-dir, and Collection def
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
## END generate initial configs to setup Instance-dir, and Collection def

###### BEGIN Initiate MR indexing ######
cd $HOME/rawidx_configs

hadoop --config /etc/hadoop/conf.cloudera.mapreduce1 jar /opt/cloudera/parcels/CDH-5.3.2-1.cdh5.3.2.p0.10/jars/search-mr-1.0.0-cdh5.3.2-job.jar org.apache.solr.hadoop.MapReduceIndexerTool --morphline-file /opt/cloudera/parcels/CDH-5.3.2-1.cdh5.3.2.p0.10/share/doc/search-1.0.0+cdh5.3.2+0/examples/solr-nrt/test-morphlines/readLine.conf --collection rawidx --solr-home-dir $HOME/rawidx_configs --output-dir hdfs://mycdh-nnha/user/sreejith/rawidx --shards 1 hdfs:///user/sreejith/rawdata_path/part-\*

###### END Initiate MR indexing ######

##### using dry-run format for troubleshooting #####
hadoop --config /etc/hadoop/conf.cloudera.mapreduce1 jar /opt/cloudera/parcels/CDH-5.3.2-1.cdh5.3.2.p0.10/jars/search-mr-1.0.0-cdh5.3.2-job.jar org.apache.solr.hadoop.MapReduceIndexerTool --morphline-file /opt/cloudera/parcels/CDH-5.3.2-1.cdh5.3.2.p0.10/share/doc/search-1.0.0+cdh5.3.2+0/examples/solr-nrt/test-morphlines/readLine.conf --collection rawidx --solr-home-dir $HOME/rawidx_configs --output-dir hdfs://mycdh-nnha/user/sreejith/rawidx --shards 1 --dry-run --log4j /u/sreejith/arsidx_configs/conf/log4j.properties hdfs:///user/sreejith/rawdata_path/part-\*

##### BEGIN Edit morphline conf to generate Composite key #####
addValues {
    id : ["@{field1}_@{field2}"]
}
##### END Edit morphline conf to generate Composite key #####

##### BEGIN Edit morphline conf to auto generate UUID #####
{
generateUUID {
        field : id
    }
}

#where id is defined in schema.xml as follows...
   <field name="id" type="string" indexed="true" stored="true" required="true" />

    <fieldType name="uuid" class="solr.UUIDField" indexed="true" />

#and turn on the UUID updater factory in solrconfig.xml as follows...
<updateRequestProcessorChain name="uuid">
     <processor class="solr.UUIDUpdateProcessorFactory">
           <str name="fieldName">id</str>
     </processor>
     <processor class="solr.RunUpdateProcessorFactory" />
  </updateRequestProcessorChain>

##### END Edit morphline conf to generate Composite key #####


