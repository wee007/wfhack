#!/usr/bin/env ruby 
require File.expand_path('../../../config/application', __FILE__)
require 'service_helper'

# grab the version from the deployed site
host = WestfieldUri::Console.uri_for('customer').to_s.gsub(/\/$/, '')
path = "/version.txt?#{Time.now.to_i}"
uri = URI.parse("#{host}#{path}")  
version = open(uri).gets.gsub(/\n/, '')
tag = "wf-customerconsole-#{version}-1"

puts 'Preparing for acceptance tests:'
puts "Resetting HEAD to tag: #{tag}..."

# reset HEAD to tag
# since this is going to be temporary...
puts exec "git reset --hard #{tag}"
