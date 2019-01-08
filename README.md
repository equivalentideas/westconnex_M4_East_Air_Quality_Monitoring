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
* **latest_reading_recorded_at**, the time the website says the reading was recorded at, [parsed into a standard format with a timezone](https://github.com/equivalentideas/westconnex_M4_East_Air_Quality_Monitoring/blob/master/lib/aqm_reading.rb#L40-L43), e.g. "2018-03-16 09:00:00 +1100"
* **latest_reading_recorded_at_raw**, the time the website says the reading was recorded, in the format they present it in, e.g. "March 16, 2018 8:00:00 AM GMT". [There have been issues in their presentation](https://github.com/equivalentideas/westconnex_M4_East_Air_Quality_Monitoring/issues/32#issuecomment-381038119), so we are keeping this raw format incase any values need to be corrected.
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

### Docker

`docker-compose` can save you from installing and configuring Postgres and Ruby.
On the other hand you'll need Docker and docker-composed installed so
`¯\_(ツ)_/¯`.

Here's how:

```
# FIXME: These setup steps shouldn't be needed, we should handle them in the app
# Boot the database container so it sets up Postgres
docker-compose up -d db

# Migrate the database
docker-compose run web bundle exec rake db:migrate

# Boot web container
docker-compose up -d web

# Scrape some records
docker-compose exec web bundle exec scraper.rb
```

When you're finished you can `docker-compose down`. Your data will be persisted
and you'll be able to boot the environment with just a `docker-compose up`.

To restore a Heroku backup:

`docker-compose run db pg_restore --verbose --clean --no-acl --no-owner -h db -U postgres -d westconnex_m4east_aqm_development app/latest.dump`

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

Copy the example database configuration file and replace the example
configuration values with your own:

```
cp db/config.yml.example db/config.yml
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
bundle exec rake db:migrate
```

### Running locally

#### Scraper

```
bundle exec ./scraper.rb
```

#### Web application

Run the following command and then visit http://localhost:4567/csv

```
bundle exec ./app.rb
```

#### Test suite

Make sure you've created a test database and entered the correct configuration
values for it in `db/config.yml`. Then run:

````
bundle exec rake
````

#### Get a copy of the production data

Capture and download the Postgres database from Heroku:

```
heroku pg:backups:capture
heroku pg:backups:download
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
heroku run rake db:migrate
```

### Access the production data

```
heroku pg:psql

> SELECT * FROM aqm_records;
```

### View the scheduler logs

You can view the logs from the [Heroku scheduler](https://devcenter.heroku.com/articles/scheduler#inspecting-output) with:

```
heroku logs --ps scheduler
```
