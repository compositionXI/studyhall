class BroadcastController < ApplicationController

  def index
    @broadcasts = current_user.current_broadcasts
    @link_id = "notifications_link_id"
    respond_to do |format|
      format.js
      format.json {render @broadcasts}
    end
  end

end
