# Upmin Admin

Upmin Admin is a framework for creating powerful Ruby on Rails admin backends with minimal effort.
Upmin currently supports Rails 3.2, 4.0, 4.1 & 4.2.


## Demo Videos

**NOTE** - The videos are currently outdated, and are only relevant for versions below `0.1.0`. Please refer to the docs for recent releases until we get them updated.

To see videos showing how to install and giving a pretty good overview of the main features of upmin-admin go to [https://www.upmin.com/admin-rails](https://www.upmin.com/admin-rails).

## Demo Applications

There is also a demo application you can test out here: [store_demo](https://github.com/upmin/store_demo). The repository is maintained and updated by [Upmin](https://www.upmin.com), but you are welcome to contribute to it.

If you do choose to use the [store_demo](https://github.com/upmin/store_demo), please follow the directions in the [README](https://github.com/upmin/store_demo/blob/master/README.md) to ensure you have seed data to work with.

You can also generate a starter application using [Rails Composer](http://www.railscomposer.com/) that sets up Devise, role-based authorization, and upmin-admin. See [Upmin Admin Interface in Rails Composer](http://blog.railsapps.org/post/97584175990/upmin-admin-interface-in-rails-composer).


## Installation

Installing `upmin-admin` is incredibly easy. Simple add the gem to your `Gemfile`:

```ruby
gem 'upmin-admin'
```

And then mount the engine in your `routes.rb` file:

```ruby
mount Upmin::Engine => '/admin'
```

If you already have routes pointing to `/admin` you can use any path you want, for example you could use the following instead:

```ruby
mount Upmin::Engine => '/ice-ice-baby'
```

And you would access your admin page at `localhost:3000/ice-ice-baby` or `yoursite.com/ice-ice-baby`.


### Rails 4.2

Add the following to your gemfile:

```ruby
gem 'ransack', github: 'activerecord-hackery/ransack', branch: 'rails-4.2'
```

`upmin-admin` currently depends on ransack, and you need to use the 4.2 branch of ransack due to changes in ActiveRecord.


## Documentation

For further documentation, please visit our [Wiki](https://github.com/upmin/upmin-admin-ruby/wiki). The docs there are far from complete, but we are actively updating them. If you have any trouble or can't find the documentation to do something please [create an issue](https://github.com/upmin/upmin-admin-ruby/issues) and contribute to the docs where you can.


## Going Forward

Upmin Admin is new. It has been live for less than a few months, so there are going to be things missing. If you want to make it better, get involved and [create issues](https://github.com/upmin/upmin-admin-ruby/issues) when you find bugs or want new features, and contribute with pull requests.

The major features that are being worked on now are:

1. Mongoid support
2. Fixing bugs as we find them
3. Adding widgets
4. Implementing the dashboard


## Support & Feedback

We are always looking for feedback and suggestions. We prefer that you create a GitHub issue, but you can use any of the following to contact us:

Email - [support+admin@upmin.com](support+admin@upmin.com)

Twitter - [@UpminSupport](https://twitter.com/upminsupport)

GitHub - [Create an Issue](https://github.com/upmin/upmin-admin-ruby/issues)

Please note that this is an open source project, and we can't always respond immediately, but we do try to respond to all inquiries within 24 hours and are usually much faster to respond.
