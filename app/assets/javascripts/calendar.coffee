$(document).on "ready page:load", ->
  element = $('#calendar')
  return unless element[0]?

  initFullCalendar element
  loadEvents element

initFullCalendar = (element) ->
  element.fullCalendar
    header:
      left: 'prev,next today'
      center: 'title'
      right: 'month,agendaWeek,agendaDay'
    weekNumbers: true
    timeFormat: 'H:mm'

loadEvents = (element) ->
  $.get('/events.json?t=all').done (events) ->
    element.fullCalendar 'addEventSource', events
