Most Viewed Pages
=================

Most Viewed Pages is a ruby script that:

1) Receives a log as argument e.g.: 

```
./parser.rb webserver.log
```

where the webserver.log is in the format:

```
/help_page/1 126.318.035.038
/contact 184.123.665.067
/home 184.123.665.067
```

i.e. a webpage followed by an ip address

2)  Returns the following:

> list of webpages with most page views ordered from most pages views to least page views e.g.:
```
/home 90 visits 
/index 80 visits 
etc... 
```

> list of webpages with most unique page views also ordered e.g.:
```
/about/2 8 unique views 
/index 5 unique views 
etc...
```

## TODO

* [ ] unique visits
* [ ] test coverage
* [ ] command line calling