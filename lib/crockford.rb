# frozen_string_literal: true

require_relative "crockford/version"

module Crockford
  ENCODER = %w[0 1 2 3 4 5 6 7 8 9 A B C D E F G H J K M N P Q R S T V W X Y Z]
  DECODER = ENCODER.each_with_index.to_h.transform_keys(&:to_s).merge({"I" => 1, "L" => 1, "O" => 0}).freeze

  class << self
    def encode_number(number, **kwargs)
      string = number.to_s(2).each_char.reverse_each.each_slice(5).map { |bits|
        ENCODER[bits.reverse.join.to_i(2)]
      }.reverse.join

      format_code(string, **kwargs)
    end

    def decode_number(string)
      clean_code(string).each_char.inject(0) { |result, char|
        val = DECODER[char]
        return nil if val.nil?
        (result << 5) + val
      }
    end

    def encode_string(string, **kwargs)
      number = string.bytes.map { |byte| "%08b" % byte }.join.to_i(2)
      encode_number(number, **kwargs)
    end

    def decode_string(string)
      number = decode_number(string)
      return nil if number.nil?
      number.to_s(2).each_char.reverse_each.each_slice(8).map { |byte|
        byte.reverse.join.to_i(2)
      }.reverse.pack("C*")
    end

    def normalize(string, unknown: "?", **kwargs)
      string = clean_code(string).each_char.inject("") { |memo, char|
        memo + ((index = DECODER[char]) ? ENCODER[index] : unknown)
      }
      format_code(string, **kwargs)
    end

    def valid?(string)
      !decode_number(string).nil?
    end

    def generate(length:, split: false)
      encode_number(SecureRandom.random_number(32**length), split: split, length: length)
    end

    private

    def clean_code(string)
      string.delete("-").upcase
    end

    def format_code(string, length: nil, split: false)
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
end
