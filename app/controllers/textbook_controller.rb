class TextbooksController < ApplicationController

  def show
    books_html = Textbook.get_isbn(current_user, params[:dept_name], params[:number])
    render :text => books_html
  end
  
end
