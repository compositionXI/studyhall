class Whiteboard < ActiveRecord::Base

  belongs_to :study_session
  has_attached_file :upload, 
                    :storage => :s3, 
                    :s3_credentials => "#{Rails.root}/config/s3.yml",
                    :path => ":attachment/:id/:basename.:extension",
                    :bucket => 'shpoc'

  def embeddable?
    upload_uuid && short_id
  end

  def prepare_embed!
    retrieve_upload_uuid
    save!
  end

  def retrieve_upload_uuid
    return upload_uuid if upload_uuid.present?
    begin
      response = Crocodoc.upload(upload.url)
      Rails.logger.info("Retrieved UUID: #{response[:uuid]}")
      self.upload_uuid = response[:uuid]
      self.short_id = response[:shortId]
    rescue => e
      self.errors.on(:base, "Unable to retrieve UUID")
      raise e
    end
  end

  def retrieve_session_identifier
    return session_identifier if session_identifier.present?
    begin
      response = Crocodoc.get_session(upload_uuid)
      Rails.logger.info("Retrieved session id: #{response[:sessionId]}")
      puts identifier
      self.session_identifier = response[:sessionId]
    rescue => e
      self.errors << "Could not retrieve session identifier"
    end
  end

  def name
    return upload.file_name if upload.present?
  end

end
