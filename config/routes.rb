Rails.application.routes.draw do
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'

  root controller: :home, action: :show

  resources :contests, only: %i[index show] do
    get :content, on: :member

    resources :users, only: %i[index new create]

    resource :upload, only: %i[new create update]

    get :upload, to: redirect('/contests/%{contest_id}/upload/new')

    resources :statistics, :results, only: :index

    resource :scoring, only: :show

    resource :judge, only: %i[show destroy] do
      get :users_csv
      get :judge_xlsx
    end
  end

  resource :timer, only: :show
end
