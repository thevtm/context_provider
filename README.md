# ContextProvider

This is the Ruby version of the context pattern originally outlined in 
[React](https://reactjs.org/docs/context.html). 

The context patter is a solution for a problem that in React is called prop 
drilling.

We have found this pattern to be quite useful for Rails applications. 

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'context_provider'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install contextprovider

## Usage

A `ContextProvider` allows data to be passed down the call stack in a explicit
way while avoiding having to pass parameters just so it can be used by a nested
function.

```ruby
fooContext = ContextProvider.new

fooContext.value_provided? #=> false
fooContext.get # raises ContextNotProvidedError

fooContext.provide("bar") do
  if fooContext.value_provided? #=> true
    fooContext.get #=> "bar"
  end
  
  fooContext.provide("baz") do # raise ContextAlreadyProvidedError
    # ...
  end
  
  fooContext.where_provide_was_called #=> `provide` caller call stack
end
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run 
`rake test` to run the tests. You can also run `bin/console` for an 
interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run 
`bundle exec rake install`. To release a new version, update the version 
number in `version.rb`, and then run `bundle exec rake release`, which 
will create a git tag for the version, push git commits and tags, and 
push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at 
https://github.com/thevtm/contextprovider.

