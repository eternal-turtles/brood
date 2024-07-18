# brood

Brood allows you to generate test-fixture data from re-usable factories.

## Installation

System:

```ruby
gem install "brood"
```

Bundler:

```
source "https://rubygems.org"

group :test do
  gem "brood"
end
```

Next run `bundle install` to update your gem dependencies.

## Usage

Example:

```ruby
class Department
  attr_accessor :id, :name, :users
end

class User
  attr_accessor :id, :name, :department, :counter
end

# Define fabricators for models at spec/fabricators/*_fabricatory.rb.
Fabricator(:department) do
  id { sequence(:id) }
  name
end
Fabricator(:user) do
  id { sequence(:id) }
  name { Faker::Name.name }
  department
end

# Instantiate a brood:
@brood = Brood.new

# Fabricate objects:
gizmos = @brood.set([:department, :gizmos], {name: "Gizmos"}) # => Department instance
@brood.set([:user, :bar], {id: 12, name: "Bar"}) # => User instance
@brood.set([:user, :baaz], {name: "Baaz"}) # => User instance

# Pass a block to customize the object (forwarded to the Fabricator block argument):
@brood.set([:user, :baar], {name: "Baar"}) do |user|
  user.department = gizmos
end

# Retrieve objects:
@brood.get([:user, :bar]) # => User instance
@brood.get([:user, :baaz]) # => User instance
@brood.get([:user, :quux]) # raises Brood::ObjectNotFoundError
@brood.get([:bogus, :bar]) # raises ArgumentError

# Pass a block to customize and lock the object:
@brood.get([:user, :bar]) do |user|
  counter = user.counter
  sleep 0.0001
  user.counter = counter + 1
end # => User instance
```

See brood's own Minitest-based test suite for a more complete example.

## Development

### Commands

* `bundle exec rake`: run tests and lint
* `bundle exec standardrb`: lint
* `bundle exec yardoc`: generate YARD documentation

## Dependencies

* [fabrication](https://rubygems.org/gems/fabrication)

## Inspiration

See the following article by Martin Fowler: https://www.martinfowler.com/bliki/ObjectMother.html

## Author

* John Newton

## Copyright

* John Newton

## License

Apache-2.0
