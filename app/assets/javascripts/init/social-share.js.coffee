class @SocialShare

  # Hide / Show the social share list.
  @load = (event) ->

    event.stopPropagation()

    socialShare = $ this
    url = socialShare.data 'url'

    # Only load the list once, if its loaded toggle
    # the is-active class
    if socialShare.hasClass('is-loaded')
      active = socialShare.parent('.js-tile-controls').hasClass 'is-active'

      $('.js-social-share').removeClass 'is-active'
      $('.js-tile-controls').removeClass 'is-active'

      unless active
        socialShare.parent('.js-tile-controls').addClass 'is-active'
        socialShare.addClass 'is-active'

    else
      socialShare.addClass 'is-loading'

      $('.js-social-share').removeClass 'is-active'
      $('.js-tile-controls').removeClass 'is-active'

      $.get url, (data) ->
        socialShare.append(data)
          .removeClass('is-loading')
          .addClass('is-loaded')
          .addClass('is-active')
        socialShare.parent('.js-tile-controls').addClass 'is-active'




  # Remove the is-active class off the button and list
  @close = (event) ->
    $event = $ event

    $('.js-social-share').not(
      $event.closest('.js-social-share')
    ).removeClass 'is-active'

    $('.js-tile-controls').not(
      $event.closest('.js-tile-controls')
    ).removeClass 'is-active'


  @bind = ->
    # Close the social share, when its not needed.
    $(document).on
      click: SocialShare.close

    # On click load in the XHR social share list.
    $( document ).on
      click: SocialShare.load
    , ".js-social-share"

    $( document ).on 'keydown', ( event ) ->
      if ( event.keyCode == 27 )
        $('.js-social-share').removeClass 'is-active'
        $('.js-tile-controls').removeClass 'is-active'


SocialShare.bind()