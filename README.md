# Hertz::Fcm

[![Build Status](https://travis-ci.org/IgorPetkovic/hertz-fcm.svg?branch=master)](https://travis-ci.org/IgorPetkovic/hertz-fcm)
[![Coverage Status](https://coveralls.io/repos/github/IgorPetkovic/hertz-fcm/badge.svg?branch=master)](https://coveralls.io/github/IgorPetkovic/hertz-fcm?branch=master)

This is a [Hertz](https://github.com/aldesantis/hertz) courier for sending 
notifications to your users via [Firebase Cloud Messaging](https://firebase.google.com/).

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'hertz-fcm'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install hertz-fcm
    
Then, run the installer generator:

```console
$ rails g hertz:fcm:install
```

The courier will use ActiveJob to asynchronously deliver the text messages, so make sure that you're 
executing background jobs with some adapter (`inline` will work, even though it's not recommended). 
Jobs are pushed to the `default` queue.

## Usage

You need to expose a `#device_ids` method in your receiver class:

```ruby
class User
  include Hertz::Notifiable

  def device_ids
    mobile_devices.pluck(:token)
  end
end
```

The method should return an array of Firebase Cloud Messaging tokens (see the [FCM documentation](https://firebase.google.com/docs/cloud-messaging/android/client#sample-register) on how to acquire these).
If `#device_ids` returns an empty value (i.e. `false`, `nil` or an empty array) at the time 
the job is executed, the notification will not be delivered. This allows you to programmatically 
enable/disable FCM notifications for a user:

```ruby
class User
  include Hertz::Notifiable

  def device_ids
    mobile_devices.pluck(:token) if push_enabled?
  end
end
```

All you need to do in order to start delivering notifications via FCM is add `fcm` to the 
notification's `#deliver_by` statement and provide `body` and `title` methods:

```ruby
class CommentNotification < Hertz::Notification
  deliver_by :fcm

  def body
    'You received a new comment!'
  end
  
  def title
    'New comment'
  end
end
```

All `CommentNotification`s will now be delivered via FCM! :)

**NOTE:** This courier uses the [deliveries API](https://github.com/aldesantis/hertz#tracking-delivery-status)
to prevent double deliveries.

## Development

After checking out the repo, run `bundle install` to install dependencies.
Then, to run the tests:
```
cp spec/dummy/config/database.example.yml spec/dummy/config/database.yml
cd spec/dummy && RAILS_ENV=test bundle exec rake db:create db:schema:load && cd ../..
bundle exec rspec
```

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/hertz-fcm. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Hertz::Fcm project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/hertz-fcm/blob/master/CODE_OF_CONDUCT.md).
