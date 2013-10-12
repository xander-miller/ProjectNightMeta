ProjectNightMeta::Application.routes.draw do
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
   root 'home#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  get '/about'    => 'home#about'
  get '/signin'        => 'sessions#index'
  get '/user/signout'  => 'sessions#signout'
  get '/auth/:provider/callback' => 'sessions#create'

#  get  '/groups'          => 'groups#index'
  get  '/groups/:id'      => 'groups#show'
  get  '/projects/:id'    => 'projects#show'
  get  '/members/:id'     => 'members#show'

  get  '/user/account'                 => 'accounts#index'
  post '/user/account/update/profile'  => 'accounts#update_profile'
  post '/user/account/sync/groups'     => 'accounts#sync_groups'
  post '/user/account/sync/projects'   => 'accounts#sync_projects'

  get  '/user/groups'      => 'user_groups#index'

  get  '/user/projects'        => 'user_projects#index'
  put  '/user/projects/:id/toggle'  => 'user_projects#toggle_visible'
  get  '/user/projects/new'    => 'user_projects#new'
  post '/user/projects'        => 'user_projects#create'
  get  '/user/projects/:id/edit' => 'user_projects#edit'
  put  '/user/projects/:id'      => 'user_projects#update'
  delete '/user/projects/:id'    => 'user_projects#delete'

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
