Webserver Log Parser
====================

Webserver Log Parser is a ruby script that:

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

* [Ruby](https://www.ruby-lang.org/) 2.6.5

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

+--------------+--------+
|    Most Page Views    |
+--------------+--------+
| Page         | Visits |
+--------------+--------+
| /about/2     | 90     |
| /contact     | 89     |
| /index       | 82     |
| /about       | 81     |
| /help_page/1 | 80     |
| /home        | 78     |
+--------------+--------+
+--------------+--------+
|    Most Page Views    |
+--------------+--------+
| Page         | Visits |
+--------------+--------+
| /index       | 23     |
| /home        | 23     |
| /contact     | 23     |
| /help_page/1 | 23     |
| /about/2     | 22     |
| /about       | 21     |
+--------------+--------+
```
## Tests

Run the test suite (and linting via rubocop) by the following command

```sh
$ bundle exec rake
```

which should produce output like the following:

```
Running RuboCop...
Inspecting 12 files
............

12 files inspected, no offenses detected
/Users/tansaku/.rvm/rubies/ruby-2.6.5/bin/ruby -I/Users/tansaku/.rvm/gems/ruby-2.6.5/gems/rspec-core-3.9.1/lib:/Users/tansaku/.rvm/gems/ruby-2.6.5/gems/rspec-support-3.9.2/lib /Users/tansaku/.rvm/gems/ruby-2.6.5/gems/rspec-core-3.9.1/exe/rspec --pattern spec/\*\*\{,/\*/\*\*\}/\*_spec.rb

Pluralize
  correctly presents singular form
  correctly presents default plural form
  correctly presents plural form for exceptions

WebPageVisits
  should sort by number of ips by default
  should present itself clearly
  should present unique visits clearly
  rejects to_s arg other than number or unique_number features

WebserverLogParser
  single log entry
    behaves like single entry log parser
      returns correct results for multiple log entries
  double log entry
    behaves like multiple entry log parser
      returns correct results for multiple log entries
  triple log entry
    behaves like multiple entry log parser
      returns correct results for multiple log entries
    behaves like multiple entry log parser
      returns correct results for multiple log entries
  bad log entry
    behaves like multiple entry log parser
      returns correct results for multiple log entries

Finished in 0.02267 seconds (files took 0.2259 seconds to load)
12 examples, 0 failures


COVERAGE: 100.00% -- 48/48 lines in 3 files
```

## Approach

Uses a `WebPageVisits` class to represent the collection of visits to a particular page.  The WebPageVisits class stores the number of visits and unique visits (calculating unique visits by taking the length of a Set version of the array of ips).  By default it sorts on overall number of visits, and provides a parameterized `to_s` method to allow a pretty print output of either the total or unique number of visits to a given a page. This relies on a `Pluralize` class to correctly format "visit" vs "visits" although the `to_s` method is no longer used with the table formatted output.

The main class is `WebserverLogParser` which by default will parse a file called `webserver.log` that is assumed to be on the root of the project, although the file parsed can be adjusted by specificing the filename argument to the `parse` class method.  The file is broken up using `readlines` and an index formed using a hash to store an array of the ips associated with a single page, keyed against the page name as a string. The index is automatically coverted into a an array of `WebPageVisits` objects, which can then be sorted by total number or unique number of visits, and reversed to ensure the most visited comes first in the array. 

A `parser.rb` file can be run from the command line and uses [Commander](https://github.com/commander-rb/commander) for command line processing and management and [Terminal Table](https://github.com/tj/terminal-table) to format the results nicely on the terminal.

## Possible Improvements

### Different approach to RSpec organisation?

The RSpec block for `WebserverLogParser` fell foul of an Rubocop block size issue.  Shared example extraction was not sufficient to remove this issue, and so the advice from the following stackoverflow post was followed to turn off that rule for RSpec blocks:

https://stackoverflow.com/questions/40934345/rubocop-25-line-block-size-and-rspec-tests

The extraction of the shared examples is still in place, but is maybe too convoluted for a test base of this size?  Perhaps it should be reverted to the original approach to increase clarity and ease of use?

### WebserverLog Class?

It might make sense to add an additional class to represent the `WebserverLog` separately but probably premature refactoring given the current level of complexity and specified requirements.

### Performance?

No performance requirements were specified, but a performance assessment framework has been added and can be executed as follows:

```
$ bundle exec rake performance
              user     system      total        real
page views:  2.649054   0.102504   2.751558 (  2.759408)
unique:   2.668389   0.095945   2.764334 (  2.770790)
```

to compare the performance of calculating total and unique page views. The system might have to cope with very long webserver logs and the approach taken is not particularly performant.  The focus has been on getting something working.  Performance improvements would come from a different structure. Perhaps only Set-ting the ip array when unique page views were requested, and/or adjusting the data structures used to manage the data as it accumulates.  At least for the current code the visits map is created once and then sorting performed on that.  The results of the sorting could be memoized, but that feels like premature optimization in the absence of specific performance requirements.

### Acceptance Tests?

Currently there is a fair bit of code in `parser.rb` that is not covered by any tests.  With more time it might make sense to add an acceptance test to cover this code, and it's behaviour.

### Log Formatting Requirements?

We are currently assuming a single space separating the path and ip address and no other spaces, and skip log entries that don't meet these requirements, while logging the issue.  It's unclear if this would be the preferred approach from the current specifications.

### Use of `send` in `parser.rb`

In order to mimimize method length in `parser.rb` the `send` method is used as part of a generic `output_table` method which is perhaps not ideal.  Might be better to pass a block rather then using `send` which can access private methods ... 
