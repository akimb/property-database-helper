# README

talk about:
- wanted to create a rudimentary properties model as well as a unit model
- learned about has_many and belongs_to
- created a migration file that would take care of csv imports
- kept temporary files in consideration - wanted a way to make edits before sending off for final export, handled via enum
- created csv parser service that would handle reading csv raw text data and convert to a property object
- had a lot of inefficiencies that led to many obstacles that i was able to foresee
- i.e. committing csv as raw text and did not store data in mysql as desired, causing clunky behavior
- refactored controllers to fit this need better; created importedproperties controller that would also be the intermediate between final property export
- made some other improvements, like using partials to call each property rather than have the whole thing display in the show page
- tackled units next - originally handled as hash, then json, but the issue was that any updates, deletions or changes to unit(s) would require having to reparse the entire array.
- also couldn't use ID to query directly. also uniqueness couldn't be enforced
- created dropdown on state to ensure that people can never query wrong for state
- if had more time, would want to implement spellchecker for property name and street. also, would have liked to use lookup tables to get state first, then a dropdown for city to eliminate even more mistake chances
- would be nice to sort newly added units
- deleting units were hard. doing units in every sense was hard. didn't know how DELETE was handled with HTML, so had to download turbo-rails, then realized that it's not well supported in rails 8, then figured out that link_to only handles GET, POST, and PATCH, etc
- have to figure out how to only temporarily delete units if not saved -- potentially hide the unit from view in edit and if it's hidden + save page, then unit gets deleted?
- got resolved by utilizing checkboxes and deleting upon save, much better solution. cleaner too
- 
