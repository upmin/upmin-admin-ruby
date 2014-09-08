# 0.0.34 Alpha Release
Shooting for a launch by Sep 5. Who knows.

- [x] Remove external server dependencies
  - [x] Add local color selection instead of using server.
  - [x] Remove Algolia search code for now
  - [x] Add search and basic filters.

- [x] Make model save/update work again

- [ ] Update datetime partial to set AM/PM initially and clean up time. Maybe push to v2

- [x] Actions, sweet sexy actions. Mmmmm.
  - [x] Some way for devs to declare actions - prob `upmin_actions` in the model.
  - [x] Views for actions
  - [x] Handle empty fields - assume no arg for now. Need to add a way to send empty string later.


# 0.0.35 Alpha (maybe beta?) Release

- [ ] Clean up the code (a lot)!
  - [x] Nodes should probably be replaced. They aren't really necessary in the current version and could be replaced with a nice clean implementation of `Upmin::Model` and `Upmin::ModelInstance`

  - [ ] Things like `product_id` probably shouldn't be shown on forms when the relation is shown as well.

  - [ ] Add a way to update associations with more than just an id. Maybe a modal that you can search for or create a model instance.
  - [ ] Add a way to add/remove relationships - eg Products may have 3 items adn you might want to add 2 and remove 1.

  - [ ] All the search things need to be more extensible.
    - [ ] Search boxes need to be more extensible.
    - [ ] Search fields need to be more extensible.
    - [ ] Search results need to be more extensible.

  - [ ] Actions results need to be extensible
    - [ ] make this use partials that can be overridden.


  - [ ] Needs more :cow: :bell:
    - [ ] Specifically, we should probably add some generators to copy over partials rather than forcing people to check them out on github. That woudl be sweet.

  - [ ] Authentication aside from user-defined auth on the routes? Eh, maybe. Who knows. Let me know if you need it.


  - [ ] Actions/Methods
    - [ ] Logs for actions - will need a db migration.
    - [ ] Some way to handle things like hashes ets as args
    - [ ] Add some support for default values for actions. Maybe merb, but that may cause issues with varying installs. Might be easier to use something like a method named `<method_name>_default_args` and have it return a hash. This might also help solve the way to do hashes and other types of args for methods that arent' strings.
    - [ ] Naming consistencty between method/action. Method may be easier since it isnt a reserved param for paths.
    - [ ] empty string for req arg needs to be supported


# 0.1.0 Beta

# 1.0.0 non-beta winning omg

A long way to go for this :\
