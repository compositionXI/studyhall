class SessionFile < ActiveRecord::Base

  belongs_to :study_session
  has_attached_file :upload, 
                    :storage => :s3, 
                    :s3_credentials => "#{Rails.root}/config/s3.yml",
                    :path => ":attachment/:id/:basename.:extension",
                    :bucket => "studyhall#{Rails.env}"

  after_create :prepare_embed!

  attr_accessor :session_identifier

  def embeddable?
    upload_uuid && short_id && session_identifier
  end

  def embed_url
    return nil if session_identifier.blank?
    "http://crocodoc.com/view/?sessionId=#{session_identifier}&embedded=true"
  end

  def prepare_embed!
    retrieve_upload_uuid
    save!
  end

  def already_uploaded?
    embeddable?
  end

  def retrieve_upload_uuid
    return upload_uuid if upload_uuid.present?
    begin
      response = Crocodoc.upload(upload.url)
      Rails.logger.info("Retrieved UUID: #{response[:uuid]}")
      self.upload_uuid = response[:uuid]
      self.short_id = response[:shortId]
    rescue => e
      raise e
      self.errors << "Unable to retrieve UUID"
    end
  end

  def retrieve_session_identifier(user)
    return session_identifier if session_identifier.present?
    begin
      response = Crocodoc.get_session(upload_uuid, :name => user.name, :private => true, :admin => study_session.user == user)
      Rails.logger.info("Retrieved session id: #{response[:sessionId]}")
      self.session_identifier = response[:sessionId]
    rescue => e
      self.errors << "Could not retrieve session identifier"
    end
    return self
  end

  def name
    return upload.file_name if upload.present?
  end

end
