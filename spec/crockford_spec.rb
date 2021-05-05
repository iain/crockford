# frozen_string_literal: true

require "securerandom"

RSpec.describe Crockford do

  it "has a version number" do
    expect(Crockford::VERSION).not_to be nil
  end

  it "encodes a single value" do
    expect(Crockford.encode_number(31)).to eq("Z")
    expect(Crockford.decode_number("Z")).to eq(31)
  end

  it "encodes longer" do
    expect(Crockford.encode_number(1234)).to eq("16J")
    expect(Crockford.decode_number("16J")).to eq(1234)
  end

  it "generates fixed length" do
    expect(Crockford.generate(length: 6, split: 3).size).to eq 7
  end

  it "encodes byte strings" do
    bytes = SecureRandom.bytes(16)
    code = Crockford.encode_string(bytes)
    expect(Crockford.decode_string(code)).to eq bytes
  end

  it "does more" do
    expect(Crockford.decode_number("OI")).to eq(1)
    expect(Crockford.decode_number("3G923-0VQVS")).to eq(123456789012345)
  end

  it "normalizes" do
    expect(Crockford.normalize("OIP")).to eq("01P")
    expect(Crockford.normalize("AUB")).to eq("A?B")
    expect(Crockford.normalize("AUB", split: 2)).to eq("A-?B")
    expect(Crockford.normalize("AUB", length: 4)).to eq("0A?B")
  end

  it "splits" do
    expect(Crockford.encode_number(100**10, split: 5, length: 15)).to eq("02PQH-TY5NH-H0000")
    expect(Crockford.decode_number("2pqh-ty5nh-hoooo")).to eq(100**10)
  end

end
