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
  $.get('/events.json').done (eventsFromServer) ->
    events = []
    for event in eventsFromServer
      events.push
        id: event.id
        title: event.title
        start: event.start_time
        end: event.end_time
        url: '/events/' + event.id

    if callback?
      callback events
