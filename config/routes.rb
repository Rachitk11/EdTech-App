Rails.application.routes.draw do
  get "/healthcheck", to: proc { [200, {}, ["Ok"]] }
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)

  namespace :account_block do
    resources :accounts do
      collection do
        get 'users_data'
        post 'validate_unique_id'
        post 'user_data'
        patch 'deactivate'
      end
    end
  end

  namespace :bx_block_profile do 
    resources :profiles do
      get 'show_about_us', on: :collection
      get 'show_faq', on: :collection
    end

    resources :passwords do
      post 'reset_password', on: :collection
    end

    put 'update', to: 'profiles#update'
    get 'show', to: 'profiles#show'
  end

  namespace :bx_block_login do
    resources :logins
  end

  namespace :bx_block_contact_us do
    resources :contacts
  end

  namespace :bx_block_terms_and_conditions do
    resources :terms_and_conditions do
      collection do
        get 'show'
        post 'latest_record'
        put 'accept_and_reject'
      end
    end
  end

  namespace :bx_block_categories do
    resources :schools do
      collection do
      end
    end
  end

  namespace :bx_block_analytics7 do
    resources :school_admin_analytics do
      collection do
        get 'get_all_data'
      end
    end
    resources :publisher_analytics do
      get 'publisher_analytics', on: :collection
    end
  end
  namespace :bx_block_landingpage2 do
    resources :landingpages, only: [:index] do
      collection do
        get :show_bundle
        get :show_ebooks
        get :list_subject
        get :class_listing
        get :division_listing
      end
      member do
        get :student_find
        get :show_one_book_details
        get :student_assigned_ebook_index
        get :student_assigned_assignment_index
        get :student_assigned_video_index
      end
    end
    resources :school_admin_landingpages do
      post 'get_users', on: :collection
      post 'show_student_detail', on: :collection
      post 'show_teacher_detail', on: :collection
    end
  end

  namespace :bx_block_landingpage2 do
    resources :student_landingpages do
      collection do
        get :assigned_assignment_index
        get :ebook_show_all
        post :hide_ebook
      end
    end
  end


  namespace :bx_block_bulk_uploading do
    resources :ebooks do
      post 'get_ebooks', on: :collection
    end
    resources :ebook_assigns do
      post :ebook_assign, on: :collection
    end
  end

  namespace :bx_block_catalogue do
    resources :study_materials do
      collection do
        get :video_lecture
        get :video_and_assignment_for_student
        get :video_and_assignment_for_teacher 
        get :video_and_assignment_for_school_admin
        get :student_details_video
        get :student_details_assignment
        get :student_details_ebook
        post :update_video_status
      end
    end
  end
  namespace :bx_block_elasticsearch do
    resources :search do
      collection do
        get :search_content
      end
    end
  end

  namespace :bx_block_order_management do
    resources :orders do
    end
    post :add_order_items, to: 'orders#add_order_items'
    delete :remove_order_items, to: 'orders#remove_order_items'
  end

  namespace :bx_block_documentstorage2 do
    resources :my_book_stores, only: [:index] do
      collection do
        get :show_bundle
        get :show_ebooks
      end
      member do
        get :show_one_book_details
        get :show_one_bundle_details
      end
    end
  end
end
