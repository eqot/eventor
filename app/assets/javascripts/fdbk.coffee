$(document).on "ready page:load", ->
  if not Fdbk?
    $('#fdbk').remove()
    return

  fdbk = new Fdbk 'Eventor', $('#fdbk')[0]

  $('#fdbk').click ->
    fdbk.open()
