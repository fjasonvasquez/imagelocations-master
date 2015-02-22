Imagelocations::Application.routes.draw do

 

  #get "home/index"

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
  
  devise_for :users, :controllers => {
  						:omniauth_callbacks => "users/omniauth_callbacks",
  						:registrations => "users/registration"
  						
  					},
  					 :path => 'account',
  					 :path_names => {
	  						:sign_in => 'login', 
	  						:sign_out => 'logout',
	  						:password => 'secret', 
	  						:confirmation => 'verification',
	  						:registration => 'profile', 
	  						:edit => 'edit/profile'
	  				 } do								
  end
  
  
  
  
  root :to => 'home#index'
  
  get '/weather/', to: 'home#weather'
  
  
  resources :plans, :only => [:index, :show] do
  	member do
  		match 'order' => 'subscriptions#new', :as => :order
  	end
  end
  
  #### SUBSCRIPTIONS ####
  
  resources :subscriptions, :only => [:index, :create], :path => "account/subscriptions"
  
  get "/checkout/", :to => 'subscriptions#checkout', :as => "checkout"
  
  post "/checkout/", :to => 'subscriptions#create', :as => "checkout"
  
  put "/checkout/", :to => 'subscriptions#create', :as => "checkout"
  
  post "/checkout/promo_code", :to => 'subscriptions#promo_code', :as => "promo_code"
  
  post "/checkout/public_promo_code", :to => 'subscriptions#public_promo_code', :as => "public_promo_code"
  
  delete "/checkout/promo_code", :to => 'subscriptions#remove_promo_code', :as => "promo_code"
  
  #### APPLICATIONS ####
  
  get :application, :to => 'location_applications#new', :as => "location_application"
  post :application, :to => 'location_applications#create', :as => "location_application"
  
  resources :locations, :only => [:show] do
  	collection do
  		get :search
  	end
  	member do
  		get "public", :to => 'locations#public', :as => "public"
  		
  		get "download/:version", :to => 'locations#download', :as => "download_images"
  		post :email
  	end
  end
  
  resources :taxonomy_terms, :only => [:index, :show]
  resources :taxonomies, :only => [:index]
  resources :taxonomy_term_entities
  
  resources :publications, :only => [:index, :show]
  
  resources :categories, :only => [:index, :show] do
  	member do
  		get :quick, :to => 'categories#show', :view_as => :grid
  		post :email
  	end
  end
  
  get '/projects/:company_name/:id', to: 'projects#show', as: 'company_project'
  
  resources :projects, :only => [:index, :show] do
  	member do
  		get :quick, :to => 'projects#show', :view_as => :grid
  	
  	end
  	collection do 
  		post :auth
  	end
  end
  
  resources :permits, :only => [:index, :show] do
  	member do
  		get :quick, :to => 'permits#show', :view_as => :grid
  	end
  end
  
  resources :cities, :only => [:index, :show] do
  	member do
  		get :quick, :to => 'cities#show', :view_as => :grid
  	end
  end
  
  resources :series, :only => [:show] do
  	member do
  		get :quick, :to => 'series#show', :view_as => :grid
  	end
  end
  
  resources :regions, :only => [:index, :show] do

  end
  
  resources :photographers, :only => [:index, :show] do
  	
  end

  
  get '/search/', to: 'search#index'
  
  
  get '/email/', to: 'share#email'
  
  get '/pdf/', to: 'share#pdf'
  
  
  match "/about(.:format)" => "info#about", :as => :about, :via =>[:get]
  
  match "/contact(.:format)" => "info#contact", :as => :contact, :via =>[:get]
  
  
  resources :collections, :only => [:index] do
  	collection do 
  		post :email
  		get :download, :defaults => { :format => 'pdf' }
  	end
  end
  
  #match "/videos(.:format)" => "home#videos", :as => :videos, :via =>[:get]
  
  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  namespace :admin do

  	root :to => "dashboard#index"
  	get 'dashboard' => 'dashboard#index'
  	#get '/' => 'dashboard#index'
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  	
  	#resources :sites do
  	#	resources :settings
  	#end

  	resources :content
  	resources :users do
  	  member do
  	  	put :sign_in_as
  	  end
  	  resources :memberships
  	  resources :subscriptions
  	end
  	
  	resources :plans
  	
  	
  	
  	resources :promo_codes
  	
  	resources :orders

  	resources :roles
  	resources :subscriptions
  	
  	resources :series
    resources :locations do
      member do
      	get 'new_similar', :to => "locations#new_similar", :as => "new_similar"
        get :taxonomy_terms
        get :asset_entities
        get "send_images", :to => "locations#send_images", :as => "send_images"
        post "process_send_images", :to => "locations#process_send_images", :as => "process_send_images"
        
        get "sort_tears", :to => "locations#sort_tears", :as => "sort_tears"
        
        
        
        
      end
    end
	
	resources :location_applications do
	
	
	end
	
    resources :taxonomy_terms do
      member do
        get :assets
      end
    end

    resources :taxonomy_term_entities
    resources :taxonomies

    resources :assets, :except => [:new] do
	    collection do
    		get ':type/new', :to => "assets#new", :as => 'new'
    		get ':type', :to => "assets#index", :as => 'index'
    	end
      member do
        get :taxonomy_terms
      end
  	end
  	
  	resources :regions
  	resources :permits

    
  	resources :states, :only => [:index, :show, :edit, :update, :destroy] do
  		resources :cities, :only =>  [:index, :show, :edit, :update, :destroy]		
  	end
  	
  	scope 'countries/:country_alpha2' do
  		resources :states do
  			resources :cities
  		end
  	end
  	
  	
  	resources :categories
  	
  	resources :cities
  	
  	resources :projects do
  		collection do
  			post :batch_destroy
  		end
  	end
  	
  	
  	resources :companies
  	resources :tears do
  		collection do
  			post :reorder
  		end
  	
  	end
  	resources :publications
  	
  	resources :publication_categories
  	
  	
  	resources :photographers
  	
  	resources :sections, :only => [:index, :show] do
  		resources :banner_entities do
  			collection do
  				post :reorder
  			end
  		end
  	end
  	
  	
  	
  	resources :site_entities, :only => [:index,:destroy]
  	
  	resources :settings, :only => [:index] do
  		collection do
  			post :update
  		end
  	end
  end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
  
  match '*a', :to => 'errors#routing'
  
end
