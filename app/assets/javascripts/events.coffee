# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).on "ready page:load", ->
  enableMarkdownPreview()
  enableDateTimePicker()

enableMarkdownPreview = ->
  $('a[href=#preview]').on 'shown.bs.tab', ->
    data = {
      content: $('#write textarea').val()
    }

    $.post('/api/v1/markdown', data).done (html) ->
      $('#markdown').html html

enableDateTimePicker = ->
  dateElement = $('#date')
  return unless dateElement[0]?

  startTimeElement = $('#start_time')
  endTimeElement = $('#end_time')

  date = new Date()
  date.setMinutes 0
  date.setHours(date.getHours() + 1)

  $('.datepicker').datetimepicker
    pickTime: false
    calendarWeeks: true
  .data('DateTimePicker').setValue date

  $('.timepicker').datetimepicker
    pickDate: false
    format: 'HH:mm'

  startTimeElement.data('DateTimePicker').setValue date

  dateElement.on 'dp.change', onUpdated
  startTimeElement.on 'dp.hide', onUpdated
  endTimeElement.on 'dp.hide', onUpdated

  startTimeElement.on 'dp.hide', ->
    if endTimeElement.val() is ''
      date = new Date('1/1/2000 ' + startTimeElement.val())
      date.setHours(date.getHours() + 1)
      endTimeElement.data('DateTimePicker').setValue date

onUpdated = ->
  date = $('#date').val()
  if date.length > 0

    startTime = $('#start_time').val()
    if startTime.length > 0
      start = new Date(date + ' ' + startTime)

      $('#event_start_time_1i').val start.getFullYear()
      $('#event_start_time_2i').val start.getMonth() + 1
      $('#event_start_time_3i').val start.getDate()
      hour = start.getHours()
      hour = '0' + hour if hour < 10
      $('#event_start_time_4i').val hour
      $('#event_start_time_5i').val start.getMinutes()

    endTime = $('#end_time').val()
    if endTime.length > 0
      end = new Date(date + ' ' + endTime)

      $('#event_end_time_1i').val end.getFullYear()
      $('#event_end_time_2i').val end.getMonth() + 1
      $('#event_end_time_3i').val end.getDate()
      hour = end.getHours()
      hour = '0' + hour if hour < 10
      $('#event_end_time_4i').val hour
      $('#event_end_time_5i').val end.getMinutes()
