class StudySession < ActiveRecord::Base

  include Ownable

  belongs_to :user
  belongs_to :offering
  has_many :session_files
  has_many :session_invites
  has_many :users, :through => :session_invites
  has_many :posts, :dependent => :destroy

  scope :as_host, lambda {|user| where(:user_id => user.id) }
  scope :as_guest, lambda {|user| user.study_sessions.where(StudySession.arel_table[:user_id].does_not_match(user.id)) }
  scope :for_user, lambda {|user| where(:id => (select(:id).where(:user_id => user.id).map(&:id) + user.session_invites.map(&:study_session_id))) }
  scope :with_users, lambda {|user_ids| where(:id => SessionInvite.where(:user_id => user_ids).select(:study_session_id).all.map(&:study_session_id)) }
  scope :shared, where(:shared => true)

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
    @buddy_ids.uniq.each do |buddy_id|
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
end
