# Name includes snip
$(document).on 'click', '[data-snip]', (event) ->
  event.preventDefault()

  $form = $(event.currentTarget).closest('form')

  $name = $form.find("input[name$='[rule_attributes][name]']").first()

  if $name.data('import-snip').length > 0
    $name.val($name.data('import-snip') || '')
    $form.find("input[name$='[rule_attributes][match_name]']").prop('checked', true)

  false

$(document).on 'mouseup', "input[name$='[rule_attributes][name]']", (event) ->
  $name = $(event.currentTarget)
  $name.data('import-snip', ($name.val() || '').substring(this.selectionStart, this.selectionEnd).trim())
