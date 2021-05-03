# frozen_string_literal: true

require_relative "crockford/version"

module Crockford
  ENCODER = %w[0 1 2 3 4 5 6 7 8 9 A B C D E F G H J K M N P Q R S T V W X Y Z]

  DECODER = ENCODER.each_with_index.to_h.transform_keys(&:to_s).merge({"I" => 1, "L" => 1, "O" => 0}).freeze

  def self.encode(input, **kwargs)
    case input
    when Integer
      encode_number(input, **kwargs)
    else
      encode_bytes(input.to_str, **kwargs)
    end
  end

  def self.decode(string)
    decode_number(string)
  end

  def self.encode_number(number, split: false, length: nil)
    fail ArgumentError, "Not a number: #{number.inspect}" unless number.is_a?(Integer)

    string = number.to_s(2).each_char.reverse_each.each_slice(5).map { |bits|
      ENCODER[bits.reverse.join.to_i(2)]
    }.reverse.join

    _format(string, split: split, length: length)
  end

  def self.decode_number(string)
    _clean(string).each_char.inject(0) { |result, char|
      val = DECODER[char]
      return nil if val.nil?
      (result << 5) + val
    }
  end

  def self.encode_bytes(string, split: false, length: nil)
    number = string.bytes.map { |byte| "%08b" % byte }.join.to_i(2)
    encode_number(number, split: split, length: length)
  end

  def self.decode_bytes(string)
    number = decode_number(string)
    return nil if number.nil?
    number.to_s(2).each_char.reverse_each.each_slice(8).map { |byte|
      byte.reverse.join.to_i(2)
    }.reverse.pack("C*")
  end

  def self.normalize(string, split: false, length: string.length, unknown: "?")
    string = _clean(string).each_char.inject("") { |memo, char|
      memo + ((index = DECODER[char]) ? ENCODER[index] : unknown)
    }
    _format(string, split: split, length: length)
  end

  def self.valid?(string)
    !decode_number(sting).nil?
  end

  def self.generate(length:, split: false)
    encode_number(SecureRandom.random_number(32**length), split: split, length: length)
  end

  def self._clean(string)
    string.delete("-").upcase
  end

  def self._format(string, length: nil, split: false)
    if length
      string = string.rjust(length, "0")
    end

    if split
      string = string
        .each_char
        .reverse_each
        .each_slice(split)
        .map { |segment| segment.reverse.join }
        .reverse
        .join("-")
    end

    string
  end
end
