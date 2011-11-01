class MessagesController < ApplicationController

  layout "full_width"

  before_filter :require_user
  before_filter :find_sender, only: [:new, :create]
  before_filter :find_receiver, only: [:new]
  before_filter :set_action_bar
  
  def index
    case params[:mailbox]
    when "inbox"
      @messages = current_user.inbox
      @inbox = true
    when "archive"
      @messages = current_user.trash
    else
      raise ActiveRecord::RecordNotFound.new("Could not find mailbox: #{params[:mailbox]}")
    end
    if request.xhr?
      params[:message].delete :opened if params[:message][:opened] == "all"
      if params[:message][:deleted]
        results_from_trash = current_user.inbox.where(params[:message])
        results_from_inbox = current_user.trash.where(params[:message])
        @messages = results_from_trash + results_from_inbox
      else
        @messages = current_user.inbox.where(params[:message])
      end
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
    @receiver = []
    if params[:user_id].is_a?(Array)
      params[:user_id].each do |i|
        @receiver << User.find(i)
      end
    else
      @receiver << User.find(params[:user_id])
    end
    subject = params[:message].try(:[], :subject)
    body = params[:message].try(:[], :body)
    @success = @sender.send_message?(subject, body, *@receiver)
    if @success
      @receiver.each_with_index do |r, index|
        @message_copy = MessageCopy.find(@sender.sent_messages[index])
        @message_copy.update_attributes(params[:message])
        @message = Message.find(r.inbox.first.id)
        @message.update_attributes(params[:message])
      end
    end
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
