class StaticPagesController < ApplicationController
  skip_authorization_check # CanCanCan

  def home
    @page_title = 'Financification'
  end

end
