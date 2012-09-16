module HN2JSON

  class Entity

    attr_accessor :type, :id, :parent, :url, :title, :comments, :votes
    attr_accessor :full_text, :posted_by, :date_posted, :voting_on

    def initialize id
      @id = id

      @type = nil
      @parent = nil
      @url = nil
      @title = nil
      @full_text = nil
      @posted_by = nil
      @date_posted = nil
      @voting_on = nil
      @comments = nil
      @votes = nil

      get_page
      determine_type
    end

    def get_page
      @html = Request.new(id)
      @parser = Parser.new @html
    end

    def determine_type
      @type = @parser.determine_type
    end

  end

end