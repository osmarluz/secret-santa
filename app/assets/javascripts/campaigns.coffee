$(document).on 'turbolinks:load', ->
  $('.update_campaign input').bind 'blur', ->
    $('.update_campaign').submit()

  $('.update_campaign').on 'submit', (e) ->
    $.ajax e.target.action,
      type: 'PUT'
      dataType: 'json',
      data: $(".update_campaign").serialize()
      success: (data, text, jqXHR) ->
        Materialize.toast('Campaign successfully updated', 4000, 'green')
      error: (jqXHR, textStatus, errorThrown) ->
        Materialize.toast('A problem occurred while updating the campaign', 4000, 'red')
    return false

  $('.remove_campaign').on 'submit', (e) ->
    $.ajax e.target.action,
      type: 'DELETE'
      dataType: 'json',
      data: {}
      success: (data, text, jqXHR) ->
        $(location).attr('href', '/campaigns')
      error: (jqXHR, textStatus, errorThrown) ->
        Materialize.toast('A problem occurred while removing the campaign', 4000, 'red')
    return false

  $('.raffle_campaign').on 'submit', (e) ->
    $.ajax e.target.action,
      type: 'POST'
      dataType: 'json',
      data: {}
      success: (data, text, jqXHR) ->
        Materialize.toast('Raffle successful! An email will be sent to all members shortly', 4000, 'green')
      error: (jqXHR, textStatus, errorThrown) ->
        Materialize.toast(jqXHR.responseText, 4000, 'red')
    return false
