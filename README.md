# AirtablePlus

You can use your Airtable more easily from your script!

<img src="https://github.com/yuuki1224/airtable_plus/raw/master/images/overview.png" width="300" alert="overview">

### Features

- Mapping to custom object
- Converting to `Airtable::Record`
- Module `AirTablePlus::Airtableable`

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'airtable_plus'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install airtable_plus

## Usage

```ruby
class Model::Repository
  attr_accessor :name, :url, :created_at
end

ATTR_TABLE = {
  'Repo Name':  'name',
  'URL':        'url',
  'Created At': {name: 'created_at', proc: Proc.new {|v| DateTime.strptime(v, "%m/%d/%Y %H:%M:%S")}},
}

IGNORE_ATTRS = ['avatar_url']

@airtable_plus = AirtablePlus.new(ENV['API_KEY'], APP_ID, WORKSHEET_NAME)

@airtable_plus.klass        = Model::Repository
@airtable_plus.attr_table   = ATTR_TABLE
@airtable_plus.ignore_attrs = IGNORE_ATTRS

@airtable_plus.all # => [Model::Repository]

repo = @airtable_plus.first
repo.to_record # => Airtable::Record

@airtable_plus.has?(repo) # => true or false
@airtable_plus.add(repo)
@airtable_plus.delete(repo)
@airtable_plus.update(repo)
```

```ruby
class Model::Repository
  include AirtablePlus::Airtableable  
  attr_accessor :name, :url, :created_at
end

repo            = Repository.new
repo.name       = 'yuuki1224/airtable_plus'
repo.url        = 'https://github.com/yuuki1224/airtable_plus'
repo.created_at = DateTime.now

# This instance would be saved into Airtable.
repo.save!
```

## Why not google spreadsheet?

We used to use google spreadsheet to manage our data. Then, the script, which was running on Heroku free dyno has updated that spreadsheet every morning. But we've gotta problem at some point. It is really easily exceeded the memory limitation of heroku. Our gSheet was too large to handle from script on free dyno! At the time, our record size was roughly over 6000 rows. When we load that sheet with [google-drive-ruby](https://github.com/gimite/google-drive-ruby), memory usage was over 1 GB so Heroku dyno usually kill that process of running script.
So we've decided to move to alternative tool, `AirTable`. So I hope this kind of stuff not gonna happen again on AirTable as well.

## Development

After checking out the repo, run `bin/setup` to install dependencies. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/airtable_plus. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

