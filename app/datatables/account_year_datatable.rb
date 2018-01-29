class AccountYearDatatable < Effective::Datatable

  datatable do
    col :category

    months.each do |month|
      col month.strftime('%b %Y'), as: :price do |val|
        val == 0 ? '-' : price_to_currency(val)
      end
    end

    col :total, as: :price do |val|
      val == 0 ? '-' : price_to_currency(val)
    end

    aggregate :total
  end

  collection do
    # All year items
    items = account.items.includes(:category).where(date: months.first.all_year).to_a

    # Items scoped by debits or credits
    items = items.select { |item| item.debit.present? } if debits?
    items = items.select { |item| item.credit.present? } if credits?

    # All the groups
    categories = items.map { |item| item.category }.uniq
    monthly = items.group_by { |item| "#{item.category_id}_#{item.date.month}" }
    totally = items.group_by { |item| item.category_id }

    # For each category, category, months, total
    categories.map do |category|
      [category] + months.map do |month|
        monthly.fetch("#{category.id}_#{month.month}", []).map { |item| item.amount }.sum
      end + [totally.fetch(category.id, []).map { |item| item.amount }.sum]
    end
  end

  def totals
    aggregate(collection, raw: true)
  end

  def account
    @account ||= Account.find(attributes[:account_id])
  end

  def months
    @months ||= (1..12).map { |month| Time.zone.local(attributes[:year], month) }
  end

  def debits?
    attributes[:debits] == true
  end

  def credits?
    attributes[:credits] == true
  end

end
