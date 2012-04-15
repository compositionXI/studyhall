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
    logger.info("1IZZY: #{params[:sharing][:group_ids]}!")
    logger.info("2IZZY: #{@sharing.group_ids}")
    @success = @sharing.valid?;               Rails.logger.debug "********** Did we create a sharing? #{@success}"
    @sharing.objects.each(&:share!);          Rails.logger.debug "********** Done Sharing Objects"
    @sharing.objects.each do |o|
      o.groups << @sharing.groups
    end
    @object_type = (@sharing.objects.first.class.to_s == "StudySession") ? "StudyHall" : @sharing.objects.first.class.to_s;   Rails.logger.debug "********** Sending Notifications: "
    send_notifications if @success;           Rails.logger.debug "********** Generating Activity Objects"
    generate_activity(@sharing);              Rails.logger.debug "********** Done"
    generate_post(@sharing)
  end

  private
    def generate_post(sharing)
      sharing.objects.each do |object|
        object.course.offerings.each do |offering|
          if object.is_a? Note
            offering.posts.create(:user => current_user, :note => object, :text => sharing.message)
          elsif object.is_a? Notebook
            offering.posts.create(:user => current_user, :notebook => object, :text => sharing.message)
          end
        end if %w(Note Notebook).include?(object.class.to_s) && object.course
      end
    end

    def generate_activity(sharing)
      sharing.users.each do |user|
        sharing.objects.each do |obj|
          message_body = ActivityRenderer.new.generate_message(user, 'sharing', :object => obj, :user => current_user)
          ActivityMessage.create(:user => user, :body => message_body, :activist => current_user)
        end
      end
    end
    
    def send_message
      subject = "#{current_user.name.titleize} wants to share something with you on Studyhall.com"
      if @object_type == "Notebook" || @object_type == "Note"
        default_message = "Click on a #{@object_type} to view it."
      elsif @object_type == "StudyHall"
        default_message = "Click on a Studyhall link below to start studying!"
      end
      personal_message = (@sharing.message == "") ? nil : "<p>#{current_user.first_name.capitalize} said, \"#{@sharing.message}\"</p>"
      body = "<p>#{current_user.name.titleize} shared something with you!</p><p>#{default_message}</p><ul style='margin:20px 0;'>#{@sharing.objects.map{|obj| "<li style='margin-top: 10px;'><a href=\"#{url_for(obj)}\">#{obj.name}</a></li>" }.join()}</ul>#{personal_message}"
      current_user.send_message?(subject, body, *@sharing.users)
    end

    def send_notifications
      Rails.logger.debug "********** Invoking Notifier"
      Notifier.sharing(@sharing, @object_type, current_user).deliver
      Rails.logger.debug "********** Calling send_message"
      send_message
    end
end
