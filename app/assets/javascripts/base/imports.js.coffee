# Skip import rule
$(document).on 'click', '[data-skip]', (event) ->
  $(event.currentTarget).closest('.import-rule').remove()
  false

# Name includes snip
$(document).on 'click', '[data-snip]', (event) ->
  $name = $(event.currentTarget).closest('.import-rule').find("input[name$='[name_includes]']")
  $name.val($name.data('import-snip') || '')
  false

$(document).on 'mouseup', "input[name$='[name_includes]']", (event) ->
  $name = $(event.currentTarget)
  $name.data('import-snip', ($name.val() || '').substring(this.selectionStart, this.selectionEnd).trim())

# Toggle existing / new category
$(document).on 'click', '.import-category-switch', (event) ->
  $switch = $(event.currentTarget)

  $switch.siblings('.import-category-exists').toggle()
  $switch.siblings('.import-category-create').toggle()

  false
