class MessagesController < ApplicationController
  before_filter :require_user

  before_filter :find_sender, only: [:new, :create]
  before_filter :find_receiver, only: [:new, :create]
  
  def index
    @messages = current_user.inbox
  end

  def new
    @message = current_user.sent_messages.new
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
    if @sender.send_message?(subject, body, @receiver)
      redirect_to messages_path, notice: 'Message was successfully sent.'
    else
      render action: 'new'
    end
  end

  protected
  def find_sender
    @sender = current_user
  end

  def find_receiver
    @receiver = User.find(params[:user_id])
  end
end
