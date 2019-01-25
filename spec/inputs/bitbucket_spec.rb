# encoding: utf-8
require "logstash/devutils/rspec/spec_helper"
require "logstash/inputs/bitbucket"

describe LogStash::Inputs::Bitbucket do
  #create a new instance of the class Bitbucket named subject with the following configuration
  subject { LogStash::Inputs::Bitbucket.new(config) }
  let(:config) do
  {
        'schedule' => { "foo" => "bar", "tak" => "jon" },
        'scheme' => 'foo',
        'hostname' => 'foo',
        'port' => '12345',
        'token' => 'foo'
  }
  end

  #assures that we initialized all required configuration vars
  describe "bitbucket authorization" do
    it "not raise error" do
      expect {subject.register}.to_not raise_error
    end
  end


#  let (:queue) { Queue.new }
#  describe "handling API response" do
#    it "handles generic input" do

