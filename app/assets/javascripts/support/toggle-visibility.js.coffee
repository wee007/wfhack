# Toggles the visibility of elements
# Usage:
#   <div class="toggle-visibility" toggle-visibility="id_of_element_to_be_toggled"></div>

class @ToggleVisibility
  isActiveClass: 'is-active'
  triggerSelector: '[toggle-visibility]'
  targetSelector: 'js-toggle-visibility-target'
  triggerEvent: 'click'
  events:
    show: 'toggle-visibility.show'
    hide: 'toggle-visibility.hide'
  constructor: ->

    # When Product Browse doesn't use angular, this check can be removed!
    angular.element(document).ready =>
      @getTriggers()
      @initiaiseElements()
    @setupEventListeners()

  getTarget: (trigger, returnId = false) ->
    targetId = trigger.attr('toggle-visibility')
    if returnId then [$("##{targetId}"), targetId] else $("##{targetId}")

  getTriggers: =>
    @triggers = $(@triggerSelector)

  initiaiseElements: =>
    @triggers.each (i, element) =>
      trigger = $(element)

      [target, targetId] = @getTarget(trigger, true)

      # Set intial aria for triggers
      trigger.attr
        'aria-haspopup': true
        'aria-controls': targetId
        'aria-expanded': false

      target.addClass @targetSelector

  setupEventListeners: =>
    self = @

    # Attach event listener to document so it works with pjax on stores page, where elements come and go without page load
    doc.on @triggerEvent, @triggerSelector, ->
      self.toggleTarget $(@)

    # Escape key closes the target and stops event from bubbling to document
    doc.on 'keydown', (event) =>
      if event.keyCode == 27
        event.stopPropagation()
        if @trigger? and @target?
          @hide()
        $("#{@triggerSelector}.is-active").click()

    # Click outside of target
    doc.on 'click',  (event) =>
      # Only execute if click was not on a tog vis trigger or target
      isToggleVisibility = "#{@triggerSelector}, .#{@targetSelector}"
      isAnotherDropdownOpen = @trigger? and @target?
      togvisParent = $(event.target).closest(isToggleVisibility)
      isOpenDropdownDifferentToClickTarget = isAnotherDropdownOpen and togvisParent.get(0) != @trigger.get(0) and togvisParent.get(0) != @target.get(0)
      if isAnotherDropdownOpen and isOpenDropdownDifferentToClickTarget
        @hide()

  toggleTarget: (trigger) =>
    target = @getTarget(trigger)

    isActive = target.hasClass @isActiveClass
    if isActive
      @hide trigger, target
    else
      @show trigger, target

    unless trigger.attr('toggle-visibility-drop-down') == 'false'
      @trigger = trigger
      @target = target

  hide: (trigger = @trigger, target = @target) =>
    trigger
      .removeClass(@isActiveClass)
      .attr('aria-expanded', false)

    target.removeClass @isActiveClass

    # Remove focus from input in target as it is hidden now
    target.find('input[type=text], input[type=search]').eq(0).blur()

    # Trigger an event so other javascript can do something when target is hidden
    trigger.trigger(@events.hide)

  closeAll: =>
    @hide()

  show: (trigger, target) =>
    # If there is another open tog vis instance and its not the one we're about to show, close it.
    isAnotherDropdownOpen = @trigger? and @target?
    if isAnotherDropdownOpen
      isOpenDropdownDifferentToCurrentTarget = @trigger.get(0) != trigger.get(0) and @target.get(0) != target.get(0)
      if isOpenDropdownDifferentToCurrentTarget
        @hide @trigger, @target
        @trigger = null
        @target = null

    trigger
      .addClass(@isActiveClass)
      .attr('aria-expanded', true)
    target.addClass @isActiveClass

    # Trigger an event so other javascript can do something when target is shown
    trigger.trigger(@events.show)

$ =>
  @TogVis = new ToggleVisibility()