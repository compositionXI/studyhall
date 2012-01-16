#         ooooooooo.              o8o  oooo                 .o.             .o8                     o8o
#         `888   `Y88.            `"'  `888                .888.           "888                     `"'
#          888   .d88'  .oooo.   oooo   888   .oooo.o     .8"888.      .oooo888  ooo. .oo.  .oo.   oooo  ooo. .oo.
#          888ooo88P'  `P  )88b  `888   888  d88(  "8    .8' `888.    d88' `888  `888P"Y88bP"Y88b  `888  `888P"Y88b
#          888`88b.     .oP"888   888   888  `"Y88b.    .88ooo8888.   888   888   888   888   888   888   888   888
#          888  `88b.  d8(  888   888   888  o.  )88b  .8'     `888.  888   888   888   888   888   888   888   888
#         o888o  o888o `Y888""8o o888o o888o 8""888P' o88o     o8888o `Y8bod88P" o888o o888o o888o o888o o888o o888o

# RailsAdmin config file. Generated on November 02, 2011 09:43
# See github.com/sferik/rails_admin for more informations

if File.basename($0) == 'rake'
  puts "Skipping RailsAdmin.config..."
else
  RailsAdmin.config do |config|
    config.audit_with :history, User

    config.current_user_method { current_user } # auto-generated
  
    # Set the admin name here (optional second array element will appear in a beautiful RailsAdmin red ©)
    config.main_app_name = ['Studyhall', 'Admin']
    # or for a dynamic name:
    # config.main_app_name = Proc.new { |controller| [Rails.application.engine_name.titleize, controller.params['action'].titleize] }

    #  ==> Authentication (before_filter)
    # This is run inside the controller instance so you can setup any authentication you need to.
    # By default, the authentication will run via warden if available.
    # and will run on the default user scope.
    # If you use devise, this will authenticate the same as authenticate_user!
    # Example Devise admin
     config.authenticate_with do
       require_admin
     end
  # Example Custom Warden
  # RailsAdmin.config do |config|
  #   config.authenticate_with do
  #     warden.authenticate! :scope => :paranoid
  #   end
  # end

  #  ==> Authorization
  # Use cancan https://github.com/ryanb/cancan for authorization:
  # config.authorize_with :cancan

  # Or use simple custom authorization rule:
  # config.authorize_with do
  #   redirect_to root_path unless warden.user.is_admin?
  # end

  # Use a specific role for ActiveModel's :attr_acessible :attr_protected
  # Default is :default
  # current_user is accessible in the block if you want to make it user specific.
  # config.attr_accessible_role { :default }

  #  ==> Global show view settings
  # Display empty fields in show views
  # config.compact_show_view = false

  #  ==> Global list view settings
  # Number of default rows per-page:
  # config.default_items_per_page = 50

  #  ==> Included models
  # Add all excluded models here:
  # config.excluded_models << [ActivityMessage, Authentication, Comment, Contact, Course, CourseOfferingImport, Enrollment, Extracurricular, Following, Instructor, Message, MessageCopy, Note, Notebook, Offering, Post, Role, Room, School, SessionFile, SessionInvite, StaticPage, StudySession, User, Vote, Whiteboard]

  # Add models here if you want to go 'whitelist mode':
  config.included_models = [ActivityMessage, Comment, Contact, Course, Enrollment, Extracurricular, Following, Instructor, Note, Notebook, Message, MessageCopy, Offering, Post, School, SessionFile, SessionInvite, StaticPage, StudySession, User, Vote]

  # Application wide tried label methods for models' instances
  # config.label_methods << [:description] # Default is [:name, :title]

  #  ==> Global models configuration
  # config.models do
  #   # Configuration here will affect all included models in all scopes, handle with care!
  #
  #   list do
  #     # Configuration here will affect all included models in list sections (same for show, export, edit, update, create)
  #
  #     fields :name, :other_name do
  #       # Configuration here will affect all fields named [:name, :other_name], in the list section, for all included models
  #     end
  #
  #     fields_of_type :date do
  #       # Configuration here will affect all date fields, in the list section, for all included models. See README for a comprehensive type list.
  #     end
  #   end
  # end
  #
  #  ==> Model specific configuration
  # Keep in mind that *all* configuration blocks are optional.
  # RailsAdmin will try his best to provide the best defaults for each section, for each field!
  # Try to override as few things as possible, in the most generic way. Try to avoid setting labels for models and attributes, use ActiveRecord I18n API instead.
  # Less code is better code!
  # config.model MyModel do
  #   # Here goes your cross-section field configuration for ModelName.
  #   object_label_method :name     # Name of the method called for pretty printing an *instance* of ModelName
  #   label 'My model'              # Name of ModelName (smartly defaults to ActiveRecord's I18n API)
  #   label_plural 'My models'      # Same, plural
  #   weight -1                     # Navigation priority. Bigger is higher.
  #   parent OtherModel             # Set parent model for navigation. MyModel will be nested below. OtherModel will be on first position of the dropdown
  #   navigation_label              # Sets dropdown entry's name in navigation. Only for parents!
  #   # Section specific configuration:
  #   list do
  #     filters [:id, :name]  # Array of field names which filters should be shown by default in the table header
  #     items_per_page 100    # Override default_items_per_page
  #     sort_by :id           # Sort column (default is primary key)
  #     sort_reverse true     # Sort direction (default is true for primary key, last created first)
  #     # Here goes the fields configuration for the list view
  #   end
  #   show do
  #     # Here goes the fields configuration for the show view
  #   end
  #   export do
  #     # Here goes the fields configuration for the export view (CSV, yaml, XML)
  #   end
  #   edit do
  #     # Here goes the fields configuration for the edit view (for create and update view)
  #   end
  #   create do
  #     # Here goes the fields configuration for the create view, overriding edit section settings
  #   end
  #   update do
  #     # Here goes the fields configuration for the update view, overriding edit section settings
  #   end
  # end

# fields configuration is described in the Readme, if you have other question, ask us on the mailing-list!

#  ==> Your models configuration, to help you get started!

# All fields marked as 'hidden' won't be shown anywhere in the rails_admin unless you mark them as visible.
# There can be different reasons for that:
#  - belongs_to _id and _type (polymorphic) columns are hidden in favor of their associations
#  - associations are hidden if they have no matchable model found (model not included or non-existant)
#  - they are part of a bigger plan in a plugin (Devise/Paperclip) and hidden by contract
# Some fields may be hidden depending on the section, if they aren't deemed suitable for display or edition on that section
#  - non-editable columns (:id, :created_at, ..) in edit sections
#  - has_many/has_one associations in list section (hidden by default for performance reasons)
# Fields may also be marked as read_only (and thus not editable) if they are not mass-assignable by current_user

  # config.model ActivityMessage do
  #   # Found associations:
  #   field :user, :belongs_to_association
  #   # Found columns:
  #   field :id, :integer
  #   field :user_id, :integer        # Hidden
  #   field :body, :text
  #   field :created_at, :datetime
  #   field :updated_at, :datetime
  #   # Sections:
  #   list do; end
  #   export do; end
  #   show do; end
  #   edit do; end
  #   create do; end
  #   update do; end
  #  end

# All fields marked as 'hidden' won't be shown anywhere in the rails_admin unless you mark them as visible.
# There can be different reasons for that:
#  - belongs_to _id and _type (polymorphic) columns are hidden in favor of their associations
#  - associations are hidden if they have no matchable model found (model not included or non-existant)
#  - they are part of a bigger plan in a plugin (Devise/Paperclip) and hidden by contract
# Some fields may be hidden depending on the section, if they aren't deemed suitable for display or edition on that section
#  - non-editable columns (:id, :created_at, ..) in edit sections
#  - has_many/has_one associations in list section (hidden by default for performance reasons)
# Fields may also be marked as read_only (and thus not editable) if they are not mass-assignable by current_user

  # config.model Authentication do
  #   # Found associations:
  #   field :user, :belongs_to_association
  #   # Found columns:
  #   field :id, :integer
  #   field :provider, :string
  #   field :uid, :string
  #   field :user_id, :integer        # Hidden
  #   field :created_at, :datetime
  #   field :updated_at, :datetime
  #   # Sections:
  #   list do; end
  #   export do; end
  #   show do; end
  #   edit do; end
  #   create do; end
  #   update do; end
  #  end

# All fields marked as 'hidden' won't be shown anywhere in the rails_admin unless you mark them as visible.
# There can be different reasons for that:
#  - belongs_to _id and _type (polymorphic) columns are hidden in favor of their associations
#  - associations are hidden if they have no matchable model found (model not included or non-existant)
#  - they are part of a bigger plan in a plugin (Devise/Paperclip) and hidden by contract
# Some fields may be hidden depending on the section, if they aren't deemed suitable for display or edition on that section
#  - non-editable columns (:id, :created_at, ..) in edit sections
#  - has_many/has_one associations in list section (hidden by default for performance reasons)
# Fields may also be marked as read_only (and thus not editable) if they are not mass-assignable by current_user

  # config.model Comment do
  #   # Found associations:
  #   field :offering, :belongs_to_association
  #   field :user, :belongs_to_association
  #   field :notebook, :belongs_to_association
  #   field :study_session, :belongs_to_association
  #   field :parent, :belongs_to_association
  #   field :comments, :has_many_association
  #   # Found columns:
  #   field :id, :integer
  #   field :user_id, :integer        # Hidden
  #   field :offering_id, :integer        # Hidden
  #   field :text, :text
  #   field :notebook_id, :integer        # Hidden
  #   field :study_session_id, :integer        # Hidden
  #   field :upload_file_name, :string
  #   field :upload_content_type, :string
  #   field :upload_file_size, :string
  #   field :upload_updated_at, :string
  #   field :created_at, :datetime
  #   field :updated_at, :datetime
  #   field :parent_id, :integer        # Hidden
  #   field :reported, :boolean
  #   # Sections:
  #   list do; end
  #   export do; end
  #   show do; end
  #   edit do; end
  #   create do; end
  #   update do; end
  #  end

# All fields marked as 'hidden' won't be shown anywhere in the rails_admin unless you mark them as visible.
# There can be different reasons for that:
#  - belongs_to _id and _type (polymorphic) columns are hidden in favor of their associations
#  - associations are hidden if they have no matchable model found (model not included or non-existant)
#  - they are part of a bigger plan in a plugin (Devise/Paperclip) and hidden by contract
# Some fields may be hidden depending on the section, if they aren't deemed suitable for display or edition on that section
#  - non-editable columns (:id, :created_at, ..) in edit sections
#  - has_many/has_one associations in list section (hidden by default for performance reasons)
# Fields may also be marked as read_only (and thus not editable) if they are not mass-assignable by current_user

  # config.model Contact do
  #   # Found associations:
  #   # Found columns:
  #   field :id, :integer
  #   field :name, :string
  #   field :email, :string
  #   field :company_name, :string
  #   field :phone, :string
  #   field :message, :text
  #   field :created_at, :datetime
  #   field :updated_at, :datetime
  #   # Sections:
  #   list do; end
  #   export do; end
  #   show do; end
  #   edit do; end
  #   create do; end
  #   update do; end
  #  end

# All fields marked as 'hidden' won't be shown anywhere in the rails_admin unless you mark them as visible.
# There can be different reasons for that:
#  - belongs_to _id and _type (polymorphic) columns are hidden in favor of their associations
#  - associations are hidden if they have no matchable model found (model not included or non-existant)
#  - they are part of a bigger plan in a plugin (Devise/Paperclip) and hidden by contract
# Some fields may be hidden depending on the section, if they aren't deemed suitable for display or edition on that section
#  - non-editable columns (:id, :created_at, ..) in edit sections
#  - has_many/has_one associations in list section (hidden by default for performance reasons)
# Fields may also be marked as read_only (and thus not editable) if they are not mass-assignable by current_user

  # config.model Course do
  #   # Found associations:
  #   field :offerings, :has_many_association
  #   field :school, :belongs_to_association
  #   # Found columns:
  #   field :id, :integer
  #   field :number, :string
  #   field :title, :string
  #   field :school_id, :integer        # Hidden
  #   field :department, :string
  #   field :created_at, :datetime
  #   field :updated_at, :datetime
  #   # Sections:
  #   list do; end
  #   export do; end
  #   show do; end
  #   edit do; end
  #   create do; end
  #   update do; end
  #  end

# All fields marked as 'hidden' won't be shown anywhere in the rails_admin unless you mark them as visible.
# There can be different reasons for that:
#  - belongs_to _id and _type (polymorphic) columns are hidden in favor of their associations
#  - associations are hidden if they have no matchable model found (model not included or non-existant)
#  - they are part of a bigger plan in a plugin (Devise/Paperclip) and hidden by contract
# Some fields may be hidden depending on the section, if they aren't deemed suitable for display or edition on that section
#  - non-editable columns (:id, :created_at, ..) in edit sections
#  - has_many/has_one associations in list section (hidden by default for performance reasons)
# Fields may also be marked as read_only (and thus not editable) if they are not mass-assignable by current_user

  # config.model CourseOfferingImport do
  #   # Found associations:
  #   # Found columns:
  #   field :id, :integer
  #   field :course_offering_import_file_name, :string        # Hidden
  #   field :course_offering_import_content_type, :string        # Hidden
  #   field :course_offering_import_file_size, :string        # Hidden
  #   field :course_offering_import, :paperclip_file
  #   field :created_at, :datetime
  #   field :updated_at, :datetime
  #   # Sections:
  #   list do; end
  #   export do; end
  #   show do; end
  #   edit do; end
  #   create do; end
  #   update do; end
  #  end

# All fields marked as 'hidden' won't be shown anywhere in the rails_admin unless you mark them as visible.
# There can be different reasons for that:
#  - belongs_to _id and _type (polymorphic) columns are hidden in favor of their associations
#  - associations are hidden if they have no matchable model found (model not included or non-existant)
#  - they are part of a bigger plan in a plugin (Devise/Paperclip) and hidden by contract
# Some fields may be hidden depending on the section, if they aren't deemed suitable for display or edition on that section
#  - non-editable columns (:id, :created_at, ..) in edit sections
#  - has_many/has_one associations in list section (hidden by default for performance reasons)
# Fields may also be marked as read_only (and thus not editable) if they are not mass-assignable by current_user

  # config.model Enrollment do
  #   # Found associations:
  #   field :user, :belongs_to_association
  #   field :offering, :belongs_to_association
  #   # Found columns:
  #   field :id, :integer
  #   field :offering_id, :integer        # Hidden
  #   field :user_id, :integer        # Hidden
  #   field :created_at, :datetime
  #   field :updated_at, :datetime
  #   # Sections:
  #   list do; end
  #   export do; end
  #   show do; end
  #   edit do; end
  #   create do; end
  #   update do; end
  #  end

# All fields marked as 'hidden' won't be shown anywhere in the rails_admin unless you mark them as visible.
# There can be different reasons for that:
#  - belongs_to _id and _type (polymorphic) columns are hidden in favor of their associations
#  - associations are hidden if they have no matchable model found (model not included or non-existant)
#  - they are part of a bigger plan in a plugin (Devise/Paperclip) and hidden by contract
# Some fields may be hidden depending on the section, if they aren't deemed suitable for display or edition on that section
#  - non-editable columns (:id, :created_at, ..) in edit sections
#  - has_many/has_one associations in list section (hidden by default for performance reasons)
# Fields may also be marked as read_only (and thus not editable) if they are not mass-assignable by current_user

  # config.model Extracurricular do
  #   # Found associations:
  #   field :users, :has_and_belongs_to_many_association
  #   # Found columns:
  #   field :id, :integer
  #   field :name, :string
  #   field :type, :string
  #   field :created_at, :datetime
  #   field :updated_at, :datetime
  #   # Sections:
  #   list do; end
  #   export do; end
  #   show do; end
  #   edit do; end
  #   create do; end
  #   update do; end
  #  end

# All fields marked as 'hidden' won't be shown anywhere in the rails_admin unless you mark them as visible.
# There can be different reasons for that:
#  - belongs_to _id and _type (polymorphic) columns are hidden in favor of their associations
#  - associations are hidden if they have no matchable model found (model not included or non-existant)
#  - they are part of a bigger plan in a plugin (Devise/Paperclip) and hidden by contract
# Some fields may be hidden depending on the section, if they aren't deemed suitable for display or edition on that section
#  - non-editable columns (:id, :created_at, ..) in edit sections
#  - has_many/has_one associations in list section (hidden by default for performance reasons)
# Fields may also be marked as read_only (and thus not editable) if they are not mass-assignable by current_user

  # config.model Following do
  #   # Found associations:
  #   field :followed_user, :belongs_to_association
  #   field :user, :belongs_to_association
  #   # Found columns:
  #   field :id, :integer
  #   field :user_id, :integer        # Hidden
  #   field :followed_user_id, :integer        # Hidden
  #   field :created_at, :datetime
  #   field :updated_at, :datetime
  #   field :blocked, :boolean
  #   # Sections:
  #   list do; end
  #   export do; end
  #   show do; end
  #   edit do; end
  #   create do; end
  #   update do; end
  #  end

# All fields marked as 'hidden' won't be shown anywhere in the rails_admin unless you mark them as visible.
# There can be different reasons for that:
#  - belongs_to _id and _type (polymorphic) columns are hidden in favor of their associations
#  - associations are hidden if they have no matchable model found (model not included or non-existant)
#  - they are part of a bigger plan in a plugin (Devise/Paperclip) and hidden by contract
# Some fields may be hidden depending on the section, if they aren't deemed suitable for display or edition on that section
#  - non-editable columns (:id, :created_at, ..) in edit sections
#  - has_many/has_one associations in list section (hidden by default for performance reasons)
# Fields may also be marked as read_only (and thus not editable) if they are not mass-assignable by current_user

  # config.model Instructor do
  #   # Found associations:
  #   field :offerings, :has_many_association
  #   # Found columns:
  #   field :id, :integer
  #   field :first_name, :string
  #   field :last_name, :string
  #   field :title, :string
  #   field :created_at, :datetime
  #   field :updated_at, :datetime
  #   # Sections:
  #   list do; end
  #   export do; end
  #   show do; end
  #   edit do; end
  #   create do; end
  #   update do; end
  #  end

# All fields marked as 'hidden' won't be shown anywhere in the rails_admin unless you mark them as visible.
# There can be different reasons for that:
#  - belongs_to _id and _type (polymorphic) columns are hidden in favor of their associations
#  - associations are hidden if they have no matchable model found (model not included or non-existant)
#  - they are part of a bigger plan in a plugin (Devise/Paperclip) and hidden by contract
# Some fields may be hidden depending on the section, if they aren't deemed suitable for display or edition on that section
#  - non-editable columns (:id, :created_at, ..) in edit sections
#  - has_many/has_one associations in list section (hidden by default for performance reasons)
# Fields may also be marked as read_only (and thus not editable) if they are not mass-assignable by current_user

  # config.model Message do
  #   # Found associations:
  #   # Found columns:
  #   field :id, :integer
  #   field :received_messageable_id, :integer
  #   field :received_messageable_type, :string
  #   field :sender_id, :integer
  #   field :subject, :string
  #   field :body, :text
  #   field :opened, :boolean
  #   field :deleted, :boolean
  #   field :created_at, :datetime
  #   field :updated_at, :datetime
  #   field :parent_id, :integer
  #   field :attachment_file_name, :string        # Hidden
  #   field :attachment_content_type, :string        # Hidden
  #   field :attachment_file_size, :integer        # Hidden
  #   field :attachment_updated_at, :string        # Hidden
  #   field :attachment, :paperclip_file
  #   # Sections:
  #   list do; end
  #   export do; end
  #   show do; end
  #   edit do; end
  #   create do; end
  #   update do; end
  #  end

# All fields marked as 'hidden' won't be shown anywhere in the rails_admin unless you mark them as visible.
# There can be different reasons for that:
#  - belongs_to _id and _type (polymorphic) columns are hidden in favor of their associations
#  - associations are hidden if they have no matchable model found (model not included or non-existant)
#  - they are part of a bigger plan in a plugin (Devise/Paperclip) and hidden by contract
# Some fields may be hidden depending on the section, if they aren't deemed suitable for display or edition on that section
#  - non-editable columns (:id, :created_at, ..) in edit sections
#  - has_many/has_one associations in list section (hidden by default for performance reasons)
# Fields may also be marked as read_only (and thus not editable) if they are not mass-assignable by current_user

  # config.model MessageCopy do
  #   # Found associations:
  #   # Found columns:
  #   field :id, :integer
  #   field :sent_messageable_id, :integer
  #   field :sent_messageable_type, :string
  #   field :recipient_id, :integer
  #   field :subject, :string
  #   field :body, :text
  #   field :created_at, :datetime
  #   field :updated_at, :datetime
  #   field :attachment_file_name, :string        # Hidden
  #   field :attachment_content_type, :string        # Hidden
  #   field :attachment_file_size, :integer        # Hidden
  #   field :attachment_updated_at, :string        # Hidden
  #   field :attachment, :paperclip_file
  #   # Sections:
  #   list do; end
  #   export do; end
  #   show do; end
  #   edit do; end
  #   create do; end
  #   update do; end
  #  end

# All fields marked as 'hidden' won't be shown anywhere in the rails_admin unless you mark them as visible.
# There can be different reasons for that:
#  - belongs_to _id and _type (polymorphic) columns are hidden in favor of their associations
#  - associations are hidden if they have no matchable model found (model not included or non-existant)
#  - they are part of a bigger plan in a plugin (Devise/Paperclip) and hidden by contract
# Some fields may be hidden depending on the section, if they aren't deemed suitable for display or edition on that section
#  - non-editable columns (:id, :created_at, ..) in edit sections
#  - has_many/has_one associations in list section (hidden by default for performance reasons)
# Fields may also be marked as read_only (and thus not editable) if they are not mass-assignable by current_user

  # config.model Note do
  #   # Found associations:
  #   field :user, :belongs_to_association
  #   field :notebook, :belongs_to_association
  #   # Found columns:
  #   field :id, :integer
  #   field :name, :string
  #   field :user_id, :integer        # Hidden
  #   field :notebook_id, :integer        # Hidden
  #   field :content, :text
  #   field :created_at, :datetime
  #   field :updated_at, :datetime
  #   field :shareable, :boolean
  #   # Sections:
  #   list do; end
  #   export do; end
  #   show do; end
  #   edit do; end
  #   create do; end
  #   update do; end
  #  end

# All fields marked as 'hidden' won't be shown anywhere in the rails_admin unless you mark them as visible.
# There can be different reasons for that:
#  - belongs_to _id and _type (polymorphic) columns are hidden in favor of their associations
#  - associations are hidden if they have no matchable model found (model not included or non-existant)
#  - they are part of a bigger plan in a plugin (Devise/Paperclip) and hidden by contract
# Some fields may be hidden depending on the section, if they aren't deemed suitable for display or edition on that section
#  - non-editable columns (:id, :created_at, ..) in edit sections
#  - has_many/has_one associations in list section (hidden by default for performance reasons)
# Fields may also be marked as read_only (and thus not editable) if they are not mass-assignable by current_user

  # config.model Notebook do
  #   # Found associations:
  #   field :user, :belongs_to_association
  #   field :course, :belongs_to_association
  #   field :notes, :has_many_association
  #   field :post, :has_many_association
  #   # Found columns:
  #   field :id, :integer
  #   field :user_id, :integer        # Hidden
  #   field :name, :string
  #   field :order, :integer
  #   field :created_at, :datetime
  #   field :updated_at, :datetime
  #   field :course_id, :integer        # Hidden
  #   field :shareable, :boolean
  #   # Sections:
  #   list do; end
  #   export do; end
  #   show do; end
  #   edit do; end
  #   create do; end
  #   update do; end
  #  end

# All fields marked as 'hidden' won't be shown anywhere in the rails_admin unless you mark them as visible.
# There can be different reasons for that:
#  - belongs_to _id and _type (polymorphic) columns are hidden in favor of their associations
#  - associations are hidden if they have no matchable model found (model not included or non-existant)
#  - they are part of a bigger plan in a plugin (Devise/Paperclip) and hidden by contract
# Some fields may be hidden depending on the section, if they aren't deemed suitable for display or edition on that section
#  - non-editable columns (:id, :created_at, ..) in edit sections
#  - has_many/has_one associations in list section (hidden by default for performance reasons)
# Fields may also be marked as read_only (and thus not editable) if they are not mass-assignable by current_user

  # config.model Offering do
  #   # Found associations:
  #   field :course, :belongs_to_association
  #   field :school, :belongs_to_association
  #   field :instructor, :belongs_to_association
  #   field :enrollments, :has_many_association
  #   field :users, :has_many_association
  #   field :posts, :has_many_association
  #   # Found columns:
  #   field :id, :integer
  #   field :course_id, :integer        # Hidden
  #   field :term, :string
  #   field :school_id, :integer        # Hidden
  #   field :instructor_id, :integer        # Hidden
  #   field :created_at, :datetime
  #   field :updated_at, :datetime
  #   # Sections:
  #   list do; end
  #   export do; end
  #   show do; end
  #   edit do; end
  #   create do; end
  #   update do; end
  #  end

# All fields marked as 'hidden' won't be shown anywhere in the rails_admin unless you mark them as visible.
# There can be different reasons for that:
#  - belongs_to _id and _type (polymorphic) columns are hidden in favor of their associations
#  - associations are hidden if they have no matchable model found (model not included or non-existant)
#  - they are part of a bigger plan in a plugin (Devise/Paperclip) and hidden by contract
# Some fields may be hidden depending on the section, if they aren't deemed suitable for display or edition on that section
#  - non-editable columns (:id, :created_at, ..) in edit sections
#  - has_many/has_one associations in list section (hidden by default for performance reasons)
# Fields may also be marked as read_only (and thus not editable) if they are not mass-assignable by current_user

  # config.model Post do
  #   # Found associations:
  #   field :offering, :belongs_to_association
  #   field :user, :belongs_to_association
  #   field :notebook, :belongs_to_association
  #   field :study_session, :belongs_to_association
  #   field :parent, :belongs_to_association
  #   field :comments, :has_many_association
  #   # Found columns:
  #   field :id, :integer
  #   field :user_id, :integer        # Hidden
  #   field :offering_id, :integer        # Hidden
  #   field :text, :text
  #   field :notebook_id, :integer        # Hidden
  #   field :study_session_id, :integer        # Hidden
  #   field :upload_file_name, :string
  #   field :upload_content_type, :string
  #   field :upload_file_size, :string
  #   field :upload_updated_at, :string
  #   field :created_at, :datetime
  #   field :updated_at, :datetime
  #   field :parent_id, :integer        # Hidden
  #   field :reported, :boolean
  #   # Sections:
  #   list do; end
  #   export do; end
  #   show do; end
  #   edit do; end
  #   create do; end
  #   update do; end
  #  end

# All fields marked as 'hidden' won't be shown anywhere in the rails_admin unless you mark them as visible.
# There can be different reasons for that:
#  - belongs_to _id and _type (polymorphic) columns are hidden in favor of their associations
#  - associations are hidden if they have no matchable model found (model not included or non-existant)
#  - they are part of a bigger plan in a plugin (Devise/Paperclip) and hidden by contract
# Some fields may be hidden depending on the section, if they aren't deemed suitable for display or edition on that section
#  - non-editable columns (:id, :created_at, ..) in edit sections
#  - has_many/has_one associations in list section (hidden by default for performance reasons)
# Fields may also be marked as read_only (and thus not editable) if they are not mass-assignable by current_user

  # config.model Role do
  #   # Found associations:
  #   field :users, :has_and_belongs_to_many_association
  #   # Found columns:
  #   field :id, :integer
  #   field :name, :string
  #   field :created_at, :datetime
  #   field :updated_at, :datetime
  #   # Sections:
  #   list do; end
  #   export do; end
  #   show do; end
  #   edit do; end
  #   create do; end
  #   update do; end
  #  end

# All fields marked as 'hidden' won't be shown anywhere in the rails_admin unless you mark them as visible.
# There can be different reasons for that:
#  - belongs_to _id and _type (polymorphic) columns are hidden in favor of their associations
#  - associations are hidden if they have no matchable model found (model not included or non-existant)
#  - they are part of a bigger plan in a plugin (Devise/Paperclip) and hidden by contract
# Some fields may be hidden depending on the section, if they aren't deemed suitable for display or edition on that section
#  - non-editable columns (:id, :created_at, ..) in edit sections
#  - has_many/has_one associations in list section (hidden by default for performance reasons)
# Fields may also be marked as read_only (and thus not editable) if they are not mass-assignable by current_user

  # config.model Room do
  #   # Found associations:
  #   # Found columns:
  #   # Sections:
  #   list do; end
  #   export do; end
  #   show do; end
  #   edit do; end
  #   create do; end
  #   update do; end
  #  end

# All fields marked as 'hidden' won't be shown anywhere in the rails_admin unless you mark them as visible.
# There can be different reasons for that:
#  - belongs_to _id and _type (polymorphic) columns are hidden in favor of their associations
#  - associations are hidden if they have no matchable model found (model not included or non-existant)
#  - they are part of a bigger plan in a plugin (Devise/Paperclip) and hidden by contract
# Some fields may be hidden depending on the section, if they aren't deemed suitable for display or edition on that section
#  - non-editable columns (:id, :created_at, ..) in edit sections
#  - has_many/has_one associations in list section (hidden by default for performance reasons)
# Fields may also be marked as read_only (and thus not editable) if they are not mass-assignable by current_user

  config.model School do
    # Found associations:
    # field :courses, :has_many_association
    # field :offerings, :has_many_association
    # field :course_offering_imports, :has_many_association
    # field :users, :has_many_association
    # Found columns:
    # field :id, :integer
    # field :name, :string
    # field :created_at, :datetime
    # field :updated_at, :datetime
    # field :rss_link, :string
    # field :domain_name, :string
    # field :active, :boolean
    # Sections:
    list do; end
    export do; end
    show do; end
    edit do
      field :id, :integer
      field :name, :string
      field :created_at, :datetime
      field :updated_at, :datetime
      field :rss_link, :string
      field :domain_name, :string
      field :active, :boolean
      field :users, :has_many_association
    end
    create do; end
    update do; end
   end

# All fields marked as 'hidden' won't be shown anywhere in the rails_admin unless you mark them as visible.
# There can be different reasons for that:
#  - belongs_to _id and _type (polymorphic) columns are hidden in favor of their associations
#  - associations are hidden if they have no matchable model found (model not included or non-existant)
#  - they are part of a bigger plan in a plugin (Devise/Paperclip) and hidden by contract
# Some fields may be hidden depending on the section, if they aren't deemed suitable for display or edition on that section
#  - non-editable columns (:id, :created_at, ..) in edit sections
#  - has_many/has_one associations in list section (hidden by default for performance reasons)
# Fields may also be marked as read_only (and thus not editable) if they are not mass-assignable by current_user

  # config.model SessionFile do
  #   # Found associations:
  #   field :study_session, :belongs_to_association
  #   # Found columns:
  #   field :id, :integer
  #   field :study_session_id, :integer        # Hidden
  #   field :upload_file_name, :string        # Hidden
  #   field :upload_content_type, :string        # Hidden
  #   field :upload_file_size, :integer        # Hidden
  #   field :upload_updated_at, :datetime        # Hidden
  #   field :upload, :paperclip_file
  #   field :session_identifier, :string
  #   field :upload_uuid, :string
  #   field :short_id, :string
  #   field :created_at, :datetime
  #   field :updated_at, :datetime
  #   # Sections:
  #   list do; end
  #   export do; end
  #   show do; end
  #   edit do; end
  #   create do; end
  #   update do; end
  #  end

# All fields marked as 'hidden' won't be shown anywhere in the rails_admin unless you mark them as visible.
# There can be different reasons for that:
#  - belongs_to _id and _type (polymorphic) columns are hidden in favor of their associations
#  - associations are hidden if they have no matchable model found (model not included or non-existant)
#  - they are part of a bigger plan in a plugin (Devise/Paperclip) and hidden by contract
# Some fields may be hidden depending on the section, if they aren't deemed suitable for display or edition on that section
#  - non-editable columns (:id, :created_at, ..) in edit sections
#  - has_many/has_one associations in list section (hidden by default for performance reasons)
# Fields may also be marked as read_only (and thus not editable) if they are not mass-assignable by current_user

  # config.model SessionInvite do
  #   # Found associations:
  #   field :study_session, :belongs_to_association
  #   field :user, :belongs_to_association
  #   # Found columns:
  #   field :id, :integer
  #   field :study_session_id, :integer        # Hidden
  #   field :user_id, :integer        # Hidden
  #   # Sections:
  #   list do; end
  #   export do; end
  #   show do; end
  #   edit do; end
  #   create do; end
  #   update do; end
  #  end

# All fields marked as 'hidden' won't be shown anywhere in the rails_admin unless you mark them as visible.
# There can be different reasons for that:
#  - belongs_to _id and _type (polymorphic) columns are hidden in favor of their associations
#  - associations are hidden if they have no matchable model found (model not included or non-existant)
#  - they are part of a bigger plan in a plugin (Devise/Paperclip) and hidden by contract
# Some fields may be hidden depending on the section, if they aren't deemed suitable for display or edition on that section
#  - non-editable columns (:id, :created_at, ..) in edit sections
#  - has_many/has_one associations in list section (hidden by default for performance reasons)
# Fields may also be marked as read_only (and thus not editable) if they are not mass-assignable by current_user

  # config.model StaticPage do
  #   # Found associations:
  #   # Found columns:
  #   field :id, :integer
  #   field :title, :string
  #   field :text, :text
  #   field :slug, :string
  #   field :created_at, :datetime
  #   field :updated_at, :datetime
  #   # Sections:
  #   list do; end
  #   export do; end
  #   show do; end
  #   edit do; end
  #   create do; end
  #   update do; end
  #  end

# All fields marked as 'hidden' won't be shown anywhere in the rails_admin unless you mark them as visible.
# There can be different reasons for that:
#  - belongs_to _id and _type (polymorphic) columns are hidden in favor of their associations
#  - associations are hidden if they have no matchable model found (model not included or non-existant)
#  - they are part of a bigger plan in a plugin (Devise/Paperclip) and hidden by contract
# Some fields may be hidden depending on the section, if they aren't deemed suitable for display or edition on that section
#  - non-editable columns (:id, :created_at, ..) in edit sections
#  - has_many/has_one associations in list section (hidden by default for performance reasons)
# Fields may also be marked as read_only (and thus not editable) if they are not mass-assignable by current_user

  # config.model StudySession do
  #   # Found associations:
  #   field :user, :belongs_to_association
  #   field :offering, :belongs_to_association
  #   field :session_files, :has_many_association
  #   field :session_invites, :has_many_association
  #   field :users, :has_many_association
  #   field :posts, :has_many_association
  #   # Found columns:
  #   field :id, :integer
  #   field :name, :string
  #   field :whiteboard_id, :integer
  #   field :room_id, :integer
  #   field :created_at, :datetime
  #   field :updated_at, :datetime
  #   field :tokbox_session_id, :string
  #   field :user_id, :integer        # Hidden
  #   field :shareable, :boolean
  #   field :offering_id, :integer        # Hidden
  #   # Sections:
  #   list do; end
  #   export do; end
  #   show do; end
  #   edit do; end
  #   create do; end
  #   update do; end
  #  end

# All fields marked as 'hidden' won't be shown anywhere in the rails_admin unless you mark them as visible.
# There can be different reasons for that:
#  - belongs_to _id and _type (polymorphic) columns are hidden in favor of their associations
#  - associations are hidden if they have no matchable model found (model not included or non-existant)
#  - they are part of a bigger plan in a plugin (Devise/Paperclip) and hidden by contract
# Some fields may be hidden depending on the section, if they aren't deemed suitable for display or edition on that section
#  - non-editable columns (:id, :created_at, ..) in edit sections
#  - has_many/has_one associations in list section (hidden by default for performance reasons)
# Fields may also be marked as read_only (and thus not editable) if they are not mass-assignable by current_user

   config.model User do
  #   # Found associations:
  #   field :votes, :has_many_association
  #   field :sent_messages, :has_many_association        # Hidden
  #   field :received_messages, :has_many_association        # Hidden
  #   field :roles, :has_and_belongs_to_many_association
  #   field :notebooks, :has_many_association
  #   field :notes, :has_many_association
  #   field :enrollments, :has_many_association
  #   field :offerings, :has_many_association
  #   field :courses, :has_many_association
  #   field :school, :belongs_to_association
  #   field :followings, :has_many_association
  #   field :followed_users, :has_many_association
  #   field :authentications, :has_many_association
  #   field :session_invites, :has_many_association
  #   field :study_sessions, :has_many_association
  #   field :posts, :has_many_association
  #   field :activity_messages, :has_many_association
  #   # Found columns:
  #   field :id, :integer
  #   field :first_name, :string
  #   field :last_name, :string
  #   field :gender, :string
  #   field :school_id, :integer        # Hidden
  #   field :email, :string
  #   field :major, :string
  #   field :gpa, :decimal
  #   field :fraternity, :string
  #   field :sorority, :string
  #   field :extracurriculars, :text
  #   field :crypted_password, :string
  #   field :password_salt, :string
  #   field :persistence_token, :string
  #   field :perishable_token, :string
  #   field :created_at, :datetime
  #   field :updated_at, :datetime
  #   field :avatar_file_name, :string        # Hidden
  #   field :avatar_content_type, :string        # Hidden
  #   field :avatar_file_size, :integer        # Hidden
  #   field :avatar_updated_at, :datetime        # Hidden
  #   field :avatar, :paperclip_file
  #   field :custom_url, :string
  #   field :bio, :text
  #   field :active, :boolean
  #   field :shares_with_everyone, :boolean
  #   field :googleable, :boolean
  #   field :notify_on_follow, :boolean
  #   field :notify_on_comment, :boolean
  #   field :notify_on_share, :boolean
  #   field :notify_on_invite, :boolean
  #   # Sections:
     list do
       field :name, :string
       field :custom_url, :string
       field :email, :string
       field :school, :belongs_to_association
       field :roles, :has_and_belongs_to_many_association
     end
  #   export do; end
     show do
       field :id, :integer
       field :first_name, :string
       field :last_name, :string
       field :gender, :string
       field :school_id, :integer        # Hidden
       field :email, :string
       field :major, :string
       field :gpa, :decimal
       field :fraternity, :string
       field :sorority, :string
       field :persistence_token, :string
       field :perishable_token, :string
       field :created_at, :datetime
       field :updated_at, :datetime
       field :avatar, :paperclip
       field :custom_url, :string
       field :bio, :text
       field :active, :boolean
       field :shares_with_everyone, :boolean
       field :googleable, :boolean
       field :notify_on_follow, :boolean
       field :notify_on_comment, :boolean
       field :notify_on_share, :boolean
       field :notify_on_invite, :boolean
       field :school, :belongs_to_association
       field :roles, :has_and_belongs_to_many_association
     end
     edit do
       field :school, :belongs_to_association
       field :roles, :has_and_belongs_to_many_association
       field :id, :integer
       field :first_name, :string
       field :last_name, :string
       field :gender, :string
       field :email, :string
       field :password, :string
       field :major, :string
       field :gpa, :decimal
       field :fraternity, :string
       field :sorority, :string
       field :persistence_token, :string
       field :perishable_token, :string
       field :created_at, :datetime
       field :updated_at, :datetime
       field :avatar, :paperclip
       field :custom_url, :string
       field :bio, :text
       field :active, :boolean
       field :shares_with_everyone, :boolean
       field :googleable, :boolean
       field :notify_on_follow, :boolean
       field :notify_on_comment, :boolean
       field :notify_on_share, :boolean
       field :notify_on_invite, :boolean
     end
     update do
       field :school, :belongs_to_association
       field :roles, :has_and_belongs_to_many_association
       field :id, :integer
       field :first_name, :string
       field :last_name, :string
      end
    end

  # All fields marked as 'hidden' won't be shown anywhere in the rails_admin unless you mark them as visible.
  # There can be different reasons for that:
  #  - belongs_to _id and _type (polymorphic) columns are hidden in favor of their associations
  #  - associations are hidden if they have no matchable model found (model not included or non-existant)
  #  - they are part of a bigger plan in a plugin (Devise/Paperclip) and hidden by contract
  # Some fields may be hidden depending on the section, if they aren't deemed suitable for display or edition on that section
  #  - non-editable columns (:id, :created_at, ..) in edit sections
  #  - has_many/has_one associations in list section (hidden by default for performance reasons)
  # Fields may also be marked as read_only (and thus not editable) if they are not mass-assignable by current_user

    # config.model Vote do
    #   # Found associations:
    #   field :voteable, :polymorphic_association
    #   field :voter, :polymorphic_association        # Hidden
    #   # Found columns:
    #   field :id, :integer
    #   field :vote, :boolean
    #   field :voteable_id, :integer        # Hidden
    #   field :voteable_type, :string        # Hidden
    #   field :voter_id, :integer        # Hidden
    #   field :voter_type, :string        # Hidden
    #   field :created_at, :datetime
    #   field :updated_at, :datetime
    #   # Sections:
    #   list do; end
    #   export do; end
    #   show do; end
    #   edit do; end
    #   create do; end
    #   update do; end
    #  end

  # All fields marked as 'hidden' won't be shown anywhere in the rails_admin unless you mark them as visible.
  # There can be different reasons for that:
  #  - belongs_to _id and _type (polymorphic) columns are hidden in favor of their associations
  #  - associations are hidden if they have no matchable model found (model not included or non-existant)
  #  - they are part of a bigger plan in a plugin (Devise/Paperclip) and hidden by contract
  # Some fields may be hidden depending on the section, if they aren't deemed suitable for display or edition on that section
  #  - non-editable columns (:id, :created_at, ..) in edit sections
  #  - has_many/has_one associations in list section (hidden by default for performance reasons)
  # Fields may also be marked as read_only (and thus not editable) if they are not mass-assignable by current_user

    # config.model Whiteboard do
    #   # Found associations:
    #   # Found columns:
    #   # Sections:
    #   list do; end
    #   export do; end
    #   show do; end
    #   edit do; end
    #   create do; end
    #   update do; end
    #  end

  end

  # You made it this far? You're looking for something that doesn't exist! Add it to RailsAdmin and send us a Pull Request!
end
