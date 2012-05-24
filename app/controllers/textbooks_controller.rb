class TextbooksController < ApplicationController

  def show
    course = Course.where(:department => params[:dept_name], :number => params[:number]).first
    textbook = Textbook.where(:course_id => course.id).first
    @textbook = textbook.nil? ? Textbook.new : textbook
    @textbook.save
    if(@textbook.textbook_html.nil?)
      books_html = Textbook.get_isbn(current_user, params[:dept_name], params[:number])
      @textbook.update_attributes(:course_id => course.id, :offering_id => course.offerings.first.id, :textbook_html => books_html)
    end
    #double check in case error checking in model missed something
    xhr_out = @textbook.textbook_html.nil? ? 'no_text' : @textbook.textbook_html
    render :text => xhr_out
  end
  
end
