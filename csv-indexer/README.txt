* csv indexer, but the default file is tab delimited.

* CSV morphline command takes separator param.

* This is a self contained test data set with csv delimiter.  The idea is to be able
to test that you can get SOLR working and indexing the test data set csv delimited, then
modify from there for what you ACTUALLY need.
  *upload the sample_07 csv file to /user/cloudera to test

To adapt this for different data:
* If you want to change the default collection name used, change the COLLECTION variable in:
go-solr-csv.sh
solr-csv.conf

* Change your fields in solr-csv.conf

* Change your fields in schema-solr-csv.xml

* Change your in go-solr-csv.sh source folder for the map job, stubbed for hive warehouse
folder by default

* If you want to remove the index files after a demo or to cleanup, you should run delete docs using solrctl before
deleting and removing the collection.

* run go-solr-csv.sh clean to get to 'clean' slate