require 'rake/clean'
require 'rubygems'
require 'jeweler'  
  
task :default do
  puts 'this does some stuff'
end

namespace :jeweler do

  Jeweler::Tasks.new do |gs|
    gs.name = "subsea"
    gs.summary = "Simple fast http page crawler"
    gs.description = "Quickly crawl one of more domains and see if the pages are working or not"
    gs.email = "chris@jonezy.org"
    gs.homepage = "http://github.com/jonezy/subsea"
    gs.authors = ["Chris Jones"]
    gs.has_rdoc = false  
    gs.files.exclude("./subsea.gemspec", "../.gitignore", "test/*.rb", "../**/*.rb")

    gs.add_dependency('nokogiri', '>= 1.4.2')

    gs.add_development_dependency('jeweler', '>= 1.2.1')
  end
end
