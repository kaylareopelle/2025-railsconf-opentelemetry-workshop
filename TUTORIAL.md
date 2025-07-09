# How to instrument your Rails application with OpenTelemetry

### Setup

Clone the repo:

```sh
git clone https://github.com/kaylareopelle/2025-railsconf-opentelemetry-workshop.git
```

If you need to sign up for New Relic:

- https://newrelic.com/signup
- Get your license key

To look at other vendors:
https://opentelemetry.io/vendors

Set up the application:

```sh
cd 2025-railsconf-opentelemetry-workshop
cd hike-tracker_original
bin/setup # or bundle install
bin/rails db:seed
```

Use Ruby 3.4.2 or update your `.ruby-version` file.
Anything Ruby 3.1+ should work.

### Tracers and Exporters

Add the tracer and exporter gems:

```sh
bundle add opentelemetry-sdk
bundle add opentelemetry-exporter-otlp
```

Create OpenTelemetry exporter:

```sh
touch config/initializers/opentelemetry.rb
```

Update the initializer to configure the SDK:

```ruby
OpenTelemetry::SDK.configure
```

Add the OTel configuration to send data to the backend.

You can add the following to the top of the `config/initializers/opentelemetry.rb` file:

```ruby
# Exporting to New Relic
ENV['OTEL_EXPORTER_OTLP_ENDPOINT'] = 'https://otlp.nr-data.net'
ENV['OTEL_EXPORTER_OTLP_HEADERS'] = "api-key=#{ENV['NEW_RELIC_LICENSE_KEY']}"

# Add console exporter
ENV['OTEL_TRACES_EXPORTER'] = 'console,otlp'
```

You can also pass this on the command line whenever you start your server:

```sh
OTEL_EXPORTER_OTLP_ENDPOINT=https://otlp.nr-data.net \
OTEL_EXPORTER_OTLP_HEADERS=api-key=$NEW_RELIC_LICENSE_KEY \
bin/rails s
```

### Resources

Add some resource details to your application.
Update `config/initializers/opentelemetry.rb`:

```ruby
OpenTelemetry::SDK.configure do |config|
  config.service_name = 'hike-tracker'
  config.service_version = '1.0.0'
end
```

### Instrumentation

Add the instrumentation gem:

```sh
bundle add opentelemetry-instrumentation-all
```

Update the configure block to install instrumentation:
In `config/initializers/opentelemetry.rb`:

```ruby
# config/initializers/opentelemetry.rb
OpenTelemetry::SDK.configure do |config|
  config.service_name = 'hike-tracker'
  config.service_version = '1.0.0'

  config.use_all
end
```

If you want to add configuration for Rack, update the `config.use_all`
line to read:

```ruby
  config.use_all({
    "OpenTelemetry::Instrumentation::Rack" => {
      allowed_response_headers: [ "Content-Type" ]
    }
  })
```

If you don't want to call `use_all`, replace this block with:

```ruby
OpenTelemetry::SDK.configure do |config|
  # ...
  # Alternative: Don’t combine the use_all method with use
  config.use "OpenTelemetry::Instrumentation::Rack", {
      allowed_response_headers: [ "Content-Type" ]
    }
  config.use "OpenTelemetry::Instrumentation::Rails"
end
```

Start your server in one terminal:

```sh
bin/rails s
```

Run the traffic script in another terminal:

```sh
script/traffic.sh
```

### Custom spans and attributes

**Custom span**

Outside your `OpenTelemetry::SDK.configure` block, add to
`config/initializers/opentelemetry.rb`:

```ruby
APP_TRACER = OpenTelemetry.tracer_provider.tracer("hike-tracker")
```

Update the `#duration` method in the Activity model,
which can be found in `app/models/activity.rb`:

```ruby
  def duration
    APP_TRACER.in_span("Activity duration") do
      if end_time
        ActiveSupport::Duration.build(end_time - start_time)
      else
        ActiveSupport::Duration.build(Time.now - start_time)
      end
    end
  end
```

Restart your server, generate traffic.

Start your server in one terminal:

```sh
bin/rails s
```

Run the traffic script in another terminal:

```sh
script/traffic.sh
```

**Custom attributes**

Update the ActivitiesController:

```ruby
  before_action :add_location_attribute_to_span, only: %i[ show ]
```

Define the method:

```ruby
def add_location_attribute_to_span
  OpenTelemetry::Trace.current_span.add_attributes(
    { "activity.trail.location" => @activity.trail.location }
  )
end
```

Restart your server in one terminal:

```sh
bin/rails s
```

Run the traffic script in another terminal:

```sh
script/traffic.sh
```

### Metrics

Add the metrics gems:

```sh
bundle add opentelemetry-metrics-sdk
bundle add opentelemetry-exporter-otlp-metrics
```

Add the export interval environment variable to your
initializer:

```ruby
ENV["OTEL_METRIC_EXPORT_INTERVAL"] = "3000"
```

Create a meter in your initializer:

```ruby
meter = OpenTelemetry.meter_provider.meter("hike-tracker")
```

Create a counter using the meter:

```ruby
HIKE_COUNTER = meter.create_counter(
  "activities.completed",
  unit: "activity",
  description: "Number of activities completed"
)
```

Add an after_save action to the Activity model:

```ruby
after_save :check_progress, :check_end_time, :count_completions
```

Define the count_completions method within the Activity model:

```ruby
def count_completions
   return if in_progress

   HIKE_COUNTER.add(1, attributes: {
    "user_id" => user.id,
    "location" => trail.location,
    "duration" => duration
    }
  )
 end
```

Restart your server in one terminal:

```sh
bin/rails s
```

Run the traffic script in another terminal:

```sh
script/traffic.sh
```

You will need to click in the UI to complete some activities
and record the metric.

### Logs

Update the Gemfile to comment out the existing installation of
`opentelemetry-instrumentation-all`:

```ruby
# gem 'opentelemetry-instrumentation-all'
```

Add the logs gems to the Gemfile:

```ruby
gem "opentelemetry-logs-sdk"
gem "opentelemetry-exporter-otlp-logs"

gem "opentelemetry-instrumentation-all",
  github: "kaylareopelle/opentelemetry-ruby-contrib",
  branch: "logger-instrumentation",
  glob: "instrumentation/all/*.gemspec"

gem "opentelemetry-instrumentation-logger",
  github: "kaylareopelle/opentelemetry-ruby-contrib",
  branch: "logger-instrumentation",
  glob: "instrumentation/logger/*.gemspec"
```

Update the configured logs exporter in the OpenTelemetry intializer:

```ruby
ENV['OTEL_LOGS_EXPORTER'] = 'otlp'
```

Or start passing this variable on the command line with the others.

Restart your server in one terminal:

```sh
bin/rails s
```

Run the traffic script in another terminal:

```sh
script/traffic.sh
```

### Histograms, Semantic Conventions, ActiveSupport::Notifications

To view the semantic conventions:

https://opentelemetry.io/docs/specs/semconv/http/http-metrics/

Create a histogram with a view. Add the following to the bottom
of your OpenTelemetry initializer:

```ruby
# Create a histogram with a view
# Define the boundaries
explicit_boundaries = [ 0.005, 0.01, 0.025, 0.05, 0.075, 0.1, 0.25, 0.5, 0.75, 1, 2.5, 5, 7.5, 10 ]

# Create the view
OpenTelemetry.meter_provider.add_view("http.server.request.duration",
  type: :histogram,
  aggregation: OpenTelemetry::SDK::Metrics::Aggregation::ExplicitBucketHistogram.new(
    boundaries: explicit_boundaries,
  )
)

# Create the instrument
duration_histogram = meter.create_histogram(
  "http.server.request.duration",
  unit: "s",
  description: "Duration of HTTP server requests."
)
```

Subscribe to the `process_action.action_controller` notification:

```ruby
ActiveSupport::Notifications.subscribe "process_action.action_controller" do |event|
  attributes = {
    "http.request.method" => event.payload[:method],
    "http.response.status.code" => event.payload[:status],
    "http.route" => event.payload[:path],
  }

  duration_histogram.record(event.duration, attributes: attributes)
end
```

Restart your server in one terminal:

```sh
bin/rails s
```

Run the traffic script in another terminal:

```sh
script/traffic.sh
```
