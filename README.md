##[![Gem Version](https://badge.fury.io/rb/allegro-api.svg)](https://badge.fury.io/rb/allegro-api) [![Build Status](https://travis-ci.org/kmi3c/allegro-api.svg?branch=master)](https://travis-ci.org/kmi3c/allegro-api)
# Allegro API

Simple Ruby REST API client for Allegro API.

https://developer.allegro.pl/about/#rest-api

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'allegro-api'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install allegro-api

## Usage

```ruby
# Create client instance and authorize
a = Allegro::Client.new('client','secret')

# Does client authorized sucessfully?
a.authorized? # => false
```

## TODO

  * [ ] Write specs!
  * [ ] Enable specs on travis!
  * [ ] Add possibilty to setup/change api version
  * [ ] Handle more `Http::Agent` methods and/or move agent to sepearate `gem`
  * [ ] Prepare some method for searching offers
  * [ ] Prepare some methods for other API methods
  * [ ] Add more TODO-s


## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/kmi3c/allegro-api.
