module ApplicationHelper

  def item_category_collection(item)
    user = (item.account || item.import.account).user

    if item.debit.present?
      user.debit_groups.inject({}) { |h, cg| h[cg.name] = cg.categories.map { |c| [c.name, c.id] }; h }
    else
      user.credit_groups.inject({}) { |h, cg| h[cg.name] = cg.categories.map { |c| [c.name, c.id] }; h }
    end
  end

  def user_category_collection(user)
    user.category_groups.inject({}) { |h, cg| h[cg.name] = cg.categories.map { |c| [c.name, c.id] }; h }
  end

  def item_category_group_collection(item)
    user = (item.account || item.import.account).user

    if item.debit.present?
      user.debit_groups.map { |cg| [cg.name, cg.id] }
    else
      user.credit_groups.map { |cg| [cg.name, cg.id] }
    end
  end

end
