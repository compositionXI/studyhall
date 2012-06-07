class UploadsController < ApplicationController

  def index
   respond_to do |format|
      format.html # index.erb.html
    end
  end

  def create
    Rails.logger.info(params[])
    notes_array = []
    files_iter = 0
    params[:files].each do |file|
      is = files_iter.to_s
      file.content_type == "application/pdf" ? doc_pres = true : doc_pres = false
      if params[:share]
        params[:share][is].nil? ? caring = false : caring = true
      else
        caring = "0"
      end
      #dubs check - first should be ok and speeds up check (maybe?), but double here in case of 1337 h4x0rz
      if params[:ok_doc][is] == "1" && (file.content_type == "application/pdf" || file.content_type == "text/plain" || file.content_type == "application/vnd.oasis.opendocument.text" || file.content_type == "application/vnd.openxmlformats-officedocument.wordprocessingml.document" || file.content_type == "application/msword")
        @note = current_user.notes.new(
          :upload => "true",
          :content => "",
          :doc => file,
          :doc_type => params[:doc_type][is],
          :doc_preserved => doc_pres,
          :share_choice => caring
          )
        @note.update_attributes(:name => file.original_filename.split('.').first) if doc_pres
        @note = UploadUtils::upload(@note) if !doc_pres
        notes_array << @note.save
      end
      files_iter += 1
    end
    render :text => "AJAX Complete"
  end
  
end
