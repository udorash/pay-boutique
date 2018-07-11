# PayBoutique

The PayBoutique meant to offer an alternate object-oriented model of development with the PayBoutique APIs

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'pay_boutique'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install pay_boutique

## Usage
Configure your app
```ruby
PayBoutique.config do |config|
  config.site_address = PAY_BOUTIQUE[:site_address]
  config.buyer_currency = PAY_BOUTIQUE[:buyer_currency]
  config.merchant_currency = PAY_BOUTIQUE[:merchant_currency]
  config.password = PAY_BOUTIQUE[:password]
  config.live = PAY_BOUTIQUE[:live]
  config.credit_card_postback_url = PAY_BOUTIQUE[:credit_card_postback_url]
  config.merchant_id = PAY_BOUTIQUE[:merchant_id]
  config.success_url = PAY_BOUTIQUE[:success_url]
  config.failure_url = PAY_BOUTIQUE[:failure_url]
  config.qiwi_postback_url = PAY_BOUTIQUE[:qiwi_postback_url]
  config.user_id = PAY_BOUTIQUE[:user_id]
  config.request_url = PAY_BOUTIQUE[:request_url]
  config.postback_url = PAY_BOUTIQUE[:postback_url]
end
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release` to create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

1. Fork it ( https://github.com/[my-github-username]/pay_boutique/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
# pay_boutique

# Docs

Here you can see api docs [https://sites.google.com/a/payboutique.com/paybwiki/wiki/xml_v0-5](https://sites.google.com/a/payboutique.com/paybwiki/wiki/xml_v0-5)
