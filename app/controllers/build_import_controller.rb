class BuildImportController < ApplicationController
  include Wicked::Wizard

  steps *Import::STEPS.keys

  helper_method :current_import, :current_item

  before_action :authenticate_user!
  before_action :set_page_title, only: [:show, :upate]
  #before_action :enforce_last_step_if_complete, :enforce_current_step, :set_page_title, only: [:show, :upate]

  def index
    #redirect_to wizard_path(current_import.first_uncompleted_student_step)
  end

  def show
    authorize!(:build, current_import)

    current_import.current_step = step

    case step
    when :start
    when :categorize
    when :review
    when :complete
    else
      raise 'Unknown step'
    end

    render_wizard
  end

  def update
    authorize!(:build, current_import)

    current_import.current_step = step
    current_import.current_user = current_user

    Import.transaction do
      begin
        case step
        when :start
          current_import.assign_attributes(permitted_params)
          current_import.start!

          # Lucky import. It knows all the categories.
          @skip_to = :review if current_import.uncategorized_items.blank?
        when :categorize

          current_item.current_step = step
          current_item.assign_attributes(permitted_params)
          current_item.save!

          current_import.categorize!

          # Repeat this step until all categorized
          @skip_to = step if current_import.uncategorized_items.present?
        when :review
          current_import.assign_attributes(permitted_params)
          current_import.complete!
        else
          raise 'Unknown step'
        end

        redirect_to wizard_path(@skip_to || next_step, import_id: current_import.id) and return
      rescue => e
        flash.delete(:success)
        flash.now[:error] = "#{e.message}.  Please try again."
        raise ActiveRecord::Rollback
      end
    end

    render_step wizard_value(step)  # An error occurred, render the show action
  end

  def current_account
    @account ||= Account.find(params[:account_id])
  end

  def current_import
    @import ||= (
      import = current_account.imports.where(id: params[:import_id]).first unless params[:import_id] == 'new'
      import ||= current_account.imports.build
    )
  end

  def current_item
    @current_uncategorized_item ||= (
      if params[:item_id]
        current_import.items.find { |item| item.to_param == params[:item_id] }
      else
        current_import.uncategorized_items.first
      end
    )
  end

  rescue_from Wicked::Wizard::InvalidStepError do |exception|
    flash[:info] = "Unknown step. You have been moved to the #{Import::STEPS.first} step."
    redirect_to wizard_path(Import::STEPS.first)
  end

protected

  # :start, :submit, :wait
  def permitted_params
    case step
    when :start
      params.require(:import).permit(:content)
    when :categorize
      params.require(:import).permit(
        items_attributes: [:id, :note, :category_id,
          category_attributes: [:name, :category_group_id],
          rule_attributes: [:match_name, :name, :match_note, :note, :match_price, :price_min, :price_max, :match_date, :start_at, :end_at],
        ]
      )[:items_attributes]['0']  # we update current_item
    when :review
      params.require(:import).permit(items_attributes: [:id, :category_id])
    end
  end

private

  def set_page_title
    @page_title = Import::STEPS.fetch(step)
  end

end
