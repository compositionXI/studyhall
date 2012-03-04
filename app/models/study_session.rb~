require 'gcal4ruby'
require 'time'

class StudySession < ActiveRecord::Base

  include Ownable
  BEGINNING_OF_TIME = Time.at(0).strftime('%Y-%m-%d')
  TODAY = Time.new.strftime('%Y-%m-%d')

  belongs_to :user
  belongs_to :offering
  has_many :session_files
  has_many :session_invites
  has_many :calendars
  has_many :users, :through => :session_invites
  has_many :posts, :dependent => :destroy

  scope :as_host, lambda {|user| where(:user_id => user.id) }
  scope :as_guest, lambda {|user| user.study_sessions.where(StudySession.arel_table[:user_id].does_not_match(user.id)) }
  scope :for_user, lambda {|user| where(:id => (select(:id).where(:user_id => user.id).map(&:id) + user.session_invites.map(&:study_session_id))) }
  scope :with_users, lambda {|user_ids| where(:id => SessionInvite.where(:user_id => user_ids).select(:study_session_id).all.map(&:study_session_id)) }
  scope :in_range, lambda {|start_date, end_date|
    start_date = start_date.blank? ? BEGINNING_OF_TIME : start_date
    end_date = end_date.blank? ? TODAY : end_date
    where("created_at >= ? and created_at <= ?", start_date, (Time.parse(end_date) + 1.day).strftime('%Y-%m-%d'))
  }

  before_create :init_opentok
  after_save :upload_session_files
  after_create :associate_users

  accepts_nested_attributes_for :session_files

  attr_accessor :remote_addr, :buddy_ids

  def joinable_by?(user)
    users.include?(user)
  end

  def init_opentok
    begin
      opentok_session = OPENTOK.create_session(remote_addr)
      self.tokbox_session_id = opentok_session.session_id
    rescue SocketError => e
      Rails.logger.error(e.message)
    end
  end

  def generate_token(user)
    return 'devtoken' if Rails.env.development?
    OPENTOK.generate_token :settion_id => tokbox_session_id, :connection_data => "name=#{user.name}"
  end

  def upload_session_files
    session_files.each do |sf|
      sf.prepare_embed! unless sf.already_uploaded?
    end
  end

  def prepare_session(user)
    return nil unless session_files.any?
    session_files.last.retrieve_session_identifier(user)
  end

  def buddy_ids
    users.map(&:id)
  end

  def associate_users
    @buddy_ids ||= []
    @buddy_ids << user.id unless user.nil?
    @buddy_ids.uniq.reject(&:blank?).each do |buddy_id|
      invitee = User.find(buddy_id)
      self.users << invitee
      send_invite(invitee) unless invitee == user
    end
  end
  
  def created_at_formatted(format="%d/%m/%Y")
    self.created_at.strftime(format)
  end
  
  def presentation
    name.blank? ? created_at_formatted : name
  end
  
  def send_invite(invitee)
    Notifier.study_session_invite(user, invitee, self).deliver if invitee.notify_on_invite
  end
  
  def self.filter(filter, user)
    study_sessions = user.study_sessions
    if filter[:study_session]
      if filter[:study_session][:name]
        study_sessions = study_sessions.where(["name like ?", "%#{filter[:study_session][:name]}%"])
      end
      if filter[:study_session][:offering_id]
        study_sessions = study_sessions.where("offering_id = ?", filter[:study_session][:offering_id])
      end
    end
    if filter[:user_ids]
      users = User.where(:id => filter[:user_ids]).all
      study_sessions = study_sessions.with_users(filter[:user_ids])
    end
    if filter[:start_date] || filter[:end_date]
      study_sessions = study_sessions.in_range(filter[:start_date], filter[:end_date])
    end
    study_sessions
  end
  
  def self.offerings_for(user)
    user.study_sessions.collect{|s| s.offering}.uniq.compact
  end

  def addtocalendar
=begin
    begin
      invitearray = []
      @buddy_ids.uniq.reject(&:blank?).each do |buddy_id|
        calinvite = User.find(buddy_id)
        invitearray << {:name => calinvite.first_name, :email => calinvite.email}
      end
      service = GCal4Ruby::Service.new
      service.authenticate(user.email, self.gmail_password)
      cal = GCal4Ruby::Calendar.find(service, {:title => 'studyhall'})
      if cal.empty?
	 newCal = GCal4Ruby::Calendar.new(service, {:title => 'studyhall', :summary => 'studyhall'})
	 newCal.save
	 event = GCal4Ruby::Event.new(service, {:calendar => newCal, :title => self.name, :start_time => self.time_start, :end_time => self.time_end, :attendees => invitearray})
         event.save
      else
         event = GCal4Ruby::Event.new(service, {:calendar => cal.first, :title => self.name, :start_time => self.time_start, :end_time => self.time_end, :attendees => invitearray})
         event.reminder = [{:minutes => 2000, :method => "email"}]
	 event.save
      end
    rescue GData4Ruby::HTTPRequestFailed => e
      Rails.logger.info("Failed to authenticate #{gmail_address} with Gmail")
      false
    end
=end
  end

  def calendar?
    self.calendar
  end

end
