# Upmin Admin

Upmin Admin is a framework for creating powerful admin backends with minimal effort.

## Demo Videos

To see videos showing how to install and giving a pretty good overview of the main features of upmin-admin go to [https://www.upmin.com/admin-rails](https://www.upmin.com/admin-rails).

### Demo Application

There is also a demo application you can test out here: [store_demo](https://github.com/upmin/store_demo). The repository is maintained and updated by [Upmin](https://www.upmin.com), but you are welcome to contribute to it.

If you do choose to use the [store_demo](https://github.com/upmin/store_demo), please follow the directions in the [README](https://github.com/upmin/store_demo/blob/master/README.md) to ensure you have seed data to work with.

You can generate a starter application using [Rails Composer](http://www.railscomposer.com/) that sets up Devise, role-based authorization, and upmin-admin. See [Upmin Admin Interface in Rails Composer](http://blog.railsapps.org/post/97584175990/upmin-admin-interface-in-rails-composer).


## Installation

Installing `upmin-admin` is incredibly easy. Simple add the gem to your `Gemfile`:

```ruby
gem 'upmin-admin'
```

And then mount the engine in your `routes.rb` file:

```ruby
mount Upmin::Engine => '/admin'
```

Authentication is currently supported with an existing Devise install. Simply use something like this:

```ruby
authenticate :user, lambda { |u| u.admin? } do
  mount Upmin::Engine => '/admin'
end
```

### Rails 4.2

Add the following to your gemfile:

```ruby
gem 'ransack', github: 'activerecord-hackery/ransack', branch: 'rails-4.2'
```

`upmin-admin` currently depends on ransack, and you need to use the 4.2 branch of ransack due to changes in ActiveRecord.

## Documentation

We are currently working on the docs on our [Wiki](https://github.com/upmin/upmin-admin-ruby/wiki), but they are far from complete so if you have any trouble or can't find the documentation to do something please let us know via email - [support@upmin.com](support@upmin.com) or chat with us on [HipChat](http://www.hipchat.com/gvREostp6).


## Going Forward

There are a lot of things that need built going forward and we are looking for anyone who wants to get involved. Just hop in our hipchat (link below) or email us (link also below).

The major features that are being worked on now are:

1. DataMapper support
2. Fixing bugs - specifically ones like ActsAsTaggable causing the menu to have far too many models.
3. Implementing the Dashboard
4. Adding useful widgets, such as an EasyPost Tracking label widget, a Stripe Card widget, and other commonly used APIs, as well as Map widgets for plotting routes or just showing a location.


## Support & Feedback

The goal of Upmin is to make it easier to build admin pages with minimal effort. With that in mind, we are always looking for feedback and suggestions. You can get in touch several ways.

Email - [support@upmin.com](support@upmin.com)

Chat - [http://www.hipchat.com/gvREostp6](http://www.hipchat.com/gvREostp6)
