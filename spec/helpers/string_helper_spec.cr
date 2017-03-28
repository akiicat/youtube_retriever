require "spec"
require "../../src/helpers/string_helper"

describe String do
  it "#swap" do
    "abcdefghijk".swap(3, 8).should eq("abciefghdjk")
    "abcdefghijk".swap(0, 8).should eq("ibcdefghajk")
    "abcdefghijk".swap(3,-1).should eq("abckefghijd")
    "abcdefghijk".swap(0,-1).should eq("kbcdefghija")
  end
end
