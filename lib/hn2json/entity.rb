module HN2JSON
  # Internal: Represents a post, poll, discussion or comment on HackerNews.
  class Entity

    # Public: Returns the IDs of all top-level comments.
    attr_accessor :comments

    # Public: Returns the String date when the Entity was posted to HackerNews.
    attr_accessor :date_posted

    # Public: Return the String text of the Entity, if available.
    attr_accessor :fulltext

    # Public: Returns the Integer ID of the Entity
    attr_accessor :id

    # Public: Returns the Integer ID of the parent, if available
    attr_accessor :parent

    # Public: Returns the String username of the user who posted the Entity
    attr_accessor :posted_by

    # Public: Returns the String title of the Entity, if available
    attr_accessor :title

    # Public: Returns the Symbol type of the Entity (:post, :poll, :discussion, :comment)
    attr_accessor :type

    # Public: Returns the String url of an Entity, if available
    attr_accessor :url

    # Public: Returns the Interger number of upvotes the Entity has recieved
    attr_accessor :votes

    # Public: Returns a 2D Array of ["Thing you're voting on", number of upvotes]
    attr_accessor :voting_on


    def initialize id, preserve_html=false
      @id = id

      @type = nil
      @parent = nil
      @url = nil
      @title = nil
      @fulltext = nil
      @posted_by = nil
      @date_posted = nil
      @voting_on = nil
      @comments = nil
      @votes = nil

      get_page
      determine_type

      get_attrs

      remove_instance_variable :@html unless preserve_html
      remove_instance_variable :@parser unless preserve_html
    end

    def get_page
      @html = Request.new(id)
      @parser = Parser.new @html
    end

    def determine_type
      @type = @parser.determine_type
    end

    def get_attrs
      case @type
        when :post
          @parser.get_attrs_post self
        when :comment
          @parser.get_attrs_comment self
        when :poll
          @parser.get_attrs_poll self
        when :discussion
          @parser.get_attrs_discussion self
        when :job
          @parser.get_attrs_job self
        when :error
          raise ParseError, "Parser could not determine type on #{@id}"
        end
    end
    
    # Internal: Yields self for adding attr
    #
    # Examples
    #
    #   entity.add_attrs do |entity|
    #     entity.title = "Hello World!"
    #   end
    #
    # Returns nothing.
    def add_attrs
      yield self
    end

  end

end