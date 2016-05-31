# SimpleProfiler

[![Gem Version](https://badge.fury.io/rb/simple_profiler.png)](https://rubygems.org/gems/simple_profiler)
[![Build Status](https://travis-ci.org/gabynaiman/simple_profiler.png?branch=master)](https://travis-ci.org/gabynaiman/simple_profiler)
[![Coverage Status](https://coveralls.io/repos/gabynaiman/simple_profiler/badge.png?branch=master)](https://coveralls.io/r/gabynaiman/simple_profiler?branch=master)
[![Code Climate](https://codeclimate.com/github/gabynaiman/simple_profiler.png)](https://codeclimate.com/github/gabynaiman/simple_profiler)
[![Dependency Status](https://gemnasium.com/gabynaiman/simple_profiler.png)](https://gemnasium.com/gabynaiman/simple_profiler)

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'simple_profiler'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install simple_profiler

## Usage

```ruby
class MyClass
  def execute
    ...
  end

  def self.execute!
    ...
  end
end
```

**Configuration**
```ruby
SimpleProfiler.profile_class_methods MyClass, :execute!
SimpleProfiler.profile_instance_methods MyClass, :execute

summary_reporter = SimpleProfiler::Reporters::Summary.new
logger_reporter = SimpleProfiler::Reporters::Logger.new Logger.new('profile.log')

SimpleProfiler.configure do |config|
  config.reporters = [summary_reporter, logger_reporter]
end
```

**Summary**
```ruby
ranking = summary_reporter.summary.ranking
    
ranking[0][:klass] # => 'MyClass'
ranking[0][:method] # => :execute
ranking[0][:hits] # => hits count
```

**Logger**
```
# Logfile created on 2016-05-31 15:12:30 -0300 by profile.rb/41954
D, [2016-05-31T15:12:30.302556 #7582] DEBUG -- : MyClass.execute! -> 0.0 sec. - 0.0MB - (Total Memory: 36.80078125MB)
D, [2016-05-31T15:12:30.302642 #7582] DEBUG -- : MyClass.execute! -> 0.0 sec. - 0.0MB - (Total Memory: 36.80078125MB)
D, [2016-05-31T15:12:30.302694 #7582] DEBUG -- : MyClass.execute! -> 0.0 sec. - 0.0MB - (Total Memory: 36.80078125MB)
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/gabynaiman/simple_profiler.

