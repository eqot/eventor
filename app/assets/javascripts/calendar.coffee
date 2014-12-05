$(document).on "ready page:load", ->
  enableFullCalendar()

enableFullCalendar = ->
  calendarElement = $('#calendar')
  return unless calendarElement[0]?

  getEvents (events) ->
    calendarElement.fullCalendar
      header:
        left: 'prev,next today'
        center: 'title'
        right: 'month,agendaWeek,agendaDay'
      eventSources: [
        events: events
      ]
      weekNumbers: true
      timeFormat: 'H:mm'

getEvents = (callback) ->
  $.get('/events.json?past=true').done (res) ->
    if callback?
      callback res.events
