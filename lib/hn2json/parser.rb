module HN2JSON

  # Public: Parse HTML to produce HackerNews entities

  class Parser
    def initialize response

      html = response.html
      html.force_encoding "UTF-8"
      begin
        @doc = Nokogiri::HTML::DocumentFragment.parse html
      rescue
        raise ParseError, "there was an error parsing the page"
      end
    end


    def determine_type
      title = @doc.css('.title a')

      if title.length < 1
        if @doc.css('td').length > 7
          return :comment
        else
          return :error
        end
      else
        td = @doc.css('td')[12]

        if td.css('table').length > 0
          return :poll
        elsif td.css('form').length == 1
          return :discussion
        else
          return :post
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

    def get_attrs_poll entity

      title = @doc.css('.title a')[0].content

      td = @doc.css('td')[10]

      if td.css('table').length > 0
        fulltext = ''
        voting_on = voting_on_from_table td.css('table')[0]
      else
        fulltext = td.content
        voting_on = voting_on_from_table @doc.css('td')[12].css('table')[0]
      end

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

      entity.add_attrs do |e|
        e.title = title
        e.fulltext = fulltext
        e.date_posted = date_posted
        e.posted_by = posted_by
        e.votes = votes
        e.comments = comments
        #e.voting_on = voting_on
      end
    end

    def get_attrs_discussion entity

      title = @doc.css('.title a')[0].content

      fulltext = @doc.css('td')[10].content

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

      entity.add_attrs do |e|
        e.title = title
        e.fulltext = fulltext
        e.date_posted = date_posted
        e.posted_by = posted_by
        e.comments = comments
        e.votes = votes
      end
    end

    def voting_on_from_table table
      trs = table.css('tr')

      voting_on = []

      (trs.length / 3).times do 
        voting_on.push []
      end

      i = 0
      while i <= trs.length
        if i + 1 % 3 != 0
          if i % 2 == 0
            puts i % 3
            voting_on[(i - 1) % 3].push trs[i].css('.comment > div > font')[0].content
          else
            voting_on[i % 3].push trs[i].css('.default > .comhead > span')[0].content.gsub(/\spoints?/, '')
          end
        end
        i += 1
      end

      return []
    end

  end

end