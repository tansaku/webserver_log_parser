Webserver Log Parser
====================

Webserver Log Parser is a ruby script that:

1) Receives a log file as argument e.g.: 

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

2) Returns the following:

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

## Requirements

The code is written and tested against:

* [Ruby](https://www.ruby-lang.org/) 2.7.2

## Installation

1. Clone the repository

```sh
$ git clone https://github.com/tansaku/webserver_log_parser
```

2. Move into directory and install dependencies

```sh
$ cd webserver_log_parser
$ bundle
```

3. Run from the command line:

```sh
$  ./parser.rb webserver.log
processing 'webserver.log' ...

displaying up to top 10 in each category

+--------------+-----------+
|     Most page views      |
+--------------+-----------+
| Page         | Visits    |
+--------------+-----------+
| /about/2     | 90 visits |
| /contact     | 89 visits |
| /index       | 82 visits |
| /about       | 81 visits |
| /help_page/1 | 80 visits |
| /home        | 78 visits |
+--------------+-----------+

+--------------+-----------+
|  Most unique page views  |
+--------------+-----------+
| Page         | Visits    |
+--------------+-----------+
| /index       | 23 visits |
| /home        | 23 visits |
| /contact     | 23 visits |
| /help_page/1 | 23 visits |
| /about/2     | 22 visits |
| /about       | 21 visits |
+--------------+-----------+
```
## Tests

Run the test suite (and linting via rubocop) by the following command

```sh
$ bundle exec rake
```

which should produce output like the following:

```
Running RuboCop...
Inspecting 16 files
................

16 files inspected, no offenses detected
/Users/tansaku/.rvm/rubies/ruby-2.7.2/bin/ruby -I/Users/tansaku/.rvm/gems/ruby-2.7.2/gems/rspec-core-3.10.0/lib:/Users/tansaku/.rvm/gems/ruby-2.7.2/gems/rspec-support-3.10.0/lib /Users/tansaku/.rvm/gems/ruby-2.7.2/gems/rspec-core-3.10.0/exe/rspec --pattern spec/\*\*\{,/\*/\*\*\}/\*_spec.rb

Full System
  processes file to produce correct output
  bigger more realistic file
    processes file to produce correct output

LineParser
  lines with tabs
    parses successfully
  lines with spaces
    parses successfully
  lines without spaces or tabs
    logs an error and adds nothing to the index

WebPageVisits
  should sort by number of ips by default
  should present itself clearly
  should present unique visits clearly
  can have different ips added over time
  can have the same ips added over time
  rejects to_s arg other than number or unique_number features

WebserverLogParser
  single log entry
    has one visit
  double log entry
    has two visits
  triple log entry with duplication
    has two visits
  bad log entry
    is ignored

Pluralize
  correctly presents singular form
  correctly presents default plural form
  correctly presents plural form for exceptions

Finished in 0.73058 seconds (files took 0.48907 seconds to load)
18 examples, 0 failures

Coverage report generated for RSpec to /Users/tansaku/Documents/GitHub/tansaku/webserver_log_parser/coverage. 64 / 64 LOC (100.0%) covered.
```

## Approach

This Webserver Log Parser uses a `WebPageVisits` class to represent the collection of visits to a particular page.  The WebPageVisits class stores the number of visits and unique visits (calculating unique visits by taking the length of a Set version of the array of ips).  By default it sorts on overall number of visits, and provides a parameterized `to_s` method to allow a pretty print output of either the total or unique number of visits to a given page. This relies on a `Pluralize` class to correctly format "visit" vs "visits" although the `to_s` method is no longer used with the table formatted output.

The main class is `WebserverLogParser` which by default will parse a file called `webserver.log` that is assumed to be on the root of the project, although the file parsed can be adjusted by specifying the filename argument to the `parse` class method.  The file is broken up by using `read`, splitting on `\n` and an index formed using a hash to store  `WebPageVisits` objects that contain the ip visits for each page, keyed against the page name. A `LineParser` class is used to manage the process of splitting the individual lines and creating or updating the `WebPageVisits` objects. The index values are then converted to an array of `WebPageVisits` objects, which can then be passed to a presenter `WebPageVisitsPresenter` to be sorted by total number or unique number of visits, and reversed to ensure the most visited comes first in the array; as well as formatted into a nice table output via [Terminal Table](https://github.com/tj/terminal-table). 

The `parser.rb` file can be run from the command line and uses [Commander](https://github.com/commander-rb/commander) for command line processing.

## Possible Improvements

### Even Smaller Classes?

Earlier versions of the  `WebserverLogParser` could have been considered to be doing too much in terms of reading the file, and splitting the lines and constructing the main data structure.  Although a counter argument would be that the `WebServerLogParser` class never exceeded the 100 line limit that Sandi Metz suggests to be the maximum suggested class size.

The danger with too many small classes is that it becomes difficult to follow the flow of execution.  However with good tests and test coverage it was straightforward to extract private methods such as the `parse_line` method in the `WebServerLogParser` into a `LineParser` class with "single" responsibility for line parsing.  This does require it to have a reference to the larger data structure it needs to keep track of the aggregate information, which is maybe hinting at the need for another class.  The extraction of the `parse_line` private method to a LineParser method has been included, although this has led to a slight drop in speed performance; it's trade offs all the way.

### Performance (Speed)?

The system might have to cope with very long webserver logs and the approach taken has not been extensively optimised for either time (speed) or space (memory) performance.  The focus was on getting something that would work robustly with good test coverage.  Performance improvements might come from different data structures used to manage the data as it accumulates.  At least for the current code the visits map is created once and then sorting is performed on that.  The results of the sorting could be memoized, but that feels like premature optimization in the absence of specific performance requirements.

No performance requirements were given in the specification for this work, but a speed performance assessment framework has been added and can be executed as follows:

```
$ bundle exec rake performance
              user     system      total        real
page views:  2.649054   0.102504   2.751558 (  2.759408)
unique:   2.668389   0.095945   2.764334 (  2.770790)
```

to compare the performance of calculating total and unique page views. The results shown above are for the first version of the system.   An alternative approach involving restructuring `webserver_log_parser` to create the WebPageVisits object as the log was processed was tried where the `parse_line` operation was adjusted to the following:

```rb
  if index[page]
    index[page].add(ip)
  else
    index[page] = WebPageVisits.new(page, [ip])
  end
```

rather than 

```rb
  if index[page]
    index[page] << ip
  else
    index[page] = [ip]
  end
```

Creating the WebPageVisits object inside the main loop gave the following results:

```
page views:  2.207392   0.092413   2.299805 (  2.302135)
unique:   2.740700   0.096164   2.836864 (  2.840105)
```

showing improvement in the speed with which we could generate the page views. Repeated runs suggest that the slight deterioration of the unique views was within the range of natural variation between performance assessment runs.

There's a good stack overflow post on the relative peformance of reading files in ruby:

https://stackoverflow.com/a/12412543

which indicates that `read.split` can be more performant than `readlines` but there is no noticeable performance improvement for this project by switching to `read.split` on the size of files used.

https://stackoverflow.com/a/14655895

Suggests using `each_line` but that also does not improve performance.  There's also:

https://felipeelias.github.io/ruby/2017/01/02/fast-file-processing-ruby.html

which suggests `File.open(filename,'r')`, but that also does not lead to any improvement (or `IO.foreach`?).  It seems that to see these differences we would need to assess performance with a much larger file.  The kaggle.txt file shows no significant timing differences, but kaggle.txt is only 470Kb, so likely we need a multiple megabyte file to show any difference.  We could search for one or construct one by having it repeat internally 10 or 100 times ... 

### Performance (Memory)?

One might be concerned about the amount of memory being taken up by the implementation but memory profiling is straightforward using this gem:

https://github.com/SamSaffron/memory_profiler

which is integrated into the current system and can be used to assess the memory requirements of calculating the page views like so:

```
$ bundle exec rake performance_memory
```

The output is extensive but here are some highlights from the current implementation:

```
allocated memory by class
-----------------------------------
     65434  String
     36008  LineParser
     30592  Array
      8424  File
       440  WebPageVisits
       232  Hash
        40  WebserverLogParser


allocated objects by class
-----------------------------------
      1506  String
       511  Array
       500  LineParser
         6  WebPageVisits
         1  File
         1  Hash
         1  WebserverLogParser        
```

Should memory be constrained it is a straightforward matter to compare alternate implementations in terms of their memory usage.  There is no need to instantiate as many objects as the current implementation does, but there's a trade off between code maintainabilty/readability and optimizing for one kind of performance or another.  In the absence of specific requirements it makes sense to leave the code in a more readable/maintainable state, rather than using lots of class methods to avoid instantiating extra objects, such as the LineParser. 

### Use of `send` in `web_page_visits_presenter.rb`

In order to mimimize method length in `web_page_visits_presenter.rb` the `send` method is used as part of a generic `output_table` method which is perhaps not ideal.  It might be better to pass a block rather then using `send` which could access private methods ... 

### Log Formatting Requirements?

The first version of the code assumed a single space separating the path and ip address and no other spaces, and skiped log entries that did't meet these requirements, while logging the issue.  This did not work well with more realistic data which had tabs and/or multiple whitespaces.  The code was adjusted to allow this data to be handled as follows in `lib/webserver_log_parser.rb`:

```rb
SEPARATOR = /\t+|\s+/.freeze

...
  raise 'no space characters or tabs' unless line.match?(SEPARATOR)
```

However this caused a performance deterioration as we shall see in the section below. 

### More Realistic Data

Some more realistic log data was obtained from https://www.kaggle.com/shawon10/web-log-dataset and is included in the repo - the results of operating on the more realistic log data are as follows:

```
$ ./parser.rb fixtures/kaggle.txt 
processing 'fixtures/kaggle.txt' ...

displaying up to top 10 in each category

+-----------------------------------------------------------------+-------------+
|                                Most page views                                |
+-----------------------------------------------------------------+-------------+
| Page                                                            | Visits      |
+-----------------------------------------------------------------+-------------+
| /login.php                                                      | 3287 visits |
| /home.php                                                       | 2642 visits |
| /js/vendor/modernizr-2.8.3.min.js                               | 1415 visits |
| /                                                               | 861 visits  |
| /contestproblem.php?name=RUET%20OJ%20Server%20Testing%20Contest | 467 visits  |
| /css/normalize.css                                              | 408 visits  |
| /css/bootstrap.min.css                                          | 404 visits  |
| /css/font-awesome.min.css                                       | 399 visits  |
| /css/style.css                                                  | 395 visits  |
| /css/main.css                                                   | 394 visits  |
| /js/vendor/jquery-1.12.0.min.js                                 | 387 visits  |
+-----------------------------------------------------------------+-------------+

+--------------------------------------------------------------+----------+
|                         Most unique page views                          |
+--------------------------------------------------------------+----------+
| Page                                                         | Visits   |
+--------------------------------------------------------------+----------+
| /login.php?value=fail                                        | 5 visits |
| /contestsubmission.php?id=16                                 | 5 visits |
| /countdown.php?name=RUET%20OJ%20Server%20Testing%20Contest   | 5 visits |
| /details.php?id=44                                           | 5 visits |
| /compiler.php                                                | 5 visits |
| /allsubmission.php?page=2                                    | 5 visits |
| /contest.php                                                 | 5 visits |
| /details.php?id=46                                           | 5 visits |
| /details.php?id=42                                           | 5 visits |
| /details.php?id=45                                           | 5 visits |
| /contestproblem.php?name=RUET%20OJ%20TLE%20Testing%20Contest | 5 visits |
+--------------------------------------------------------------+----------+


```

Unfortunately the introduction of regex matching in the main parsing loop led to a significant deterioration in performance:

```
              user     system      total        real
page views:  7.194163   0.323039   7.517202 (  7.537447)
unique:   7.854744   0.347131   8.201875 (  8.243495)
```

The performance was returned to roughly previous levels by replacing the more complex regex with a simpler check for inclusion of individual tabs and spaces:

```rb
    raise 'no space characters or tabs' unless separator_type(line)

    page, ip = line.split(separator_type(line))

  ...

  def separator_type(line)
    return TAB_SEPARATOR if line.include?(TAB_SEPARATOR)
    return SPACE_SEPARATOR if line.include?(SPACE_SEPARATOR)

    nil
  end
```

```
$ bundle exec rake performance
              user     system      total        real
page views:  2.817147   0.094838   2.911985 (  2.914998)
unique:   3.363575   0.104883   3.468458 (  3.472971)
```

Thus demonstrating how we can improve the code by a data driven approach that provides specific evidence for the pros and cons of any particular change.


## Global variables?  

The repo includes some constants, such as the logger:

```rb
LOGGER = Logger.new(STDOUT)
LOGGER.level = Logger::WARN
```

and some text elements:

```rb
SPACE_SEPARATOR = ' '
TAB_SEPARATOR = "\t"
```

but otherwise global variables have been avoided.  Some argue that `attr_accessor` is preferable, but I would suggest it is a design smell that you're exposing too much of objects to manipulation. As regards logging, Rails has global logging system.  We could trivially change the logger to be something that's passed to all classes, but that seems overkill for this small project.