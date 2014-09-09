# Customizing Model Views in Upmin Rails

One of the most common things you will want to do in Upmin is customize how models are displayed. Below we cover how to do this and provide a few basic examples to help get you started.

### Demo Application & Seed Data

This demo uses the [store_demo](https://github.com/upmin/store_demo) repository provided by upmin, but you are welcome to follow along with your own rails application.

If you do choose to use the [store_demo](https://github.com/upmin/store_demo), please follow the directions in the [README](https://github.com/upmin/store_demo/blob/master/README.md) to ensure you have seed data to work with.



## Adding Custom Attributes

The first thing we are going to cover is how to add custom data to Upmin. By default, Upmin uses all attributes associated ot a model. To get a list of these for any model, simply call `ModelName#attribute_names`. For example, a User model's attributes can be viewed with `User.attribute_names`.

### Adding Individual Attributes

To add an individual attribute, you simply need to define a method or accessor as an `upmin_attribute`. For example, if we wanted to add the `total_cost` attribute to our `Order` model we would add the following line of code:

```ruby
class Order < ActiveRecord::Base
  has_many :product_orders
  has_many :products, through: :product_orders
  has_one :shipment
  belongs_to :user

  upmin_attribute :total_cost

  ...

end
```

Notice that the `total_cost` method already existed. Upmin was designed to let developers use existing code rather than writing entirely new classes for admin pages.


### Adding Multiple Attributes & Removing Default Attributes

If you are going to be adding a lot of attributes, or you want to make sure some default attributes aren't included, this can be achieved with `upmin_attributes` in your model. This will replace the default set of attributes used in upmin with whatever attributes you provide. For example, if you want to limit the attributes shown in the `Product` model you would update the model code to look like:

```ruby
class Product < ActiveRecord::Base
  has_many :product_orders
  has_many :orders, through: :product_orders
  has_many :reviews

  upmin_attributes :name, :short_desc, :price, :manufacturer, :free_shipping

end
```

In this case the only attributes that will be rendered are those included in the `upmin_attributes` list.


## Customizing Views

Now that you have the data you want showing up on each admin page, you may want to start customizing how this data looks. To customize attributes you can use regular partials that you and your team are used to working with. You don't need to learn anything new like Arbre - you can simply work the way you have been working all along.

Partials should all be located under your application's views folder, with the folder structure of `app/views/upmin/partials/`. Partials are further divided into the folders: `models`, `attributes`, `associations`, `actions`, `search_results`, and `search_boxes`. These folders will be covered in more detail below, and in the [customizing search pages](TODO: Fill this in) docs.


### Customizing Model Views

Models are rendered from the `app/views/upmin/partials/models` directory, and by default they are rendered with the upmin helper method `up_model`. This method is available in any of your views, but should typically be reserved for views that only admins have access to.


#### The `up_model` helper method

The `up_model` method allows for 2 arguments:

- The model you want to render.
- A hash of options. This argument is not required.

For example, you could use the following in an erb file:

```ruby
<%= up_model(User.first, as: :mega_user) %>
```

When `up_model` attempts to render a model, it creates a priority list of partials to try. If a partial does not exist, it simply moves on to the next partial in the list until it has exhausted all options. The priority list is:

1. **options[:as]** - this is the as: option provided in the optional hash for `up_model`, and always takes first priority. For example, `up_model(User.first, as: :mega_user)` would attempt to use the partial `app/views/upmin/partials/models/_mega_user`.

2. **model.name.underscore** - this is determined by the model provided as the first argument in `up_model`. For example, `up_model(User.first)` would attempt to use the partial `app/views/upmin/partials/models/_user`.

3. **The default `model` partial** - Upmin provides a default partial that can render any model in a generic way. The default partial can be [seen here](app/views/upmin/partials/models/_model.html.haml) and you can override this by creating your own partial under the directory `app/views/upmin/partials/models/_model` in your own applicatoin.


#### Creating a Custom Model Partial

Modifying your own custom partial is simple to do, despite sounding tricky at first. Simply create the partial you want to customize, and the model object will be passed in with the same name as your partial. For example, the partial `_user.html.haml` would have a `user` object that references the user being rendered. Below is a full list of locals passed into the partial:

- **object** - This is an object with the same name as your partial, and references the model you are trying to render. eg the partial `_user.html.haml` would have a `user` object.

- **upmin_model** - This is an instance of the [Upmin::Model](lib/upmin/model.rb) class, that contains the model you are trying to render as well as a few helper methods.


For example, in the [store_demo](https://github.com/upmin/store_demo) application you could change the default user view:

![default user view](docs/assets/default_user_view.png)

And create a custom partial `app/views/upmin/partials/models/_user.html.erb` with the following content:

```erb
<div class="container">
  <div class="row">
    <div class="col-md-2">
      <img src="<%= user.avatar_url %>" class="user-avatar">
    </div>
    <div class="col-md-10">
      <span class="label label-info user-id pull-right">ID: <%= user.id %></span>

      <h1>
        <%= user.name %>
        <br/>
        <small>
          <%= user.email %>
        </small>
      </h1>

    </div>
  </div>
  <br>
  <div class="row">
    <div class="col-md-7">
      <h3>
        Attributes
      </h3>
      <div class="well">
        <%= form_for(upmin_model.instance, url: upmin_model_path(upmin_model.path_hash), html: { method: :put }) do |f| %>
          <% # Render each attribute %>
          <% upmin_model.klass.attributes.each do |attribute| %>
            <div class="form-group">
              <% # = f.label(attribute.to_s) # Not using this because it drops _id and this isn't always desirable %>
              <label for="<%= upmin_model.attribute_form_id(attribute) %>">
                <%= upmin_model.attribute_label_name(attribute) %>
              </label>
              <%= up_attribute(upmin_model.instance, attribute, locals: { form_builder: f }) %>
            </div>
          <% end %>
          <%= f.submit("Save", class: "btn btn-primary") %>
        <% end %>
      </div>
      <% if upmin_model.klass.associations.any? %>
        <% upmin_model.klass.associations.each do |association| %>
          <h4>
            <%= association.to_s.humanize %>
          </h4>
          <%= up_association(upmin_model.instance, association, limit: 5) %>
          <br>
        <% end %>
      <% end %>
    </div>
    <div class="col-md-5">
      <% if upmin_model.klass.actions.any? %>
        <h3>
          Actions
        </h3>
        <hr/>
        <% upmin_model.klass.actions.each do |action| %>
          <h4>
            <%= action.to_s.capitalize.humanize %>
          </h4>
          <%= up_action(upmin_model.instance, action) %>
        <% end %>
      <% end %>
    </div>
  </div>
</div>



<!-- This can also be placed into your own css files, just prefix everything with the .m-User class which Upmin adds
     to the body tag when rendering any user model. -->
<% content_for(:head) do %>
  <style>
    .user-id {
      font-size: 1em;
      margin-right: 20px;
      margin-top: 20px;
    }

    .user-avatar {
      border-radius: 40px;
      max-width: 80px;
      max-height: 80px;
      margin-top: 20px;
    }
  </style>
<% end %>

<% content_for(:javascript) do %>
  <script>
    // Insert your javascript here
  </script>
<% end %>
```

And your users will start rendering using the new partial, giving you a user view that looks like:

![customized user view](docs/assets/updated_user_view.png)



### Customizing Attribute Views

Attributes are rendered by default with the upmin helper method `up_attribute`.

To customize attributes you can use regular partials that you and your team are used to working with. You don't need to learn anything new like Arbre - you can simply work the way you have been working all along.

Attribute partials should all be located under your application's views folder, with the folder structure of `app/views/upmin/partials/attributes`. The attribute partial used for each attribute is determined with the following priority:

1. **options[:as]** - this can be passed into an `up_attribute` render method
