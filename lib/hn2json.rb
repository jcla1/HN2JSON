require 'rest-client'
require 'nokogiri'
require 'chronic'


# Public: Interface to HackerNews (news.ycombinator.com)
#
# Examples
#
#    HN2JSON.find 123456
#    # => HN2JSON::Entity:0xffffffffffffff
module HN2JSON
  extend HN2JSON

  autoload :Request,        'hn2json/request'

  autoload :Parser,         'hn2json/parser'

  autoload :Entity,         'hn2json/entity'

  autoload :InvalidIdError, 'hn2json/exceptions'
  autoload :RequestError,   'hn2json/exceptions'
  autoload :ParseError,     'hn2json/exceptions'

  autoload :VERSION,        'hn2json/version'

  # Public: Make a request to HackerNews and extract retrieved data.
  #
  # id  - The ID of the page to request
  #
  #
  # Returns the fetched HackerNews Entity.
  def find id
    check_for_falsy_id id
    Entity.new id
  end

  private

  # Internal: Check if a given ID is valid to be requested.
  #
  # id - The ID to check.
  #
  #
  # Returns nothing.
  # Raises HN2JSON::InvalidIdError if the ID is invalid.
  def check_for_falsy_id id
  	if id.class != Fixnum || id < 1
  		raise InvalidIdError, "id must be > 0 and a Fixnum, you passed #{id}"
  	end
  end
end