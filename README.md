# RailsConf 2025: OpenTelemetry Workshop

**This repository is still a work in progress.**

This repository accompanies a workshop that will be held at RailsConf 2025 in
Philadelphia on July 9, 2025.

## Overview

This repository has two applications in it:

* `hike-tracker_original`: This is an uninstrumented copy of the application
we'll be working with. It uses Rails 8.0 and Ruby 3.4.2.

* `hike-tracker-instrumented`: This is how the application will look at the end
of the workshop, after being instrumented with OpenTelemetry.

For the workshop, please `cd` into `hike-tracker_original` and work from that application.

If you want to check your work, or copy/paste the code, consult
`hike-tracker-instrumented`.

**Hot tip:** Bundling before the workshop will help reduce the burden on the
Wifi in the conference room during the event!

## Prerequsities

* MacOS or a Linux-based operating
* Ruby 3.4.2
* [SQLite][sqlite] - `brew install sqlite`
* [An observability backend](#observability-backend-recommendations-observability-backend-recommendations)

## Initial setup

```sh
cd hike-tracker_original
bin/setup
```

## Development

To run the application:

```sh
cd hike-tracker_original
bin/rails db:seed
bin/rails server
```

In a separate terminal window, you can generate traffic for your application
using:

```sh
cd hike-tracker_original
script/traffic.sh
```

This traffic script will make requests to the index and show pages for
the Users, Trails, and Activities controllers. It may make requests to show
pages with IDs that don't exist. This will help us see how OpenTelemetry
handles errors.

To stop the script, enter: `CTRL + C`

You can also generate traffic by clicking around in the UI.

## The Data model

During the workshop, we'll be using a simple Rails application designed to track
hikes. There are three main resources: Users, Trails, and Activities.

An Activity belongs to a User and a Trail. Trails can also have many comments.

We'll put the majority of our custom instrumentation in the Activity-related
code.

## Observability backend recommendations

One of the beautiful things about OpenTelemetry is its vendor-agnostic nature.
It doesn't deal with how to visualize your data, only how to collect and shape
your data.

Evaluating your options for ingesting and storing your OpenTelemetry data is
outside the scope of this workshop. [OpenTelemetry's vendors][otel-vendors] page
has an extensive list of available options.

The examples in this workshop use [New Relic](newrelic.com) as the backend
vendor. New Relic has has a free forever tier that you can
[sign up for here][nr-signup].

If you choose to use New Relic, you need a [License Key][license-key] for your
account.

You can also follow the instructions for this workshop using a different vendor,
or choose to export everything to the console and examine your data there.


[sqlite]: https://www.sqlite.org/index.html
[otel-vendors]: https://opentelemetry.io/ecosystem/vendors/
[nr-signup]: https://newrelic.com/signup
[license-key]: https://docs.newrelic.com/docs/apis/intro-apis/new-relic-api-keys/#:~:text=Read%20more-,License%20key%2C,-used%20for%20data
