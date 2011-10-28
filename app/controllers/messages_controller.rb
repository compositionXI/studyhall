class MessagesController < ApplicationController

  layout "full_width"

  before_filter :require_user
  before_filter :find_sender, only: [:new, :create]
  before_filter :find_receiver, only: [:new, :create]
  before_filter :set_action_bar
  
  def index
    case params[:mailbox]
    when "inbox"
      @messages = current_user.inbox
    when "archive"
      @messages = current_user.trash
    else
      raise ActiveRecord::RecordNotFound.new("Could not find mailbox: #{params[:mailbox]}")
    end
    if request.xhr?
      params[:message].delete :opened if params[:message][:opened] == "all"
      @messages = current_user.inbox.where(params[:message])
      render partial: "messages/message", collection: @messages
    end
  end

  def new
    @message = current_user.sent_messages.new(:subject => prepared_subject, :parent_id => params[:parent_id])
    respond_to do |format|
      format.html { render :partial => "reply_form" }
      format.js
    end
  end

  def show
    @message = HasMailbox::Models::Message.find(params[:id])
    if @message.from != current_user && @message.to != current_user
      @message = nil
    end
    @message.try(:mark_as_read)
  end

  def create
    subject = params[:message].try(:[], :subject)
    body = params[:message].try(:[], :body)
    @success = @sender.send_message?(subject, body, @receiver)
    @message_copy = MessageCopy.find(@sender.sent_messages.first.id)
    @message_copy.update_attributes(params[:message])
    @message = Message.find(@receiver.inbox.first.id)
    @message.update_attributes(params[:message])
    @success
  end

  def update
    @message = HasMailbox::Models::Message.find(params[:id])
    if params[:deleted] == "false"
      @message.undelete 
      render "destroy"
    else
      @message.update_attributes params[:message]
      render partial: "messages/message", :locals => {message: @message}
    end
  end

  def destroy
    @message = HasMailbox::Models::Message.find(params[:id])
    @message.delete
  end

  def filter
    @modal_link_id = params[:link_id]
    respond_to do |format|
      format.js
    end
  end

  protected

  def prepared_subject
    if params[:subject].nil?
      ""
    elsif params[:subject].index("Re:") == 0
      "#{params[:subject]}"
    else
      "Re: #{params[:subject]}"
    end
  end

  def find_sender
    @sender = current_user
  end

  def find_receiver
    @receiver = User.where(:id => params[:user_id]).first
  end
end
