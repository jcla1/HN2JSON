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
      begin
        @html = RestClient.get @complete_url
      rescue Exception
        @html = ""
      end
    end

  end

end