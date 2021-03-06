#!/usr/bin/env ruby
# This Quickstart Guide for the Speech API (custom) requires the Ruby codekit, 
# which can be found at: 
# https://github.com/attdevsupport/codekit-ruby

# Make sure that the att-codekit has been installed, then make the class required.
require 'att/codekit'

# Include the name spaces to reduce the code required (Optional).
include Att::Codekit

# If a proxy is required, uncomment the following line to set the proxy.
# Transport.proxy("http://proxyaddress.com:port")

# Use the app settings from developer.att.com for the following values.
# Make sure that the API scope is set to STTC for the Speech API (custom) 
# before retrieving the App Key and App Secret.

# Enter the value from 'App Key' field obtained at developer.att.com 
# in your app account.
client_id = 'ENTER VALUE!'

# Enter the value from 'App Secret' field obtained at developer.att.com 
# in your app account.
client_secret = 'ENTER VALUE!'

# Specify an audio file to convert to text.
AUDIO = "/path/to/audio/file"

# Specify a dictionary file to influence the conversion.
DICT = "/path/to/dictionary/file"

# Specify a grammar file to influence the conversion.
GRAMMAR = "/path/to/grammar/file"

# Set the fully-qualified domain name to: https://api.att.com
fqdn = 'https://api.att.com'

# Create the service for requesting an OAuth access token.
clientcred = Auth::ClientCred.new(fqdn, 
                                  client_id,
                                  client_secret)

# Get the OAuth access token using the API scope set to STTC.
token = clientcred.createToken('STTC')

# Create the service for interacting with the Speech API.
speech = Service::SpeechService.new(fqdn, token)

# Use exception handling to see if anything went wrong with the request.
begin

  # Convert the content of the audio file to text, using the specified 
  # dictionary and grammar files.
  response = speech.toText(AUDIO, DICT, GRAMMAR)

rescue Service::ServiceException => e

  # Display any error codes returned by the Gateway API.
  puts "There was an error, the API Gateway returned the following error code:"
  puts "#{e.message}"

else

  # Display all the data returned.
  puts "Converted Speech with status response: #{response.status}"
  puts "Speech ID: #{response.id}"
  puts
  puts "NBest values:"
  response.nbest.each do |n|
    puts "---------------"
    n.each_pair do |name, value|
      if name == :nlu_hypothesis
        puts "\tNLU Hypothesis:"
        value.each do |v|
          v.each_pair { |x, y| puts "\t\t#{x}: #{y}" }
        end
      else
        puts "\t#{name}: #{value}"
      end
    end
  end

end
