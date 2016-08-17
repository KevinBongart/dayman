# Dayman

![Dayman](http://screenshots.kevinbongart.net/AiJbs.gif)

Yet another JSON API client, heavily inspired by
[json_api_client](https://github.com/chingor13/json_api_client) and
[ActiveRecord](http://api.rubyonrails.org/classes/ActiveRecord/Base.html).

⚠️ Not currently feature complete! ⚠️

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'dayman'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install dayman

## Usage

```ruby
module CoolPetsApi
  class Base < Dayman::Resource
    self.site = "http://coolpets.com"
  end

  class CoolDog < Dayman::Resource
  end
end

CoolPetsApi::CoolDog.all
# GET "http://coolpets.com/cool_dogs"

CoolPetsApi::CoolDog.find(123)
# GET "http://coolpets.com/cool_dogs/123"

CoolPetsApi::CoolDog.where(name: "Wolfie").where(age: 2).all
# GET "http://coolpets.com/cool_dogs?filter[name]=Wolfie&filter[age]=2"

CoolPetsApi::CoolDog.select(:name, :age).select(friends: :coolness).all
# GET "http://coolpets.com/cool_dogs?fields[cool_dogs]=name,age&fields[friends]=coolness"

CoolPetsApi::CoolDog.includes(friends: :owner).all
# GET "http://coolpets.com/cool_dogs?include=friends.owner"
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/dayman. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
