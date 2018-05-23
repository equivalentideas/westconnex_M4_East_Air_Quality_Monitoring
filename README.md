# WestConnex M4 East Air Quality Monitoring [![Build Status](https://travis-ci.org/equivalentideas/westconnex_M4_East_Air_Quality_Monitoring.svg?branch=master)](https://travis-ci.org/equivalentideas/westconnex_M4_East_Air_Quality_Monitoring)

This scraper collects the information about the air quality around the
WestConnex M4 East project in Sydney, Australia. A small web application allows
access to the data as a CSV file.

The information is collected by a contractor for WestConnex and is published at [http://airodis.ecotech.com.au/westconnex/](http://airodis.ecotech.com.au/westconnex).
We then collect the information published there.

Here are examples of the information published:

![Screenshot of the homepage](2018-03-13_homepage.png)

![Screenshop of the Haberfield Public School AQM page](2018-03-13_haberfield_page.png)

![Screenshop of the Concord Oval AQM page](2018-03-13_concord_oval_page.png)

![Screenshop of the Allen St AQM page](2018-03-13_allen_st_page.png)

![Screenshop of the Powells Creek AQM page](2018-03-13_powells_creek_page.png)

![Screenshop of the Ramsay St AQM page](2018-03-13_ramsay_st_page.png)

![Screenshop of the St Lukes Park AQM page](2018-03-13_st_lukes_park_page.png)

## Records

For each record we collect:

* **location_name**, the name of the air quality monitoring station, e.g.  'Haberfield Public School AQM'
* **scraped_at**, the date and time the data was collected by us
* **latest_reading_recorded_at**, the time the website says the reading was
  recorded, in the format provided
* **pm2_5_concentration**, Particulate less that 2.5 microns in equivalent aerodynamic diameter (µg/m³)
* **pm10_concentration**, Particulate less that 10 microns in equivalent aerodynamic diameter (µg/m³)
* **co_concentration**, Carbon Monoxide reading (ppm)
* **no2_concentration**, Nitrogen Dioxide reading (ppm)
* **differential_temperature_lower**, "Differential Temperature - Lower" reading (ªC)
* **differential_temperature_upper**, "Differential Temperature - Upper" reading (ªC)
* **wind_speed**, Wind Speed reading (m/s)
* **wind_direction**, Wind Direction reading (ª)
* **sigma**, Sigma (Wind Direction stability) reading (ª)

See the information provided below for more information about what's recorded.

## Information provided

[The Information page](http://airodis.ecotech.com.au/westconnex/index.html?site=6&station=0)
on the WestConnex M4 East - Air Quality Monitoring includes the following text,
retyped here because it is an image of text there, rendering it inaccessible to screen readers etc. :

```
Definitions & Abbreviations

PM10 Particulate less that 10 microns in equivalent aerodynamic diameter
PM2.5 Particulate less that 2.5 microns in equivalent aerodynamic diameter
N02 Nitrogen dioxide
CO Carbon monoxide
WD Vector Wind Direction
WS Vector Wind Speed
Sigma Wind Direction stability
AT Ambient Temperature

Units

µg/m³ Micrograms per cubic meter at standard temperature and pressure (0ºC and
101.3 kPa)
ppm Parts per million
º Degrees (True North)
m/s Metres per second
ªC Degrees Celsius

Traffic light icons on Site Map page side bar

The green, orange and red circles indicate that data was successfully loaded to
the page at the last attempt.
This is not an indication of the pollution index or instrument status

Instantaneous data on the side bar of individual station summary tabs

These are real-time values showing the latest available five-minute result for
each parameter. Graphs show data averaged over periods which coincide with the
relevant air quality goals. As a result, these values may differ.

Disclaimer

The data use in the compilation of this website has undergone only preliminary
quality assurance checks. This data may require modification during the final
stages of validation as a result of calibration changes, power failures,
instrument failures etc
```

## Setup

### Dependencies

* PostgreSQL

### Database setup

Replace `$password` with your own strong database password.

```
createdb westconnex_m4east_aqm_development
psql westconnex_m4east_aqm_development
> CREATE ROLE westconnex_m4east_aqm;
> ALTER ROLE westconnex_m4east_aqm WITH LOGIN PASSWORD '$password' NOSUPERUSER NOCREATEDB NOCREATEROLE;
> CREATE DATABASE westconnex_m4east_aqm_development OWNER westconnex_m4east_aqm;
> REVOKE ALL ON DATABASE westconnex_m4east_aqm_development FROM PUBLIC;
> GRANT ALL ON DATABASE westconnex_m4east_aqm_development TO westconnex_m4east_aqm;
> \q
bundle exec rake db:migrate
```

When running the scrapers, add the environment variable
DEVELOPMENT_DATABASE_PASSWORD with the same value as `$password` above, to use
the password when running the scraper. Create a file `.env` and add the
variable:

```
# .env

DEVELOPMENT_DATABASE_PASSWORD=$password
```

#### Migrating/changing the database

To make changes to the database we're using
[Sequel](http://sequel.jeremyevans.net/)'s
[migrations](http://sequel.jeremyevans.net/rdoc/files/doc/migration_rdoc.html).
The Sequel documentation has details on how to create new migrations and you can
see examples in our `db/migrations` directory.

You can use
[Sequel's command line tool](http://sequel.jeremyevans.net/rdoc/files/doc/migration_rdoc.html#label-Running+migrations)
to perform the migrations or our Rake task:

```
bundle exec dotenv rake db:migrate
```

### Running locally

#### Scraper

```
bundle exec dotenv ./scraper.rb
```

#### Web application

Run the following command and then visit http://localhost:4567/csv

```
bundle exec dotenv ./app.rb
```

#### Test suite

You'll need to create a database called `westconnex_m4east_aqm_test`. The
application will use the same credentials as it does for development to access
that database. Then run:

````
bundle exec dotenv rake
````

#### Get a copy of the production data

Capture and download the Postgres database from Heroku:

```
heroku pg:backups:capture --app $heroku_app_name
heroku pg:backups:download --app $heroku_app_name
```

You'll now have a file `latest.dump`.

Truncate your current local database before using pg_restore to import the new
one:

```
psql -U westconnex_m4east_aqm westconnex_m4east_aqm_development
> TRUNCATE aqm_records;
> \q
```

Restore the dump to your local database. [According to Heroku](https://devcenter.heroku.com/articles/heroku-postgres-import-export#export):

> This will usually generate some warnings, due to differences between your
> Heroku database and a local database, but they are generally safe to ignore.

```
pg_restore --verbose --clean --no-acl --no-owner -h localhost -U westconnex_m4east_aqm -d westconnex_m4east_aqm_development latest.dump
```

## Production Setup

### Running in production

The script runs in production when the `RACK_ENV` environment variable is set to
"production". This is automatically set on Heroku but you can test it locally by
running:

```
RACK_ENV=production bundle exec ./scraper.rb
```

Heroku injects it's own `ENV['DATABASE_URL']`.

### Running database migrations in production

```
heroku run 'bundle exec rake db:migrate' --app $heroku_app_name
```

### Access the production data

```
heroku pg:psql --app $heroku_app_name

> SELECT * FROM aqm_records;
```

### View the scheduler logs

You can view the logs from the [Heroku scheduler](https://devcenter.heroku.com/articles/scheduler#inspecting-output) with:

```
heroku logs --app $heroku_app_name --ps scheduler
```
