module HN2JSON

  # Public: Parse HTML to produce HackerNews entities

  class Parser
    def initialize response
      @doc = Nokogiri::HTML::DocumentFragment.parse response.html
    end


    def determine_type
      title = @doc.css('.title a')

      if title.length < 1
        return :comment
      else
        forms = @doc.css('td form')
        if forms.length === 1
          return :poll
        else
          forms = @doc.css('td')[10].css('form')
          if forms.length === 1
            return :post
          else
            return :discussion
          end
        end
      end

    end

  end

end