class @SocialShare

  # Remove the is-active class off the button and list
  @closeAll = (event) ->
    $('.js-social-share, .js-tile-controls').removeClass 'is-active'
    $('.js-social-share-trigger').attr 'aria-expanded', false

  @open = (event) ->
    $toOpen = $ this
    active = $toOpen.hasClass 'is-active'
    loaded = $toOpen.hasClass 'is-loaded'

    event.stopPropagation()
    SocialShare.closeAll()

    open = ->
      #close other drop downs when a social share widget opens
      window.closeFilters?();
      window.closeToggleVisibilty();
      $toOpen
        .addClass('is-active')
        .parent('.js-tile-controls').addClass('is-active')
      $toOpen.find('button').attr('aria-expanded', true)

    if loaded
      # Only open if it was not active before... aka toggle
      open() unless active
    else
      # Load in the list if we dont have it
      $toOpen.addClass 'is-loading'
      $.get $toOpen.data('url'), (data) ->
        $toOpen.append(data)
          .removeClass('is-loading')
          .addClass('is-loaded')
        open()

  @bind = ->
    # Close the social share, when its not needed.
    $(document).on click: SocialShare.closeAll

    # On click load in the XHR social share list.
    $(document).on click: SocialShare.open, ".js-social-share"

    # Close all on esc key being pressed
    $(document).on 'keydown', (event) ->
      SocialShare.closeAll() if event.keyCode == 27

SocialShare.bind()