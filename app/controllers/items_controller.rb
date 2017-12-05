class ItemsController < ApplicationController
  before_action :authenticate_user! # Devise enforce user is present

  include Effective::CrudController

  resource_scope -> { Item.where(account: account) }

  protected

  def account
    @account ||= Account.find(params[:account_id])
  end

  def resource_redirect_path
    account_path(account)
  end

  def item_params
    params.require(:item).permit!
  end

end
