initialize = ->
  $("a[data-toggle='popover']:not(.initialized)").each (i, element) ->
    $(element).addClass('initialized').popover(html: true)
    $(element).on 'click', (event) -> event.preventDefault(); false

$ -> initialize()
$(document).on 'page:change', -> initialize()
$(document).on 'turbolinks:load', -> initialize()
$(document).on 'turbolinks:render', -> initialize()
$(document).on 'cocoon:after-insert', -> initialize()
