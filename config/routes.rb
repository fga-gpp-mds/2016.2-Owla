Rails.application.routes.draw do

  root 'sessions#new'
  post '/rooms/signup' => 'rooms#signup'
  post '/rooms/signout' => 'rooms#signout'

  post '/topics/:id/ban_member' => 'rooms#ban_member', as: 'ban_member'
  get 'rooms/:id/banned_members' => 'rooms#banned_members', as: 'banned_members'
  post 'rooms/:id/reintegrate_member' => 'rooms#reintegrate_member', as: 'reintegrate_member'

	post 'moderate_question/:id', to: 'questions#moderate_question', as: 'moderate_question'
  post 'moderate_answer/:id', to: 'answers#moderate_answer', as: 'moderate_answer'
  get '/search', to: 'searches#search', as: 'search'

  post 'report_question/:id', to: 'reports#create_report_question', as: 'report_question'
  post 'report_answer/:id', to: 'reports#create_report_answer', as: 'report_answer'

  post '/answers/:answer_id/tag', to: 'tags#create', as: 'create_tag'

  match '/members/:id/home' => 'members#home', via: :get, as: 'home'
  match '/members/:id/joined' => 'members#joined_rooms', via: :get, as: 'joined_rooms'
  match '/members/:id/myrooms' => 'members#my_rooms', via: :get, as: 'my_rooms'

  resources :members, shallow: true do
    resources :rooms do
        resources :topics do
          resources :questions do
            member do
              post "like", to: "questions#like"
            end
            resources :answers do 
              member do
                post "like", to: "answers#like"
              end  
            end

            resources :answers
            resources :tags
          end
        end
    end
  end

  get 'sessions/new'
  get    '/login',   to: 'sessions#new'
  post   '/login',   to: 'sessions#create'
  get '/logout',  to: 'sessions#destroy'

end
