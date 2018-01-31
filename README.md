# LeafData

## Usage

```ruby
LeafData.configure do |config|
  config.username = ''
  config.password = ''
  config.license = ''
  config.base_uri = 'https://wslcb.mjtraceability.com'
end

client = LeafData::Client.new(debug: true)

```

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
