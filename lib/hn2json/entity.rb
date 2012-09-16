module HN2JSON

  class Entity

    attr_accessor :type, :id, :parent, :url, :title, :comments, :votes
    attr_accessor :fulltext, :posted_by, :date_posted, :voting_on

    def initialize id
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
    end

    def get_page
      @html = Request.new(id)
      @parser = Parser.new @html
    end

    def determine_type
      @type = @parser.determine_type
    end

    def get_attrs
      eval("@parser.get_attrs_#{@type.to_s} self")
    end

    def add_attrs
      yield self
    end

  end

end