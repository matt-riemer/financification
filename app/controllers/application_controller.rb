class ApplicationController < ActionController::Base
  protect_from_forgery

  # http_basic_authenticate_with name: 'example', password: 'staging' if Rails.env.production?

  # Meta and titles
  before_action :set_devise_page_title, if: :devise_controller?
  before_action :set_meta_description

  # CanCanCan & /admin authorization
  check_authorization
  skip_authorization_check if: :devise_controller?
  before_action :restrict_admin_routes, if: -> { request.path.start_with?('/admin'.freeze) }

  # Logging, and trash
  # log_page_views
  before_action :set_effective_logging_current_user
  before_action :set_effective_trash_current_user

  rescue_from CanCan::AccessDenied do |exception|
    assign_test_bot_access_denied_exception(exception) if defined?(EffectiveTestBot)

    respond_to do |format|
      @page_title = 'Access Denied'
      format.html { render 'static_pages/access_denied', layout: 'application', status: 403, locals: { exception: exception } }
      format.any { render text: "Access Denied: #{exception.message}", status: 403 }
    end
  end

  def after_sign_in_path_for(user)
    session[:user_return_to] || accounts_path
  end

  private

  def restrict_admin_routes
    authenticate_user! and authorize!(:access, :admin)
  end

  def set_devise_page_title
    @page_title =
      case "#{params[:controller]}_#{params[:action]}".sub('devise/', '').gsub('users/', '')
      when 'sessions_new' then 'Sign In'
      when 'sessions_create' then 'Sign In'
      when 'passwords_new' then 'Forgot Your Password?'
      when 'passwords_create' then 'Forgot Your Password?'
      when 'passwords_edit' then 'Change Your Password'
      when 'passwords_update' then 'Change Your Password'
      when 'confirmations_new' then 'Resend Confirmation Instructions'
      when 'registrations_new', 'user_registrations_new' then 'Sign Up'
      when 'registrations_create', 'user_registrations_create' then 'Sign Up'
      when 'invitations_edit' then 'Accept your Invitation'
      when 'invitations_update' then 'Accept your Invitation'
      when 'invitations_new' then 'Send an Invitation'
      when 'admin/invitations_new' then 'Invite a user'
      when 'admin/invitations_edit' then 'Accept invitation'
      end
  end

  def set_meta_description
    @meta_description ||= (
      case params[:controller]
      when 'effective/posts'  # News
        "News and information."
      when 'devise/registrations' # Sign Up
        "Create an account to apply for full membership."
      when 'devise/sessions' # Sign In
        "Sign in to your account."
      else # Home Page, and any other page that's missed
        "This is a very effective website. Whatever that means."
      end
    )
  end

end
