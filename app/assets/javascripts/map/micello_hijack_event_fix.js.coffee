$(document).ready ->
  body = $('body')

  # Micello hijacks clicks on the store map for touch devices
  # so listen for touchstart event which is not hijacked and send user to the url manually
  body.on 'touchstart', 'a.js-micello-hijack-event-fix', ->
    window.location.href = $(@).attr 'href'

  body.on 'touchstart', 'button.js-micello-hijack-event-fix', ->
    $(@).click()