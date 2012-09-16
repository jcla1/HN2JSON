module HN2JSON

  class Request
    attr_accessor :html

    def initialize id
      @base_url = "http://news.ycombinator.com/item?id="
      @complete_url = @base_url + id.to_s

      request_page
    end

    private

    def request_page
      @html = RestClient.get @complete_url
    end

  end

end