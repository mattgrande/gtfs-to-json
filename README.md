
## Usage

- clone this repository

- run `bundle install` (add other gems you may need to the Gemfile beforehand)

- run `rake import_gtfs` to import the route information; run `rake download_buses` to get the current bus locations

- run `rake spec` to run the tests

- modify your app routes in `config.ru`

- `rackup config.ru` to start it
