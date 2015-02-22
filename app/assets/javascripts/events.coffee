# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).on "ready page:load", ->
  enableMarkdownPreview()
  changeVisibilityMembersTextBox()

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
      $('#event_members').removeClass('hidden')
    else
      $('#event_members').addClass('hidden')
