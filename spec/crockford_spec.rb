# frozen_string_literal: true

require "securerandom"

RSpec.describe Crockford do

  it "has a version number" do
    expect(Crockford::VERSION).not_to be nil
  end

  it "encodes a single value" do
    expect(Crockford.encode(31)).to eq("Z")
    expect(Crockford.decode("Z")).to eq(31)
  end

  it "encodes longer" do
    expect(Crockford.encode(1234)).to eq("16J")
    expect(Crockford.decode("16J")).to eq(1234)
  end

  it "generates fixed length" do
    expect(Crockford.generate(length: 6, split: 3).size).to eq 7
  end

  xit "encodes strings" do
    bytes = SecureRandom.bytes(16)
    expect(Crockford.decode_bytes(Crockford.encode_bytes(bytes))).to eq bytes
  end

  it "does more"  do
    expect(Crockford.decode("OI")).to eq(1)
    expect(Crockford.decode("3G923-0VQVS")).to eq(123456789012345)
  end

  it "normalizes" do
    expect(Crockford.normalize("OIP")).to eq("01P")
    expect(Crockford.normalize("AUB")).to eq("A?B")
    expect(Crockford.normalize("AUB", split: 2)).to eq("A-?B")
    expect(Crockford.normalize("AUB", length: 4)).to eq("0A?B")
  end

  it "splits" do
    expect(Crockford.encode(100**10, split: 5, length: 15)).to eq("02PQH-TY5NH-H0000")
    expect(Crockford.decode("2pqh-ty5nh-hoooo")).to eq(100**10)
  end

end
