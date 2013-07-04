// This file has been customised by @cpearce to include fixes
// for accessibility.

/* ============================================================
 * bootstrap-dropdown.js v2.1.1
 * http://twitter.github.com/bootstrap/javascript.html#dropdowns
 * ============================================================
 * Copyright 2012 Twitter, Inc.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 * ============================================================ */
!function ($) {

  'use strict'; // jshint ;_;

  /* DROPDOWN CLASS DEFINITION
  * ========================= */

  var toggle = '.js-drop-down-trigger'
  , Dropdown = function (element) {
    var $el = $(element).on('click.dropdown.data-api', this.toggle)
    $('html').on('click.dropdown.data-api', function () {
      $el.parent().removeClass('is-active')
    })
    }

  var toggleParent = $('.js-drop-down-trigger').parent();

  // EDIT: add the `tabindex="-1"` attr to links in drop down menu
  //$('.js-drop-down a').attr('tabindex', '-1');

  Dropdown.prototype = {

    constructor: Dropdown

    , toggle: function (e) {

      var $this = $(this)
      , $parent
      , $dropDown
      , isActive

      // EDIT: changed the class selector to `.is-disabled`
      if ($this.is('.is-disabled, :disabled')) return

        $parent = getParent($this)

        $dropDown = $this.next();

        isActive = $parent.hasClass('is-active')

        clearMenus()

        if (!isActive) {
          $parent.toggleClass('is-active')
          $this.focus()
        }

        return false

    }

    , keydown: function (e) {

      var $this
      , $items
      , $active
      , $parent
      , isActive
      , index

      if (!/(38|40|27)/.test(e.keyCode)) return

        $this = $(this)

        e.preventDefault()
        e.stopPropagation()

        // EDIT: changed the class selector to `.is-disabled`
        if ($this.is('.is-disabled, :disabled')) return

        $parent = getParent($this)

        isActive = $parent.hasClass('is-active')

        if (!isActive || (isActive && e.keyCode == 27)) return $this.click()

        $items = $('.js-drop-down a', $parent)

        if (!$items.length) return

        index = $items.index($items.filter(':focus'))

        if (e.keyCode == 38 && index > 0) index--                  // up
        if (e.keyCode == 40 && index < $items.length - 1) index++  // down
        if (!~index) index = 0

        $items
        .eq(index)
        .focus()

    }

  }

    function clearMenus() {
      $(toggle).each(function () {
        getParent($(this)).removeClass('is-active')
      })
    }

    function getParent($this) {
      var selector = $this.attr('data-target')
      , $parent

    if (!selector) {
      selector = $this.attr('href')
      selector = selector && /#/.test(selector) && selector.replace(/.*(?=#[^\s]*$)/, '') //strip for ie7
    }

    $parent = $(selector)
    $parent.length || ($parent = $this.parent())

    return $parent

  }


  /* DROPDOWN PLUGIN DEFINITION
  * ========================== */

  $.fn.dropdown = function (option) {
    return this.each(function () {
        var $this = $(this)
      , data = $this.data('dropdown')
        if (!data) $this.data('dropdown', (data = new Dropdown(this)))
        if (typeof option == 'string') data[option].call($this)
    })
  }

  $.fn.dropdown.Constructor = Dropdown


  /* APPLY TO STANDARD DROPDOWN ELEMENTS
  * =================================== */

  $(function () {
    $('html').on('click.dropdown.data-api touchstart.dropdown.data-api', clearMenus)
    $('body')
    .on('click.dropdown touchstart.dropdown.data-api', '.js-drop-down form', function (e) { e.stopPropagation() })
    .on('click.dropdown.data-api touchstart.dropdown.data-api'  , toggle, Dropdown.prototype.toggle)
    .on('keydown.dropdown.data-api touchstart.dropdown.data-api', toggle + ', .js-drop-down' , Dropdown.prototype.keydown)
  })

}(window.jQuery);
// Fix for touch devices to stop closing the drop down when selecting a link: https://github.com/twitter/bootstrap/issues/4550 / http://alittlecode.com/fix-twitter-bootstraps-dropdown-menus-in-touch-screens/
$('body').on('touchstart.dropdown', '.js-drop-down', function (e) {e.stopPropagation();});