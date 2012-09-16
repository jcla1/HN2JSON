require 'rest-client'
require 'nokogiri'
require 'chronic'

module HN2JSON
  autoload :Request,    'hn2json/request'

  autoload :Parser,     'hn2json/parser'

  autoload :Entity,      'hn2json/entity'


  autoload :VERSION,    'hn2json/version'
end