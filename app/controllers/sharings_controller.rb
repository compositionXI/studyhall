class SharingsController < ApplicationController
  
  before_filter :require_user

  def new
    @sharing = Sharing.new
    @position = params[:position] ||= "below-right"
    @object_id = params[:object_id]
  end

  def create
    @sharing = Sharing.new(params[:sharing])
    @success = @sharing.valid?
    @sharing.objects.each(&:share!)
    Notifier.sharing(@sharing, current_user).deliver if @success
    send_message(@sharing)
    generate_activity(@sharing)
  end

  private

    def send_message(sharing)
      subject = "#{current_user.name} wants to share something with you"
      body = "<p>#{current_user.name} wants to share something with you.</p><p>\"#{sharing.message}\"</p><ul>#{sharing.objects.map{|obj| "<li><a href=\"#{url_for(obj)}\">#{obj.name}</a></li>" }.join()}</ul>"
      current_user.send_message?(subject, body, *sharing.users)
    end

    def generate_activity(sharing)
      sharing.users.each do |user|
        sharing.objects.each do |obj|
          message_body = ActivityRenderer.new.generate_message(user, 'sharing', :object => obj, :user => current_user)
          ActivityMessage.create(:user => user, :body => message_body)
        end
      end
    end

end
