# V1 Beta Release
Shooting for a launch by Sep 5. Who knows.

- [x] Remove external server dependencies
  - [x] Add local color selection instead of using server.
  - [x] Remove Algolia search code for now
  - [x] Add search and basic filters.

- [x] Make model save/update work again

- [ ] Update datetime partial to set AM/PM initially and clean up time. Maybe push to v2

- [ ] Actions, sweet sexy actions. Mmmmm.
  - [ ] Some way for devs to declare actions - prob `upmin_actions` in the model.
  - [ ] Views for actions
  - [ ] Logs for actions? Maybe V2?

# V2 Beta Release

- [ ] Clean up the code (a lot)!
  - [ ] Nodes should probably be replaced. They aren't really necessary in the current version and could be replaced with a nice clean implementation of `Upmin::Model` and `Upmin::ModelInstance`

  - [ ] Things like `product_id` probably shouldn't be shown on forms when the relation is shown as well.

  - [ ] Add a way to update associations with more than just an id. Maybe a modal that you can search for or create a model instance.

  - [ ] All the search things need to be more extensible.
    - [ ] Search boxes need to be more extensible.
    - [ ] Search fields need to be more extensible.
    - [ ] Search results need to be more extensible.

  - [ ] Actions results need to be extensible
    - [ ] make this use partials that can be overridden.


  - [ ] Needs more :cow: :bell:
    - [ ] Specifically, we should probably add some generators to copy over partials rather than forcing people to check them out on github. That woudl be sweet.

  - [ ] Authentication aside from user-defined auth on the routes? Eh, maybe. Who knows. Let me know if you need it.

# V3
