$(document).on "ready page:load", ->
  $('.btn-no-propagation').click (event) ->
    event.stopPropagation()
