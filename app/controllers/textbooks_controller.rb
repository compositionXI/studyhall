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
    render :text => @textbook.textbook_html
  end
  
end
