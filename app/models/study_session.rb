class StudySession < ActiveRecord::Base

  belongs_to :user
  has_many :session_files
  has_many :session_invites
  has_many :users, :through => :session_invites

  scope :as_host, lambda {|user| where(:user_id => user.id) }
  scope :as_guest, lambda {|user| user.study_sessions.where(StudySession.arel_table[:user_id].does_not_match(user.id)) }
  scope :for_user, lambda {|user| where(:id => (select(:id).where(:user_id => user.id).map(&:id) + user.session_invites.map(&:study_session_id))) }

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
      opentok = OpenTok::OpenTokSDK.new(APP_CONFIG["opentok"]["key"], APP_CONFIG["opentok"]["secret"])
      opentok_session = opentok.create_session(remote_addr)
      self.tokbox_session_id = opentok_session.session_id
    rescue SocketError => e
      Rails.logger.error(e.message)
    end
  end

  def upload_session_files
    session_files.each do |sf|
      sf.prepare_embed! unless sf.already_uploaded?
    end
  end

  def associate_users
    buddy_ids ||= []
    buddy_ids << user.id unless user.nil?
    buddy_ids.uniq.each do |buddy_id|
      self.users << User.find(buddy_id)
    end
  end
    
end
