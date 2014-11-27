# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$ ->
  $('a[href=#preview]').on 'shown.bs.tab', ->
    data = {
      content: $('#write textarea').val()
    }

    $.post('/api/v1/markdown', data).done (html) ->
      $('#markdown').html html

  $('.datepicker').datetimepicker
    pickTime: false

  $('.timepicker').datetimepicker
    pickDate: false

  $('#date').on 'dp.change', onUpdated
  $('#start_time').on 'dp.hide', onUpdated
  $('#end_time').on 'dp.hide', onUpdated

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
