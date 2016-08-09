Rails.application.routes.draw do
  root :to => 'home#index'

  devise_for :admins
  devise_for :users
  # devise_for :rollovers, skip: :confirmations # , controllers: { confirmations: 'rollover_confirmations' }

  get 'newsletters', to: 'home#newsletters', as: 'newsletters'

  get 'questions', to: 'home#questions', as: 'questions'

  resources :seasons, only: [] do
    #Subscriptions
    resources :subscriptions, only: [:new, :create]
    get 'subscriptions/success', to: 'subscriptions#success'
  end

  get 'about/contact', to: 'contact#index', as: 'contact'
  post 'about/contact', to: 'contact#submit', as: 'submit_contact'

  resources :rollovers, only: [] do
    get :cancel, on: :collection
  end

  namespace :user do
    root :to => "home#index"
  end

  namespace :admin do
    root :to => "home#index"

    resources :seasons do
      resources :pack_days

      resources :subscriptions, only: [] do
        get :index, action: :seasons_index, on: :collection
      end

      # Rollovers
      resources :rollovers, only: [:index] do
        collection do
          get :new_multiple
          put :create_multiple
          get :new_multiple_from_csv
          post :create_multiple_from_csv
          post :bulk_action
        end
      end
    end

    resources :rollovers, only: [:new, :create]
    resources :subscriptions, only: [:new, :create, :edit, :update]

    resources :users, only: [:index, :new, :create, :edit, :update] do
      resources :subscriptions, only: [] do
        get :index, action: :users_index, on: :collection
      end
    end

    resources :faq_groups do
      resources :faqs, only: :index
    end

    resources :faqs, only: [:new, :create, :edit, :update]
  end

  comfy_route :cms_admin, :path => '/cms'

  # Make sure this routeset is defined last
  comfy_route :cms, :path => '/', :sitemap => false

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
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

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
