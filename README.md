# Upmin Gem

Upmin is a framework for creating powerful admin backends with minimal effort.


## Demo

To see a demo of Upmin, go to [https://www.upmin.com/demo](https://www.upmin.com/demo).

You should probably just install Upmin rather than using the demo. It only takes a few lines of code you will be able to use your own data, rather than fake data provided be me.


## Installation

Installing Upmin is incredibly easy. Simple add the gem to your `Gemfile`:

    gem 'upmin'

And then mount the engine in your `routes.rb` file:

    mount Upmin::Engine => '/admin'

Authentication is currently supported with an existing Devise install. Simply use something like this:

    authenticate :user, lambda { |u| u.admin? } do
      mount Upmin::Engine => '/admin'
    end


## Features

Upmin makes it easy to build and iterate on admin pages in a few ways. To begin with, it supports all of the standard features you are used to seeing in admin frameworks. For example, you can:

- Search & Filter
- View & Edit Models
- Require User Authentication

While these features are great, they have pretty much become the norm and aren't worth talking about much. The following features are what seperates Upmin from other admin frameworks:


### Customizable and Reusable Views

Upmin doesn't force you to learn Arbre or any other obscure DSL. Simply use the tools you are used to, whether that is haml or erb, and customize your views.

You can even embed javascript via the Rails [content_for](http://api.rubyonrails.org/classes/ActionView/Helpers/CaptureHelper.html#method-i-content_for) helper. For example, the DateTime attribute shown [here](https://db.tt/0IHCE330) and [here](https://db.tt/7auKD5nB) is rendered using a reusable partial that provides both the html and javascript using a HAML file.

Over time Upmin will be releasing a wide array of reusable views ranging from geo-cordinate maps to shipment tracking widgets.


### Model Actions

I often find myself wanting to add pretty basic funcionality to my admin pages, and getting frustrated at how much work this can take. Even something as simple as changing the box size for a shipment requires a custom form. Upmin solves this by inspecting methods and simply generating forms for any action you define as an upmin action.

For example, if you wanted to add the method `set_box_size` to your `Shipment` model the code would look something like this:


    class Shipment < ActiveRecord::Base
      ...

      upmin_action :set_box_size

      def set_box_size(length, width, height)
        # Do work here
      end

      ...
    end

And Upmin would generate fully functional forms for you that look (roughly) like this: [https://db.tt/JhzdeS8Z](https://db.tt/JhzdeS8Z)


## Support/Feedback

The goal of Upmin is to make it easier to build admin pages with minimal effort. With that in mind, we are always looking for feedback and suggestions. You can get in touch several ways.

Email - [support@upmin.com](support@upmin.com)
Chat - [http://www.hipchat.com/gvREostp6](http://www.hipchat.com/gvREostp6)

