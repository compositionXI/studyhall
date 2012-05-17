require 'net/http'
require 'amazon/ecs'

class Textbook < ActiveRecord::Base
  attr_accessible :course_id, :textbook_html, :offering_id, :users_w_book
  
  $current_term = 'FALL 2012'
  
  def self.get_isbn(user, dept, num)
    campus = Textbook.get_campus(user)
    isbns, titles = Textbook.get_isbn_and_title(campus, dept, num)
    item_iter = 0
    item_link = '<table class="text_offer" style="width:350px">'
    item_url = ''
    image_url = ''
    lowest_price = ''
    if isbns != 'error'
      isbns.each do |isbn|
        item_url, image_url, lowest_price = Textbook.generate_amazon_links(isbn)
        if(item_url != '')
          item_link << '<tr><td class="text_img" style="width:80px;margin:10px 5px 10px 0;"><img src="' + image_url + '" /></td><td class="text_desc" style="width:200px;margin:10px 5px 10px 0;"><a href="' + item_url + '" style="margin: 0 0 4px 0;" target="_blank">' + titles[item_iter] + '</a><br/><a href="' + item_url + '" style="margin: 0 0 0 0;" target="_blank">Buy for ' + lowest_price + '</a></td></tr>'
        end
        item_iter += 1
      end
      item_link << '</table>'
      return item_link
    else
      return 'no_text'
    end    
  end
  
  def self.get_campus(user)
    begin
      uri = URI('http://studyhalltext.pagodabox.com/content/api.php')
      res = Net::HTTP.get(uri)
      parsed_json = ActiveSupport::JSON.decode(res)
      campus_data = parsed_json['data']
      school = user.school.name.scan(/\w+/)
      school_string = ''
      school.each do |sn|
        school_string << sn unless sn =~ /the/i
      end
      campus_id = ''
      campus_data.each do |cdata|
        poss_school = cdata['name'].scan(/\w+/)
        poss_string = ''
        poss_school.each do |ps|
          poss_string << ps unless ps =~ /the/i
        end
        if(school_string.to_s == poss_string.to_s)
          campus_id = cdata['id']
          break
        end
      end
      return campus_id
    rescue
      return 'error'
    end
  end
  
  def self.get_isbn_and_title(campus_id, dept, num)
    begin
      uri = URI('http://studyhalltext.pagodabox.com/content/api.php')
      #get term
      params = { :campus => campus_id }
      uri.query = URI.encode_www_form(params)
      res = Net::HTTP.get_response(uri)
      parsed_json = ActiveSupport::JSON.decode(res.body)
      campus_data = parsed_json['data']
      term_id = ''
      campus_data.each do |cdata|
        if(cdata['name'] == $current_term)
          term_id = cdata['id']
          break
        end
      end
      #now get division
      params = { :campus => campus_id, :term => term_id }
      uri.query = URI.encode_www_form(params)
      res = Net::HTTP.get_response(uri)
      parsed_json = ActiveSupport::JSON.decode(res.body)
      division_id = parsed_json['data'].first['id']
      #now get the dept json
      params = { :campus => campus_id, :term => term_id, :division => division_id }
      uri.query = URI.encode_www_form(params)
      res = Net::HTTP.get_response(uri)
      dept_json = ActiveSupport::JSON.decode(res.body)['data']
      #find the dept
      dept_id = ''
      temp_dept = ''
      dept_json.each do |dj|
        temp_dept = dj['name'].to_s.split('(') #in case dept is in ()
        if(temp_dept.length == 1) # this is typical dept listings
          temp_dept = temp_dept[0]
        else
          temp_dept = temp_dept[1]
        end
        if dept == temp_dept.split(')')[0]
          dept_id = dj['id']
          break
        end
      end
      #find the course number
      params = { :campus => campus_id, :term => term_id, :division => division_id, :dept => dept_id }
      uri.query = URI.encode_www_form(params)
      res = Net::HTTP.get_response(uri)
      parsed_json = ActiveSupport::JSON.decode(res.body)
      course_json = parsed_json['data']
      course_id = ''
      course_json.each do |cj|
        if cj['name'] == num
          course_id = cj['id']
          break
        end
      end
      #find the section name
      params = { :campus => campus_id, :term => term_id, :division => division_id, :dept => dept_id, :course => course_id }
      uri.query = URI.encode_www_form(params)
      res = Net::HTTP.get_response(uri)
      parsed_json = ActiveSupport::JSON.decode(res.body)
      section_id = parsed_json['data'][0]['id'] #we don't have multiple section support yet
      #now get the books
      uri = URI('http://studyhalltext.pagodabox.com/content/api.php')
      params = { :campus => campus_id, :term => term_id, :division => division_id, :dept => dept_id, :course => course_id, :section => section_id }
      uri.query = URI.encode_www_form(params)
      res = Net::HTTP.get_response(uri)
      books_json = ActiveSupport::JSON.decode(res.body)
      if(books_json['status'] == 'ok')
        books_json = books_json['data']['items']
        isbn_out = []
        title_out = []
        books_json.each do |bjson|
          isbn_out << bjson['isbn']
          title_out << bjson['title']
        end
        return isbn_out, title_out
      else
        return 'error', 'error'
      end
    rescue
      return 'error', 'error'
    end
  end
  
  def self.generate_amazon_links(isbn)
    begin
      Amazon::Ecs.options = {
        :associate_tag => 'studyhcom-20',
        :AWS_access_key_id => 'AKIAIETU7HT7R2K3PCYQ',
        :AWS_secret_key  => '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'
      }
      res = Amazon::Ecs.item_search(isbn, {:response_group => 'Medium'})
      if res.has_error?
        return '', '', ''
      else
        top_result = res.items.first
        item_url = top_result.get('DetailPageURL')
        image_url = top_result.get_hash('SmallImage').nil? ? "/assets/textbook_temp.gif" : top_result.get('SmallImage/URL')
        lowest_new = top_result.get('OfferSummary/LowestNewPrice/Amount').to_i
        lowest_used = top_result.get('OfferSummary/LowestUsedPrice/Amount').to_i
        lowest_price = (lowest_new < lowest_used ? lowest_new.to_s : lowest_used.to_s)
        lp_c = lowest_price[-2..-1]
        lp_d = lowest_price[0..-3]
        lowest_price = '$' + lp_d + '.' + lp_c
        lowest_price = (lowest_price ? lowest_price : '')
        return item_url, image_url, lowest_price
      end
    rescue
      return 'error', 'error', 'error'
    end
  end
  
end
