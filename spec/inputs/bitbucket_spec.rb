# encoding: utf-8
require "logstash/devutils/rspec/spec_helper"
require "logstash/inputs/bitbucket"
require "response"

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


  #ruby STL queue, works like a stack
  let (:queue) { Queue.new }

  #calls the method request_async and gives bad input into the function to expectedly fail
  #specifically, the path string should have '/' between folder names
  describe "handling API call with bad input" do
    it "handles generic input" do
      path = 'invalid garbage input'
      parameters = {}
      request_options = {}
      callback = double("test data")
      expect {subject.request_async(
        queue, path, parameters, request_options, callback
        )}.to raise_error
    end
  end

  #inverse of the previous test, passes in good data and succeeds
  describe "handling API call with good input" do
    it "handles generic input" do
      path = 'valid/garbage/path'
      parameters = {}
      request_options = {}
      callback = double("test data")
      expect {subject.request_async(
        queue, path, parameters, request_options, callback
        )}.to_not raise_error
    end
  end

  #let(:response) { IO.read("response.json") }
  describe "parsing data with real input" do

    it "iterates over the data" do

      response = Response.new(IO.read("response.json"))

      uri = double("foo")
      execution_time = double("bar")
      parameters = {}
      #def handle_pull_requests_response(queue, uri, parameters, response, execution_time)
      expect {subject.handle_repos_response(
        queue, uri, parameters, response, execution_time
        )}.to_not raise_error
    end
  end

  #handle_projects_response
end
