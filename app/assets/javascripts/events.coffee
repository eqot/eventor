# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).on "ready page:load", ->
  enableMarkdownPreview()
  changeVisibilityMembersTextBox()

  updateDateTime()

  $('#event_invitation_attributes_start_time').on 'update', ->
    updateDateTime()

enableMarkdownPreview = ->
  $('a[href=#preview]').on 'shown.bs.tab', ->
    data = {
      content: $('#write textarea').val()
    }

    $.post('/api/v1/markdown', data).done (html) ->
      $('#markdown').html html

changeVisibilityMembersTextBox = ->
  $('input[id=event_visibility]').change ->
    if this.checked
      $('#members_form').removeClass('hidden')
    else
      $('#members_form').addClass('hidden')

updateDateTime = ->
  update = (inElement, outElement)->
    m = moment($(inElement).val())

    value = "#{m.format('HH:mm')}"
    if not $(outElement).hasClass('time-only')
      value = "#{m.format('L')} (#{m.format('ddd')}) " + value

    $(outElement).text(value)

  update('#event_invitation_attributes_start_time', '#start_time')
  update('#event_invitation_attributes_end_time', '#end_time')
