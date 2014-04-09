# Toggles the visibility of elements
# Usage:
#   <div class="toggle-visibility" toggle-visibility="id_of_element_to_be_toggled"></div>

class @ToggleVisibility
  isActiveClass: 'is-active'
  triggerSelector: '[toggle-visibility]'
  targetSelector: 'js-toggle-visibility-target'
  constructor: ->
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
    doc = $(document)
    @triggers.click ->
      self.toggleTarget $(@)

    # Escape key closes the target and stops event from bubbling to document
    doc.keydown (event) =>
      if event.keyCode == 27
        event.stopPropagation()
        @hide()

    # Click outside of target
    doc.click (event) =>
      # Only execute if click was not on a tog vis trigger or target
      isToggleVisibility = "#{@triggerSelector}, .#{@targetSelector}"
      if $(event.target).parents(isToggleVisibility).length == 0 && !$(event.target).is(isToggleVisibility)
        debugger
        @hide()

  toggleTarget: (trigger) =>
    debugger
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
      .attr('attr-expanded', false)

    target.removeClass @isActiveClass

    # Remove focus from input in target as it is hidden now
    target.find('input[type=text], input[type=search]').eq(0).blur()

  show: (trigger, target) =>
    # If there is another open tog vis instance and its not the one we're about to show, close it.
    if @trigger? and @target? and @trigger.get(0) != trigger.get(0) and @target.get(0) != target.get(0)
      @hide @trigger, @target
      @trigger = null
      @target = null

    trigger
      .addClass(@isActiveClass)
      .attr('attr-expanded', true)
    target.addClass @isActiveClass


$ ->
  new ToggleVisibility()