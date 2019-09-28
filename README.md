# README

# REQUIREMENTS

- Ruby 2.6.4
- Rails 6.0.0
- PostgreSQL 9.6
- Yarn (run ```brew install yarn``` to get this if you dont have it)

# SETUP

Clone the repo and in the console:

1. run ```bundle install``` to install the gems
2. run ```yarn add bootstrap popper.js jquery``` 
3. run ```rails webpack:install``` and say no when you are asked if you would like to overwrite environment.js
4. run ```rails db:create```, ```rails db:migrate```, ```rails db:seed``` to setup the database and add the source data
5. run ```rspec``` to run the unit tests
6. run ```rails s``` to start up the dev server

# SOURCE DATA

CSV files in lib/seeds.