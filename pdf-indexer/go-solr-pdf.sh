# Adapted from Marty Luries sample
# sample code not supported
# source from  example by Mark Brooks
# adapted to be fully scripted
# long instead of int for faceted salary search

# Some staging folder on the QSVM
export PROJECT_HOME=/home/cloudera/pdf-solr
# export SOLR_HOME=/opt/cloudera/parcels/CDH/lib/solr

# Not Ideal, but a symlink to this file referenced in solr-pdf.conf
ln -s /opt/cloudera/parcels/CDH/share/doc/search-1.0.0+cdh5.1.0+0/examples/solr-nrt/custom-mimetypes.xml /home/cloudera/pdf-indexer/custom-mimetypes.xml

# Collection name for SOLR
COLLECTION=INDEXED-PDF-DATA

# Clean UP
if [ "$1" == "clean" ]; then
  rm -rf $PROJECT_HOME
  solrctl collection --deletedocs $COLLECTION
  solrctl collection --delete $COLLECTION
  solrctl instancedir --delete $COLLECTION
  hadoop fs -rmdir --ignore-fail-on-non-empty /solr/$COLLECTION
  hadoop fs -rmdir -r /user/cloudera/pdfs
else

# Clean-up
rm -rf $PROJECT_HOME
mkdir $PROJECT_HOME

# Copy reference files for execution
cp solr-pdf.conf $PROJECT_HOME/
cp log4j-solr-pdf.properties $PROJECT_HOME/log4j.properties

# Initialize local directory with reference files to upload to solr/zookeeper
# See http://svn.apache.org/viewvc/lucene/dev/trunk/solr/example/solr/README.txt?view=markup
solrctl --zk localhost:2181/solr instancedir --generate $PROJECT_HOME/$COLLECTION

# Copy our schema to the ref dir
cp -f schema-solr-pdf.xml $PROJECT_HOME/$COLLECTION/conf/schema.xml

# Create the instancedirs (configs) and create the collection on a single shard (node of cluster)
solrctl --zk localhost:2181/solr instancedir --delete $COLLECTION
solrctl --zk localhost:2181/solr instancedir --create $COLLECTION $PROJECT_HOME/$COLLECTION
solrctl --zk localhost:2181/solr collection --delete $COLLECTION 
solrctl --zk localhost:2181/solr collection --create $COLLECTION -s 1

# Create intermediate folders
hadoop fs -rm -r  /user/cloudera/tmp/solroutdir
hadoop fs -mkdir -p  /user/cloudera/tmp/solroutdir
hadoop fs -mkdir -p /user/cloudera/pdfs
hadoop fs -put /home/cloudera/pdf-indexer/pdfs/* /user/cloudera/pdfs

## Do Indexing - Insert your source directory at end of hadoop jar command
# Dry-Run to test Morphline
hadoop jar /opt/cloudera/parcels/CDH/lib/solr/contrib/mr/search-mr-*-job.jar org.apache.solr.hadoop.MapReduceIndexerTool -D 'mapred.child.java.opts=-Xmx500m' --log4j $PROJECT_HOME/log4j.properties --morphline-file $PROJECT_HOME/solr-pdf.conf --output-dir hdfs://localhost:8020/user/cloudera/tmp/solroutdir --verbose --go-live --zk-host localhost:2181/solr --collection $COLLECTION --dry-run hdfs://localhost:8020/user/cloudera/pdfs

# Without Dry-run
#hadoop jar /opt/cloudera/parcels/CDH/lib/solr/contrib/mr/search-mr-*-job.jar org.apache.solr.hadoop.MapReduceIndexerTool -D 'mapred.child.java.opts=-Xmx500m' --log4j $PROJECT_HOME/log4j.properties --morphline-file $PROJECT_HOME/solr-pdf.conf --output-dir hdfs://localhost:8020/user/cloudera/tmp/solroutdir --verbose --go-live --zk-host localhost:2181/solr --collection $COLLECTION hdfs://localhost:8020/user/cloudera/pdfs

echo "Finished!"
echo SEARCH TIPS: 
echo wildcard syntax 'file*' 
echo proximity '"first managers" ~5'
echo or condition 'file manage*'

fi