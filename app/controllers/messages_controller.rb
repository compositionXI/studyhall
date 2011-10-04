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
      raise RecordNotFound.new("Could not find mailbox: #{params[:mailbox]}")
    end
  end

  def new
    @message = current_user.sent_messages.new(:subject => prepared_subject, :parent_id => params[:parent_id])
    respond_to do |format|
      format.html
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
  end

  def update
    @message = HasMailbox::Models::Message.find(params[:id])
    @message.undelete if params[:delete] == false
    render "destroy"
  end

  def destroy
    @message = HasMailbox::Models::Message.find(params[:id])
    @message.delete
  end

  protected

  def prepared_subject
    params[:subject].blank? ? "" : "Re: #{params[:subject]}"
  end

  def find_sender
    @sender = current_user
  end

  def find_receiver
    @receiver = User.where(:id => params[:user_id]).first
  end
end
