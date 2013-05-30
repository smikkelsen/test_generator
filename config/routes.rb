TestGenerator::Application.routes.draw do

  resources :projects

  resources :model_tests, :except => [:show, :index]

  match 'set_role/:role' => 'projects#set_role', :as => 'set_role'
  root :to => "projects#set_role"

  resources 'model_test', :only => [:new, :create, :update, :destroy]
  #get '/model' => 'generator#model'
  #post '/model' => 'generator#model'
  #put '/model' => 'generator#model'
  resources 'controller_test', :only => [:new, :create, :update, :destroy]
  #get '/controller' => 'generator#controller'

end
