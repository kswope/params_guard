RailsRoot::Application.routes.draw do

  # resources :documents
  # resources :folders


  get '/show_with_model' => 'documents#show_with_model'

  get '/show_with_model_nested' => 'documents#show_with_model_nested'

  get '/show_without_model' => 'documents#show_without_model'

end
