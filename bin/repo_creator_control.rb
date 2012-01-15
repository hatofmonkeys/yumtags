require 'rubygems'
require 'daemons'

Daemons.run(File.join(File.dirname(__FILE__),'../app/lib/repo_creator.rb'))