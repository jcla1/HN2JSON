module HN2JSON

  # Public: Parse HTML to produce HackerNews entities

  class Parser

    attr_reader :doc

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

      comhead = @doc.css('.comhead')[0]

      if !!comhead

        return :post if comhead.content.gsub(/\s\(.*\)\s/, '').length == 0

        return :comment if comhead.content.count('|') >= 2

      end
      
      subtext = @doc.css('.subtext')[0]

      return :error unless subtext 

      return :job if subtext.content.split.length <= 3

      tr = subtext.xpath('..').xpath('..').css('tr')

      if tr.length == 4 || tr.last.css('form').length == 1
        return :discussion
      else
        return :poll
      end

    end

    def get_attrs_job entity

      title = @doc.css('.title a')[0].content

      subtext = @doc.css('.subtext')[0]

      date_regex = /(.*\s.*\sago)/
      ago = date_regex.match(subtext.content)[1]
      date_posted = Chronic.parse(ago).to_s      

      fulltext = @doc.css('td')[10].content

      entity.add_attrs do |e|
        e.title = title
        e.date_posted = date_posted
        e.fulltext = fulltext
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
      
      date_posted = get_date comhead

      posted_by = get_posted_by comhead

      comments = get_comments

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

      date_posted = get_date subtext

      posted_by = get_posted_by subtext

      votes = get_num_votes subtext

      comments = get_comments

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

      subtext = @doc.css('.subtext')[0]

      date_posted = get_date subtext

      posted_by = get_posted_by subtext

      votes = get_num_votes subtext

      comments = get_comments


      fulltext_elem = @doc.css('tr[style="height:2px"] + tr > td')

      if fulltext_elem.length == 2
        fulltext = fulltext_elem[1].content
      else
        fulltext = ''
      end

      voting_on = get_voting_on

      entity.add_attrs do |e|
        e.title = title
        e.fulltext = fulltext
        e.date_posted = date_posted
        e.posted_by = posted_by
        e.votes = votes
        e.comments = comments
        e.voting_on = voting_on
      end
    end

    def get_attrs_discussion entity

      title = @doc.css('.title a')[0].content

      fulltext = @doc.css('td')[10].content

      subtext = @doc.css('.subtext')[0]

      date_posted = get_date subtext      

      posted_by = get_posted_by subtext

      votes = get_num_votes subtext

      comments = get_comments

      entity.add_attrs do |e|
        e.title = title
        e.fulltext = fulltext
        e.date_posted = date_posted
        e.posted_by = posted_by
        e.comments = comments
        e.votes = votes
      end
    end


    def get_voting_on 
      voting_on = []
      trs = @doc.css('tr > td + td > table tr')

      trs.each_with_index do |tr, index|
        if index % 3 == 0
          voting_on.push []
          voting_on[(index / 3).floor].push tr.content
        elsif index % 3 == 1
          voting_on[(index / 3).floor].push tr.content.gsub(/\spoints/, '')
        end
      end

      return voting_on

    end

    def get_comments
      comments = []

      full_comments = @doc.css('td > img[width="0"]').xpath("..").xpath("..").css('.default')

      full_comments.each do |comment|
        comment_id = comment.css('span a')[1]['href'].gsub("item?id=", '')
        comments.push comment_id
      end

      # TODO: Follow the [More] link
      #
      # $tr = $('tr')
      # $($tr[$tr.length - 3]).find('a').eq(0).attr('href')

      comments = get_comments_more doc, comments

      return comments
    end

    def get_comments_more doc, comments
      trs = doc.css('tr .title a')

      if trs.length == 0
        return comments
      end

      url = trs.last['href']

      url_regex = /\/x\?fnid=(.*)/

      match = url_regex.match(url)

      if match == nil
        return comments
      end

      req = Request.new match[1], true
      parser = Parser.new req

      comments = comments + parser.get_comments

      return comments
    end

    def get_num_votes subtext
      return subtext.css('span')[0].content.to_i
    end

    def get_posted_by subtext
      return subtext.css('a')[0].content
    end

    def get_date subtext
      date_regex = /.*\s(.*\s.*\sago)/
      ago = date_regex.match(subtext.content)[1]
      date_posted = Chronic.parse(ago).to_s

      return date_posted
    end

  end

end