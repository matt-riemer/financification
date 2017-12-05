class ImportsController < ApplicationController
  before_action :authenticate_user! # Devise enforce user is present

  include Effective::CrudController

  resource_scope -> { Import.where(account: account) }

  after_error do # The default flash message is terrible
    flash.now[:danger] = 'More information is required to complete this import.'
  end

  protected

  def account
    @account ||= Account.find(params[:account_id])
  end

  def resource_redirect_path
    account_path(account)
  end

  def import_params
    params.require(:import).permit!
  end

end
