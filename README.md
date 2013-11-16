# Wemo

I sort of combined some stuff.  Hopefully noone is upset about the combination, I tried to make it clear where I found stuff.

## Installation

Add this line to your application's Gemfile:

    gem 'wemo'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install wemo

Use from the command line:

    $ wemo start friendlyName

    $ wemo start light
    $ wemo start pump
    $ wemo stop pump
    $ wemo stop light
    $ wemo start 'exhaust fan'

## Usage

    Wemo.off('friendlyName')
    Wemo.on('friendlyName')

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
