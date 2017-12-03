class ImportsController < ApplicationController
  before_action :authenticate_user! # Devise enforce user is present

  include Effective::CrudController

  resource_scope -> { Import.where(account: account) }

  protected

  def account
    @account ||= Account.find(params[:account_id])
  end

  def resource_redirect_path
    account_path(account)
  end

  def import_params
    params.require(:import).permit(:account_id, :content,
      items_attributes: [:source_id, :name]
    )
  end

end
