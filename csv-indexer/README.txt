If you want to change the default collection name used, change the COLLECTION variable in:
go-solr-csv.sh
solr-csv.conf

Change your fields in solr-csv.conf

Change your fields in schema-solr-csv.xml

Change your in go-solr-csv.sh source folder for the map job, stubbed for hive warehouse folder by default

If you want to remove the index files, you should run delete docs using solrctl before docs using solrctl before
deleting and removing the collection.

solrctl collection --deletedocs INDEXED-CSV-DATA
solrctl collection --delete INDEXED-CSV-DATA
solrctl instancedir --delete INDEXED-CSV-DATA
