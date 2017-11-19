$(document).on 'turbolinks:load', ->
  $("#member_email, #member_name").keypress (e) ->
    if e.which == 13 && valid_email($("#member_email").val()) && $("#member_name").val() != ""
      $('.new_member').submit()

  $("#member_email, #member_name").bind 'blur', ->
    if valid_email($("#member_email").val()) && $("#member_name").val() != ""
      $(".new_member").submit()

  $('body').on 'click', 'a.remove_member', (e) ->
    $.ajax '/members/' + e.currentTarget.id,
        type: 'DELETE'
        dataType: 'json',
        data: {}
        success: (data, text, jqXHR) ->
          Materialize.toast('Campaign member removed successfully', 4000, 'green')
          $('#member_' + e.currentTarget.id).remove()
        error: (jqXHR, textStatus, errorThrown) ->
          Materialize.toast('A problem occurred while removing the member', 4000, 'red')
    return false

  $('.new_member').on 'submit', (e) ->
    $.ajax e.target.action,
        type: 'POST'
        dataType: 'json',
        data: $(".new_member").serialize()
        success: (data, text, jqXHR) ->
          insert_member(data['id'], data['name'],  data['email'])
          $('#member_name, #member_email').val("")
          $('#member_name').focus()
          Materialize.toast('Campaign member added successfully', 4000, 'green')
        error: (jqXHR, textStatus, errorThrown) ->
          Materialize.toast('A problem occurred while adding a new member', 4000, 'red')
    return false

valid_email = (email) ->
  /^([a-zA-Z0-9_.+-])+\@(([a-zA-Z0-9-])+\.)+([a-zA-Z0-9]{2,4})+$/.test(email)

insert_member = (id, name, email) ->
  $('.member_list').append(
    '<div class="member" id="member_' + id + '">' +
      '<div class="row">' +
        '<div class="col s12 m5 input-field">' +
          '<input id="name" type="text" class="validate" value="' + name + '">' +
          '<label for="name" class="active">Name</label>' +
        '</div>' +
        '<div class="col s12 m5 input-field">' +
          '<input id="email" type="email" class="validate" value="' + email + '">' +
          '<label for="email" class="active" data-error="Incorrect Format">Email</label>' +
        '</div>' +
        '<div class="col s3 offset-s3 m1 input-field">' +
          '<i class="material-icons icon">visibility</i>' +
        '</div>' +
        '<div class="col s3 m1 input-field">' +
          '<a href="#" class="remove_member" id="' + id + '">' +
            '<i class="material-icons icon">delete</i>' +
          '</a>' +
        '</div>' +
      '</div>' +
    '</div>')