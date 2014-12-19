$(document).on "ready page:load", ->
  fdbk = new Fdbk()

  $('#fdbk').click ->
    fdbk.open()
