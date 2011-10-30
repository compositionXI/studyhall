class ActivityRenderer < AbstractController::Base
  include AbstractController::Rendering
  include AbstractController::Layouts
  include AbstractController::Helpers
  include AbstractController::Translation
  include AbstractController::AssetPaths
  include Rails.application.routes.url_helpers
  include ActionView::Helpers::AssetTagHelper

  self.view_paths = 'app/views'
  self.assets_dir = '/app/public'

  def generate_message(user, message_type, options={})
    render_to_string partial: message_type, locals: options.merge(owner: user)
  end
end
