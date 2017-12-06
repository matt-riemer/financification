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
    items = account.items.includes(:category).where(date: months.first.all_year).to_a

    categories = items.map { |item| item.category }.uniq
    monthly = items.group_by { |item| "#{item.category_id}_#{item.date.month}" }
    totally = items.group_by { |item| item.category_id }

    categories.map do |category|
      [category] + months.map do |month|
        monthly.fetch("#{category.id}_#{month.month}", []).map { |item| item.amount }.sum
      end + [totally.fetch(category.id, []).map { |item| item.amount }.sum]
    end
  end

  def account
    @account ||= Account.find(attributes[:account_id])
  end

  def months
    @months ||= (1..12).map { |month| Time.zone.local(attributes[:year], month) }
  end

end
