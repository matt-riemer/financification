module MenuHelper

  def nav_link_to(label, path, opts = {})
    content_tag(:li, class: ('active' if request.fullpath.include?(path))) do
      link_to(label, path, opts)
    end
  end

  def nav_dropdown(label, link_class: [], list_class: [], &block)
    raise 'expected a block' unless block_given?

    content_tag(:li, class: 'dropdown') do
      content_tag(:a, class: 'dropdown-toggle', href: '#', 'data-toggle': 'dropdown', role: 'button', 'aria-haspopup': 'true', 'aria-expanded': 'false') do
        label.html_safe + content_tag(:span, '', class: 'caret')
      end + content_tag(:ul, class: 'dropdown-menu') { yield }
    end
  end

end
