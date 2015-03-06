activatedElements = {}
renderedEvent = null
startDate = null
endDate = null
deadline = null

$(document).on "ready page:load", ->
  activatedElements = {}

  activateCalendar($('#calendar'))

  activateModalOpenButton element for element in $('.btn-modal-open')
  activateModalCloseButton element for element in $('.btn-modal-close')

  $('#setDateTimeButton').click ->
    if startDate && endDate
      $('#event_invitation_attributes_start_time').val startDate.format()
      $('#event_invitation_attributes_end_time').val endDate.format()

      $('#event_invitation_attributes_start_time').trigger('update')

    $('#editDateTimeModal').modal('hide')

activateModalOpenButton = (element) ->
  button = $(element)
  modal = $(button.data('modal'))
  return unless modal?

  button.click ->
    modal.modal('show')

  modal.on 'shown.bs.modal', ->
    calendar = modal.find('.calendar')
    activateCalendar(calendar)

activateModalCloseButton = (element) ->
  button = $(element)
  modal = $(button.data('modal'))
  return unless modal?

  button.click ->
    modal.modal('hide')

    $('#event_invitation_attributes_deadline').val deadline.format()
    $('#event_invitation_attributes_deadline').trigger('update')

activateCalendar = (element) ->
  return unless element && element.selector
  return if activatedElements[element.selector]

  initFullCalendar element
  loadEvents element

  activatedElements[element.selector] = true

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

  if element.hasClass 'calendar-month'
    config.defaultView = 'month'

    config.selectable = true
    config.select = (start, end) ->
      addEvent element, start
      deadline = start

    config.eventDrop = (event) ->
      deadline = event.start

    config.eventResize = (event) ->
      deadline = event.start

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
