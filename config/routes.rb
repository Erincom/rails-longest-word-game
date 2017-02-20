Rails.application.routes.draw do
  root to: 'games#run'
  get '/score', to: 'games#score'
  post '/score', to: 'games#score'

  get '/game', to: 'games#run'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
