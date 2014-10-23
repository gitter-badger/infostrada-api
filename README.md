# Infostrada API
[![Gitter](https://badges.gitter.im/Join Chat.svg)](https://gitter.im/rikas/infostrada-api?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)

This is a wrapper for [infostrada](http://www.infostradasports.com/) football API.

## Installation

Add this line to your application's Gemfile:

```console
$ gem 'infostrada-api'
```

And then execute:

```console
$ bundle
```

Or install it yourself as:

```console
$ gem install infostrada-api
```

## Usage

First you have to configure API access with user and password:

```ruby
Infostrada.configure do |config|
  config.auth_user = infostrada_user
  config.auth_password = infostrada_password
end
```

## Contributing

1. Fork it ( http://github.com/rikas/infostrada-api/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
