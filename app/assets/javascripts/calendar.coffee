renderedEvent = null
startDate = null
endDate = null

$(document).on "ready page:load", ->
  activateCalendar('#calendar')

  $('#editDateButton').click ->
    $('#editDateModal').on 'shown.bs.modal', ->
      activateCalendar('#calendarModal')

    $('#editDateModal').modal('show')

    $('#setDateButton').click ->
      if startDate && endDate
        $('#event_invitation_attributes_start_time').val startDate.format()
        $('#event_invitation_attributes_end_time').val endDate.format()

        $('#event_invitation_attributes_start_time').trigger('update')

      $('#editDateModal').modal('hide')

activateCalendar = (selector) ->
  element = $(selector)
  return unless element[0]?

  initFullCalendar element
  loadEvents element

initFullCalendar = (element) ->
  config =
    header:
      left: 'prev,next today'
      center: 'title'
      right: 'month,agendaWeek,agendaDay'
    weekNumbers: true
    firstDay: 1
    timeFormat: 'H:mm'
    timezone: 'local'
    lang: 'ja'

  if element.hasClass 'calendar-edit'
    config.header =
      left: 'prev,next today'
      center: 'title'
      right: 'agendaWeek,agendaDay'
    config.defaultView = 'agendaWeek'
    config.contentHeight = 500
    config.axisFormat = 'H:mm'
    config.snapDuration = '00:30:00'
    config.scrollTime = '8:00'
    config.businessHours =
      start: '8:00'
      end: '18:00'

    date = $('#event_invitation_attributes_start_time').val()
    if date? and date.length > 0
      config.defaultDate = date

    config.eventClick = ->
      return false

    config.selectable = true
    config.select = (start, end) ->
      addEvent element, start, end
      updateEvent start, end

    config.eventDrop = (event) ->
      updateEvent event.start, event.end

    config.eventResize = (event) ->
      updateEvent event.start, event.end

  element.fullCalendar config

loadEvents = (element) ->
  $.get('/events.json?t=all').done (events) ->
    id = parseInt $('#event_id').val()
    events = events.filter (event) ->
      return (event.id isnt id) && event.start && event.end

    element.fullCalendar 'addEventSource', events

    if not isNaN(id)
      start = $('#event_invitation_attributes_start_time').val()
      end = $('#event_invitation_attributes_end_time').val()
      addEvent element, start, end

addEvent = (element, start, end) ->
  if renderedEvent?
    for event in renderedEvent
      element.fullCalendar 'removeEvents', event._id

  eventData =
    start: start
    end: end
    editable: true
    className: 'event-edit'
  renderedEvent = element.fullCalendar 'renderEvent', eventData, true

updateEvent = (start, end) ->
  startDate = start
  endDate = end
