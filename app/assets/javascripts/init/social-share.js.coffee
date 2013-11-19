class @SocialShare

  # Hide / Show the social share list.
  @load = ->
    socialShare = $ this
    list = socialShare.find '.js-social-share-list'
    url = socialShare.data 'url'

    # Only load the list once, if its loaded toggle
    # the is-active class
    if socialShare.hasClass('is-loaded')
      list.toggleClass 'is-active'
      socialShare.toggleClass 'is-active'
    else
      socialShare.addClass 'is-loading'
      $.get url, (data) ->
        socialShare.append(data)
          .removeClass('is-loading')
          .addClass('is-loaded')
          .addClass('is-active')
        list.addClass 'is-active'

  # Remove the is-active class off the button and list
  @close = ->
    socialShare = $ this
    list = socialShare.find '.js-social-share-list'
    list.removeClass 'is-active'
    socialShare.removeClass 'is-active'

  @bind = ->
    # Close the social share, when its not needed.
    $(document).on
      mouseleave: SocialShare.close
      mouseenter: SocialShare.close
    , ".js-tile"

    # On click load in the XHR social share list.
    $( document ).on
      click: SocialShare.load
    , ".js-social-share"


SocialShare.bind()