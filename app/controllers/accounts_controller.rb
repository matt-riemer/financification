class AccountsController < ApplicationController
  before_action :authenticate_user! # Devise enforce user is present

  include Effective::CrudController

  resource_scope -> { Account.deep.where(user: current_user) }

  protected

  def account_params
    params.require(:account).permit(:id, :name, :category)
  end

end
