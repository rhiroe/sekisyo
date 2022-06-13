# Sekisyo

[![Test](https://github.com/rhiroe/sekisyo/actions/workflows/main.yml/badge.svg)](https://github.com/rhiroe/sekisyo/actions/workflows/main.yml/badge.svg)

Sekisyo is rack middleware for input validation.

By writing a parameter whitelist in YAML files, requests that do not comply with it are rejected and returns status 400(Bad request).

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'sekisyo'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install sekisyo

## Usage

Use rack middleware in your application.

```ruby
middleware.use Sekisyo::Middleware
```

And write whitelist in YAML files.

```yaml
paths:
  '/pets':
    get:
      required []
      properties: {}
```

## Configuration

- `file_paths` e.g. `['custom/whitelist.yml']`

The path to the yaml file is `sekisyo.yml` by default, but you can specify a custom path.

```ruby
Sekisyo::Middleware.configure do |config|
  config.file_paths = ['custom/whitelist.yml']
end
```

- `undefined_request`

Can specify the behavior when a request is sent to a path that is not defined in the whitelist.

```ruby
Sekisyo::Middleware.configure do |config|
  config.undefined_request = :failure
end
```

- `logger`

Can specify the log class.

```ruby
Sekisyo::Middleware.configure do |config|
  config.logger = Logger.new($stdout)
end
```

- `allow_keys`

Can specifies the top-level key of the parameter to be exempt from validation.

```ruby
Sekisyo::Middleware.configure do |config|
  config.allow_keys = ['authenticity_token']
end
```

## Whitelist

Path can be specified as a dynamic URL. The path parameter can be enclosed in `{}`.

```yaml
paths:
  '/pets/{id}':
    get:
      required: []
      properties:
        id:
          type: 'integer' 
```

Keys that must be included in the parameters can be specified in `required`.

```yaml
paths:
  '/pets':
    post:
      required:
        - 'name'
      properties:
        name:
          type: 'string'
```

Parameters to be accepted are specified in `properties`.

```yaml
paths:
  '/pets/{id}':
    put:
      required:
        - 'id'
      properties:
        id:
          type: 'integer'
        name:
          type: 'string'
        category:
          type: 'object'
          id:
            type: 'integer'
```

Can specify validation options that match the type.

```yaml
paths:
  '/pets':
    get:
      required []
      properties:
        status:
          type: 'string'
          enum:
            - 'available'
            - 'pending'
            - 'sold'
```

The type that can be specified are:

- `'string'`
- `'integer'`
- `'float'`
- `'numeric'`
- `'boolean'`
- `'array'`
- `'file'`
- `'object'`
- `'any'`

The options that can be specified are:

- string
  - `presence` e.g. `true`
  - `max_bytesize` e.g. `128`
  - `enum` e.g. `['A', 'B']`
  - `mutch` e.g. `'^\d{3}-\d{4}-\d{4}$'`
- integer
  - `presence` e.g. `true`
  - `max_bytesize` e.g. `128`
  - `enum` e.g. `['1', '2']`
- float
  - `presence` e.g. `true`
  - `max_bytesize` e.g. `128`
  - `enum` e.g. `['0.1', '0.2']`
- numeric
  - `presence` e.g. `true`
  - `max_bytesize` e.g. `128`
  - `enum` e.g. `['0.1', '1']`
- boolean
  - `presence` e.g. `true`
- array
  - `presence` e.g. `true`
  - `max_bytesize` e.g. `128`
  - `min_size` e.g. `1`
  - `max_size` e.g. `10`
  - `items` e.g. `{ type: 'string', presence: true }`
- file
  - `allow_file_types` e.g. `['image/jpeg', 'image/png', 'image/gif']`
  - `presence` e.g. `true`
  - `max_bytesize` e.g. `10000`
- any
  - `presence` e.g. `true`
  - `max_bytesize` e.g. `128`

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/rhiroe/sekisyo. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/[USERNAME]/sekisyo/blob/master/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Sekisyo project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/sekisyo/blob/master/CODE_OF_CONDUCT.md).
