Studyhall::Application.routes.draw do

  resources :notes
  resources :notebooks do
    collection do
      post "delete_multiple"
      post "update_multiple"
    end
    resources :notes do
      member do
        put 'move'
      end
    end
  end
  resources :classes do
    resources :posts do
      member do
        get "filter"
      end
    end
    resources :comments
    get "offerings_for_school/:school_id", :action => "offerings_for_school"
    get "classmates"
    member do
      post "share"
    end
  end
  #resources :followings, :only => [:create, :destroy]
  post '/followings' => 'followings#create', :as => :follow
  delete '/following/:id' => 'followings#destroy', :as => :unfollow

  namespace :admin do
    resources :users
    resources :static_pages
    resources :schools
    resources :course_offering_imports do
      member do
        post "import"
      end
    end
    resources :courses
    resources :instructors
    resources :offerings
  end

  resources :static_pages, :only => [:show]
  resources :contacts  
  get "/messages/:mailbox" => "messages#index", :as => :mailbox, :constraints => {:mailbox => /(inbox|archive)/}
  resources :users do
    get 'extracurriculars'
    get "buddies"
    delete "drop_class/:offering_id", :action => "drop_class", :as => "drop_class"
    get "block/:blocked_user_id", :action => "block", :as => "block"
    get "account"
    member do
      get 'profile_wizard'
      get "completion_percentage"
    end
    resources :messages, only: [:new, :create]
    post '/votes' => 'votes#create', :as => :upvote
    delete '/votes' => 'votes#destroy', :as => :downvote
  end
  resources :messages, except: [:edit] do
    collection do
      post "update_multiple"
    end
  end
  get "filter_messages" => "messages#filter"
  resources :password_resets
  resources :user_sessions
  resources :whiteboards
  resources :rooms
  resources :study_sessions do
    resources :session_invites, as: "invites"
  end
  resources :home do
    collection do
      get "landing_page"
    end
  end
  resources :filters, only: [:new, :create]
  resources :group_deletes, only: [:new, :create]
  post "/searches" => "searches#create", :as => "search", :format => :html
  get "/searches" => "searches#create", :as => "search", :format => :js

  resources :authentications
  match '/auth/:provider/callback' => 'authentications#create'
  match '/auth/failure' => 'user_sessions#new'
  match '/auth/:provider', to: lambda{|env| [404,{},["Not Found"]]}
  
  match 'login' => "user_sessions#new",      :as => :login
  match 'logout' => "user_sessions#destroy", :as => :logout
  match '/activate/:id' => 'activations#create', :as => :activate
  match '/admin_data', :to => 'admin_data/home#index', :as => 'admin_data_root'
  
  root :to => "home#index"
  
  match "styleguide" => "styleguide#styleguide"
  
  get ':id' => "static_pages#show", :as => :page

  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => 'welcome#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
end
