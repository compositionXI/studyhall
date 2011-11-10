class MessagesController < ApplicationController

  layout "full_width"

  before_filter :require_user
  before_filter :find_sender, only: [:new, :create]
  before_filter :find_receiver, only: [:new]
  before_filter :set_action_bar
  
  def index
    case params[:mailbox]
    when "inbox"
      @messages = current_user.all_messages({:deleted => false})
      @inbox = true
    when "archive"
      @messages = current_user.all_messages({:deleted => true})
    else
      raise ActiveRecord::RecordNotFound.new("Could not find mailbox: #{params[:mailbox]}")
    end
    if request.xhr?
      @messages = filter_with(params[:message]) if params[:message]
      render partial: "messages/message", collection: @messages
    end
  end

  def new
    @message = current_user.sent_messages.new(:subject => prepared_subject(params[:subject]), :parent_id => params[:parent_id])
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
      save_attachments(@receiver, @sender)
      @message = current_user.sent_messages.new(:subject => prepared_subject(params[:message][:subject]), :parent_id => params[:message][:parent_id])
    end
  end

  def update
    @message = (params[:message_type] == "Message") ? Message.find(params[:id]) : MessageCopy.find(params[:id])
    @message.update_attributes(params[:message])
    Notifier.report_message(current_user, @message).deliver if params[:message][:abuse]
    Notifier.report_message(current_user, @message).deliver if params[:message][:spam]
    render partial: "messages/message", :locals => {message: @message} unless @message.spam? || @message.abuse? || params[:message][:deleted]
  end
  
  def update_multiple
    if params[:message_copies]
      MessageCopy.update(params[:message_copies].keys, params[:message_copies].values).reject { |p| p.errors.empty? }
    elsif params[:messages]
      Message.update(params[:messages].keys, params[:messages].values).reject { |p| p.errors.empty? }
    end
    if params[:inbox] == "true"
      @messages = current_user.all_messages({:deleted => false})
    else
      @messages = current_user.all_messages({:deleted => true})
    end
    render partial: "messages/message", collection: @messages
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

  def prepared_subject(subject)
    if subject.nil?
      ""
    elsif subject.index("Re:") == 0
      "#{subject}"
    else
      "Re: #{subject}"
    end
  end

  def find_sender
    @sender = current_user
  end

  def find_receiver
    @receiver = User.where(:id => params[:user_id]).first
  end
  
  def filter_with(message_attributes)
    message_attributes.delete :opened if message_attributes[:opened] == "all"
    current_user.all_messages(message_attributes)
  end
  
  def save_attachments(receiver, sender)
    receiver.each_with_index do |r, index|
      @message_copy = MessageCopy.find(sender.sent_messages[index])
      @message_copy.update_attributes(params[:message])
      @message = Message.find(r.inbox.first.id)
      @message.update_attributes(params[:message])
    end
  end
end
