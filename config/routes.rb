Rails.application.routes.draw do
  devise_for :users
  get ':controller/:action/:state/:page_number', constraints: {page_number: /[1-9][0-9]*/}
  get '/home', to: 'home#home'
  get '/home/:state/:city', to: 'home#home'
  get '/contact', to: 'contact#contact'
  get '/page_plus_activation', to: 'page_plus_activation#page_plus_activation'
  get '/page_plus_port_in', to: 'page_plus_activation#page_plus_port_in'
  get '/locate_state', to: 'locate#locate_state'
  get '/locate_city/:state/:page_number', to: 'locate#locate_city', constraints: {page_number: /[1-9][0-9]*/}

  get '/photo_gallery', to: 'photo_gallery#photo_gallery'
  
  post '/page_plus_activation_submit', to:'page_plus_activation#page_plus_activation_submit'
  
  root :to => redirect('/home')
end
