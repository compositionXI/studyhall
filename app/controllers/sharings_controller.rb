class SharingsController < ApplicationController
  
  before_filter :require_user

  def new
    @sharing = Sharing.new
    @position = params[:position] ||= "below-right"
    @object_id = params[:object_id]
    @object_to_share = params[:object_to_share]
  end

  def create
    @sharing = Sharing.new(params[:sharing])
    @success = @sharing.valid?
    @sharing.objects.each(&:share!)
    @object_type = (@sharing.objects.first.class.to_s == "StudySession") ? "StudyHall" : @sharing.objects.first.class.to_s
    Notifier.sharing(@sharing, @object_type, current_user).deliver if @success
    send_message(@sharing, @object_type)
    generate_activity(@sharing)
  end

  private

    def send_message(sharing, object_type)
      subject = "#{current_user.name} wants to share something with you on Studyhall.com"
      if object_type == "Notebook" || object_type == "Note"
        default_message = "Click on a #{object_type} to view it."
      elsif object_type == "StudyHall"
        default_message = "Click on a Studyhall link below to start studying!"
      end
      personal_message = (sharing.message == "") ? nil : "<p>#{current_user.first_name} said, \"#{sharing.message}\"</p>"
      body = "<p>#{current_user.name} shared a #{object_type} with you!</p>#{personal_message}<p>#{default_message}</p><ul>#{sharing.objects.map{|obj| "<li><a href=\"#{url_for(obj)}\">#{obj.name}</a></li>" }.join()}</ul>"
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
