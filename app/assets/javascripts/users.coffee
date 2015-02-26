
attachedItems = []
itemsMap = {}

splitString = (val) ->
  val.split(/,\s*/)

extractLast = (term) ->
  splitString(term).pop()

updateField = ->
  $('#event_members').val attachedItems.join(',')

addItem = (item) ->
  return unless item

  return if attachedItems.indexOf(item.id) isnt -1

  attachedItems.push item.id

  itemElement = createItemElement item, ->
    removeItem itemElement

  $('#members').append itemElement

  updateField()

createItemElement = (item, callback) ->
  itemElement = $('<span class="label label-info">').text(item.name).val(item.name)

  closeElement = $('<button type="button" class="close item-close"><span aria-hidden="true">&times;</span><span class="sr-only">Close</span></button>')
  closeElement.click ->
    callback? itemElement

  itemElement.append closeElement

  return itemElement

removeItem = (itemElement) ->
  item = itemElement.val()
  index = attachedItems.indexOf item
  if index isnt -1
    attachedItems.splice index, 1

  itemElement.remove()

  updateField()

injectItem = (elements, item) ->
  # item ||= elements.val()
  addItem item

  elements.val ''

customizeAutocompleteFilter = ->
  $.ui.autocomplete.filter = (array, term) ->
    matcher = new RegExp '^' + $.ui.autocomplete.escapeRegex(term), 'i'
    return $.grep array, (value) ->
      return matcher.test value.label || value.value || value

addCurrentMembers = (elements, map) ->
  ids = $('#event_members').val().split(',')
  for id in ids
    injectItem elements, map[id]

enableAutoComplete = ->
  elements = $('.autocomplete.autocomplete-users')
  return unless elements.length > 0

  attachedItems = []
  itemsMap = {}
  idsMap = {}

  $.get '/users.json', (res) ->
    users = []
    for user in res
      users.push
        id: user.id
        value: user.name
        label: user.email

      users.push
        id: user.id
        value: user.name
        label: user.name

      itemsMap[user.name] = user
      idsMap[user.id] = user

    addCurrentMembers elements, idsMap

    elements.bind 'keydown', (event) ->
      if (event.keyCode is $.ui.keyCode.TAB && $(this).autocomplete('instance').menu.active)
        event.preventDefault()
      else if event.keyCode is 188
        event.preventDefault()
        enterUser()

    elements.autocomplete
      minLength: 1

      source: (request, response) ->
        term = extractLast request.term
        matchedUsers = $.ui.autocomplete.filter users, term

        existUsers = splitString(request.term).slice 0, -1
        hitUsers = $.map matchedUsers, (item) ->
          if attachedItems.indexOf(item.id) is -1
            return item
          else
            return null

        response hitUsers

      focus: ->
        return false

      select: (event, ui) ->
        injectItem elements, itemsMap[ui.item.value]

        return false

      autoFocus: true

$(document).on 'ready page:load', ->
  return unless $('.autocomplete').length > 0

  customizeAutocompleteFilter()
  enableAutoComplete()
