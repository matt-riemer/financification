module WizardHelper
  # Returns 'current', 'completed' for given step
  def wizard_nav_class(obj, nav_step, *args)
    [].tap do |classes|
      args.each { |c| classes << c }

      if nav_step == step
        classes << 'active'
      elsif obj.has_completed_step?(nav_step)
        classes << 'disabled'
      end

    end.compact.join(' ')
  end

  def wizard_navigation_list_item(index, nav_step, label)
    current = (nav_step == step)
    klass = 'list-group-item'
    klass += ' active' if current
    content_tag(:a, "#{index+1}. #{label}", class: klass)
  end

  def wizard_access_to?( wizard_object, nav_step )
    wizard_object.has_completed_step?( nav_step ) || nav_step == wizard_object.first_uncompleted_step
  end

end
