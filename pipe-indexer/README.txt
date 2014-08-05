* This is a self contained test data set with pipe delimiter.  The idea is to be able
to test that you can get SOLR working and indexing the test data set pipe delimited, then
modify from there for what you ACTUALLY need.
  *upload the global terrorism database . txt file to /user/cloudera to test

To adapt this for different data:
* If you want to change the default collection name used, change the COLLECTION variable in:
go-solr-pipe.sh
solr-pipe.conf

* Change your fields in solr-pipe.conf

* Change your fields in schema-solr-pipe.xml

* Change your file location in go-solr-pipe.sh source folder for the map job, stubbed for
/user/cloudera/global_terrorism_database.txt by default

* If you want to remove the index files after a demo or to cleanup, you should run delete docs using solrctl before
deleting and removing the collection.

* run go-solr-pipe.sh clean to get to 'clean' slate