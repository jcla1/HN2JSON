module HN2JSON

  class Request
    attr_accessor :html

    def initialize id, more_page=false
      @base_url = "http://news.ycombinator.com/item?id="
      @complete_url = @base_url + id.to_s

      if more_page
        @complete_url = "http://news.ycombinator.com/x?fnid=" + id
      end

      request_page
    end

    private

    def request_page
      begin
        @html = RestClient.get @complete_url
      rescue
        raise RequestError, "there was an error requesting the page, check your connection"
      end

      if @html == "No such item." || @html == "Unknown."
        id = @complete_url.gsub(/^.*id\=/, '')
        raise RequestError, "no such item or id, #{id}"
      end
    end

  end

end