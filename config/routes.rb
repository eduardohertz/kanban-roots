KanbanRoots::Application.routes.draw do

  devise_for :contributors

  get 'contributors' => 'contributors#index'

  resources :projects, :path_names => { :edit => 'admin' }, :except => [:index, :show] do
    resources :tasks, :path_names => { :edit => 'edit' } do
      resources :comments, :except => :show
    end
    resources :categories, :path_names => { :edit => 'edit' }, :except => :show
  end

  match 'projects/:project_id/board' => 'boards#show',  :as => :project_board
  match 'projects/:project_id/clean_up_done' => 'boards#clean_up_done',  :as => :clean_up_done

  match 'board/update_position' => 'boards#update_position'
  match 'board/update_points' => 'boards#update_points'
  match 'board/update_assignees' => 'boards#update_assignees'

  root :to => 'contributors#dashboard'

end

