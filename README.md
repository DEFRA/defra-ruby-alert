# Defra Ruby Alert

[![Build Status](https://travis-ci.com/DEFRA/defra-ruby-alert.svg?branch=master)](https://travis-ci.com/DEFRA/defra-ruby-alert)
[![Maintainability Rating](https://sonarcloud.io/api/project_badges/measure?project=DEFRA_defra-ruby-alert&metric=sqale_rating)](https://sonarcloud.io/dashboard?id=DEFRA_defra-ruby-alert)
[![Coverage](https://sonarcloud.io/api/project_badges/measure?project=DEFRA_defra-ruby-alert&metric=coverage)](https://sonarcloud.io/dashboard?id=DEFRA_defra-ruby-alert)
[![security](https://hakiri.io/github/DEFRA/defra-ruby-alert/master.svg)](https://hakiri.io/github/DEFRA/defra-ruby-alert/master)
[![Gem Version](https://badge.fury.io/rb/defra_ruby_alert.svg)](https://badge.fury.io/rb/defra_ruby_alert)
[![Licence](https://img.shields.io/badge/Licence-OGLv3-blue.svg)](http://www.nationalarchives.gov.uk/doc/open-government-licence/version/3)

Currently there are a number of Rails based digital services in Defra, all of which use [Airbrake](https://github.com/airbrake/airbrake) to report exceptions to instances of [Errbit](https://github.com/errbit/errbit) we have running.

This means we are often duplicating the code to configure and manage Airbrake across them. So we created this gem 😁!

It's aim is to help us

- start to reduce the duplication across projects
- be consistent in how we configure and manage Airbrake

## Installation

This gem is intended to replace directly referencing and managing the [Airbrake gem](https://github.com/airbrake/airbrake-ruby) in our services. However our services require different versions of Airbrake due to the versions of Ruby they depend on. So if like the [Flood Risk Activity Exemptions service](https://github.com/DEFRA/ruby-services-team/tree/master/services/frae) you are using Ruby 2.3 and need Airbrake version 5.3 add this line to your application's Gemfile

```ruby
gem "defra_ruby_alert", "~> 0.1.0"
```

If like the [Waste Exemptions](https://github.com/DEFRA/ruby-services-team/tree/master/services/wex) and [Waste Carriers](https://github.com/DEFRA/ruby-services-team/tree/master/services/wcr) services you are using Ruby 2.4 and need Airbrake version 5.8 add this line to your application's Gemfile

```ruby
gem "defra_ruby_alert", "~> 1.0.0"
```

And then update your dependencies by calling

```bash
bundle install
```

## Configuration

There is a bunch of stuff that can be [configured](https://github.com/airbrake/airbrake-ruby#configuration) for Airbrake. But as part of trying to keep things consistent we only expose the stuff we expect to change across services.

### Mandatory config

As a minimum you need to let the gem know the host uri for the Errbit instance, and the project key to log exceptions against. You also need to enable it.

This is because Airbrake errors if `project_key` is not set. The problem is that the initializer is fired in scenarios where we are not actually using the app, for example when running a rake task. A common case is during deployment when generating assets. As such the gem disables Airbrake unless you tell it to enable it.

```ruby
# config/initializers/defra_ruby_alert.rb
require "defra_ruby/alert"

DefraRuby::Alert.configure do |config|
  config.enabled = true
  config.host = "http://errbit.mydomain.com"
  config.project_key = "SomeScaryLookingLongStringMadeUpOfLettersAndNumbers"
end
```

### Rails config

The gem has been designed to be used by our Rails apps, so we would also expect the following to be set (though its not required)

```ruby
  config.root_directory = Rails.root
  config.logger = Rails.logger
  config.environment = Rails.env
```

### blacklist

> Specifies which keys in the payload (parameters, session data, environment data, etc) should be filtered. Before sending an error, filtered keys will be substituted with the [Filtered] label.

Not every project uses this, but some do hence we provide the ability to specify a blacklist.

```ruby
  config.blacklist = [/password/i, /postcode/i, :name]
```

See Airbrake's [blacklist_keys](https://github.com/airbrake/airbrake-ruby#blacklist_keys) for more details.

## Usage

Having configured the gem, you simply need to tell it to `start` Airbrake.

```ruby
# config/initializers/defra_ruby_alert.rb
require "defra_ruby/alert"

DefraRuby::Alert.configure do |config|
  # ...
end

DefraRuby::Alert.start
```

## Alert?

It probably would have made more sense to name this gem `defra_ruby_airbrake` as that's all it's really dealing with. However we encountered numerous namespace issues in our first attempts. So rather than run the risk of always encountering those kind of issues, we just picked a different name.

[Naming things is hard!](https://martinfowler.com/bliki/TwoHardThings.html)

## Contributing to this project

If you have an idea you'd like to contribute please log an issue.

All contributions should be submitted via a pull request.

## License

THIS INFORMATION IS LICENSED UNDER THE CONDITIONS OF THE OPEN GOVERNMENT LICENCE found at:

<http://www.nationalarchives.gov.uk/doc/open-government-licence/version/3>

The following attribution statement MUST be cited in your products and applications when using this information.

> Contains public sector information licensed under the Open Government license v3

### About the license

The Open Government Licence (OGL) was developed by the Controller of Her Majesty's Stationery Office (HMSO) to enable information providers in the public sector to license the use and re-use of their information under a common open licence.

It is designed to encourage use and re-use of information freely and flexibly, with only a few conditions.
