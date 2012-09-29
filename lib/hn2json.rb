require 'rest-client'
require 'nokogiri'
require 'chronic'

module HN2JSON
  extend HN2JSON

  autoload :Request,    'hn2json/request'

  autoload :Parser,     'hn2json/parser'

  autoload :Entity,      'hn2json/entity'

  autoload :InvalidIdError, 'hn2json/exceptions'

  autoload :VERSION,    'hn2json/version'

  def find id
  	check_for_falsy_id id
  	Entity.new id
  end

  private

  def check_for_falsy_id id
  	if id.class != Fixnum || id < 1
  		raise InvalidIdError, "id must be > 0 and a Fixnum, you passed #{id}"
  	end
  end
end