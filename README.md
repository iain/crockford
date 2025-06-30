# Crockford

Douglas Crockford has described an alternate version of Base32. This is **NOT** [RFC 4648](https://tools.ietf.org/html/rfc4648).

It excludes the letters `I`, `L`, and `O`, to avoid confusion with digits. It
also excludes the letter `U` to reduce the likelihood of accidental obscenity.

Instead of rejecting the characters it excludes, it normalizes them. This means
that if somebody mistook a `0` for a `O`, we correct it instead of rejecting it.
This makes it great for cases where a person needs to type in the code by hand,
like a serial number, or a token sent via SMS.

For more information, see [Douglas Crockford's own website](https://www.crockford.com/base32.html).

Note: Crockford's Base32 also allows for a checksum character. This
functionality has not been implemented yet.

## Requirements

The encoding scheme is required to

- Be human readable and machine readable.
- Be compact. Humans have difficulty in manipulating long strings of arbitrary symbols.
- Be error resistant. Entering the symbols must not require keyboarding gymnastics.
- Be pronounceable. Humans should be able to accurately transmit the symbols to other humans using a telephone.

## Usage

Encoding and decoding numbers:

```ruby
Crockford.encode_number(1234) # => "16J"
Crockford.decode_number("16J") # => 1234
```

You can split up longer codes with hyphens. Hyphens are ignored when decoding:

```ruby
Crockford.encode_number(1234567890, split: 4) # => "14S-C0PJ"
Crockford.decode_number("14S-C0-PJ") # => 1234567890
```

Codes are automatically normalized (unknown characters will turn into `?`):

```ruby
Crockford.decode_number("oil") # => 33
Crockford.decode_number("011") # => 33
Crockford.normalize("oil") # => "011"
Crockford.normalize("wrong@") # => "WR0NG?"
Crockford.normalize("wrong@", unknown: "_") # => "WR0NG_"
```

You can encode and decode any string (or any raw bytes):

```ruby
data = SecureRandom.bytes(10) # => "\x06\x9D\xA5\xC1\x9C8\xA9W\xE9^"
code = Crockford.encode_string(data, split: 4) # => "TET-BGCW-72MN-FTAY"
Crockford.decode_string(code) == data # => true
```

Generate a code:

```ruby
Crockford.generate(length: 16, split: 4) # => "H222-WEQ8-RHE3-P707"
```

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'crockford'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install crockford

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then,
run `rake` to run the tests. You can also run `bin/console` for an interactive
prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`.
To release a new version, update the version number in `version.rb`, and
then run `bundle exec rake release`, which will create a git tag for the
version, push git commits and the created tag, and push the `.gem` file to
[rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at
https://github.com/iain/crockford. This project is intended to be a safe,
welcoming space for collaboration, and contributors are expected to adhere to
the [code of conduct](https://github.com/iain/crockford/blob/main/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the
[MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Crockford project's codebases, issue
trackers, chat rooms and mailing lists is expected to follow the
[code of conduct](https://github.com/iain/crockford/blob/main/CODE_OF_CONDUCT.md).

## Prior art

Some of these haven't been updated in over a decade:

- [base32-crockford](https://rubygems.org/gems/base32-crockford)
- [base32-multi](https://rubygems.org/gems/base32-multi)
- [base32-url](https://rubygems.org/gems/base32-url)
- [base32-alphabets](https://rubygems.org/gems/base32-alphabets)
