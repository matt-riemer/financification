class AccountsController < ApplicationController
  before_action :authenticate_user! # Devise enforce user is present

  include Effective::CrudController

  protected

  def account_params
    params.require(:account).permit(:id,
      :user_id, :name, :category
    )
  end

end
