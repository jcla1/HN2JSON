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

    def get_attrs_comment entity

      parent_url = @doc.css('.comhead a')[2]['href']
      parent_regex = /id\=(.*)/
      parent = parent_regex.match(parent_url)[1]
      
      fulltext_nolinks = @doc.css('.comment')[0].to_s
      fulltext_nolinks = fulltext_nolinks.gsub(/\<a\shref\=['"](.*)['"].*rel\=.*\>.*\<\/a\>/, '\1')
      fulltext = fulltext_nolinks.gsub(/<\/?[^>]*>/, '')

      comhead = @doc.css('.comhead')[0]
      
      date_regex = /.*\s(.*\s.*\sago)/
      ago = date_regex.match(comhead.content)[1]
      date_posted = Chronic.parse(ago).to_s

      posted_by = comhead.css('a')[0].content

      comments = []

      full_comments = @doc.css('td > img[width="0"]').xpath("..").xpath("..").css('.default')

      full_comments.each do |comment|
        comment_id = comment.css('span a')[1]['href'].gsub("item?id=", '')
        comments.push comment_id
      end

      entity.add_attrs do |e|
        e.parent = parent
        e.fulltext = fulltext
        e.date_posted = date_posted
        e.comments = comments
        e.posted_by = posted_by
      end
    end


    def get_attrs_post entity

      subtext = @doc.css('.subtext')[0]

      date_regex = /.*\s(.*\s.*\sago)/
      ago = date_regex.match(subtext.content)[1]
      date_posted = Chronic.parse(ago).to_s

      posted_by = subtext.css('a')[0].content

      votes = subtext.css('span')[0].content.to_i

      comments = []

      full_comments = @doc.css('td > img[width="0"]').xpath("..").xpath("..").css('.default')

      full_comments.each do |comment|
        comment_id = comment.css('span a')[1]['href'].gsub("item?id=", '')
        comments.push comment_id
      end

      head = @doc.css('.title a')[0]

      title = head.content

      url = head['href']

      entity.add_attrs do |e|
        e.url = url
        e.title = title
        e.date_posted = date_posted
        e.comments = comments
        e.votes = votes
        e.posted_by = posted_by
      end
    end

#    def get_attrs_poll entity
#      entity.add_attrs do |e|
#        e.title =
#        e.fulltext =
#        e.date_posted =
#        e.posted_by =
#        e.votes =
#        e.comments =
#        voting_on =
#      end
#    end
#
#    def get_attrs_discussion entity
#      entity.add_attrs do |e|
#        e.title =
#        e.fulltext =
#        e.date_posted =
#        e.posted_by =
#        e.comments =
#        e.votes =
#      end
#    end

  end

end