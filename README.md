# Rails-like

Basic rails-like functionality.

## Use
Use the `run` script to `bundle install` necessary packages and to start WEBrick.

Notably, this depends on `active_support` under version 4.2; 4.2 eliminated a circular dependency which means that `active_support/core_ext` no longer works on its own.

Then, open a browser and navigate to `localhost:3000/cats` to see how routing works. Neat!

## Todo
There's certainly more that could be done to this project, but `rails` is already filling that gap. This was mostly an exploration to see how to mimic `rails`' routing, rendering and parameter processing. For instance, one improvement would involve building the routing regular expressions automatically using inferred routing rather than hard-coding the routes into the server file.

However, the learning and demonstration goals of this project have, I believe, been met. It runs, functions, and manages to send users the data they request using templates.
