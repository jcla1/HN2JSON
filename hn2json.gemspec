require File.dirname(__FILE__) + '/lib/hn2json/version'

Gem::Specification.new do |s|
  s.name              = "hn2json"
  s.version           = HN2JSON::VERSION
  s.date              = Time.now.strftime('%Y-%m-%d')
  s.summary           = "A Ruby interface to HackerNews"
  s.homepage          = "http://github.com/jcla1/HN2JSON"
  s.email             = "whitegolem@gmail.com"
  s.authors           = [ "Joseph Adams" ]
  s.has_rdoc          = false

  s.files             = %w( README.md Rakefile LICENSE )
  s.files            += Dir.glob("lib/**/*")

  s.add_dependency    "rest-client",  "~> 1.6.7"
  s.add_dependency    "nokogiri",  "~> 1.5.5"
  s.add_dependency    "chronic",  "~> 0.7.0"

  #s.files            += Dir.glob("bin/**/*")
  #s.executables       = %w( hn2json )

  s.description       = <<desc
    HN2JSON is a developer frendly interface to HackerNews.
    It provides the functionality to retrieve any HN content
    page in stringified JSON or a Ruby object.
desc
end