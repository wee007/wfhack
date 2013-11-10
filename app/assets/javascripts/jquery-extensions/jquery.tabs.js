/*
 * Tabs plugin
 * @desc		used for the UI tabs pattern
 * @initialise	$('.tabs').tabs();
 */
$.fn.tabs = function() {

	var tabs = $(this);

	// For each tabs
	tabs.each(function() {

		// Set variables
		var tabHref,
			tabId,
			thisTabPages = $(this),
			tabNav = $('.tab__nav', this).attr('role', 'tablist'),
			tabPanels = $('.tab__content', this).attr({'role' : 'tabpanel', 'aria-hidden' : 'true', 'aria-expanded' : 'false'});

		// For each tab nav item
		$('li > a', tabNav).each(function(index) {

			// Get `href` of tab nav item as tabs `id`
			tabHref = $(this).attr('href').slice(1);

			// Create a unique `id` using the tab nav `href`
			tabId = $(this).attr('href').slice(1)+'-nav';

			// Set ARIA and `tabindex` attr's
			$(this).attr({'id' : tabId, 'role' : 'tab', 'aria-selected' : 'false', 'tabindex' : '-1'}).parent('li').attr('role', 'presentation');

			// Pair up the tab panel to the tab nav item using `aria-labelledby`
			tabPanels.eq(index).attr('aria-labelledby', tabId);

			// Pair up the tab nav item to the tab panel using `aria-controls`
			$(this).attr('aria-controls', tabHref);

		})

		// Set attr's for selected tab nav item
		tabNav.find('li > a.is-active').attr({'aria-selected': 'true', 'tabindex' : '0'});

		// Set attr's for tab panel that's shown by default
		$(this).find('div.is-active').attr({'aria-hidden' : 'false', 'aria-expanded' : 'true'});

		// Click event for tab nav items
		$('li > a', tabNav).click(function(e) {

			// Prevent default behaviour of link
			e.preventDefault();

			var selectedTab = $(this).attr('href');

			// Set selected tab nav item as selected
			$('li > a[href="'+ selectedTab +'"]', tabNav).parents('ul').find('a').removeClass('is-active').attr({'aria-selected' : 'false', 'tabindex' : '-1'});
			$('li > a[href="'+ selectedTab +'"]', tabNav).parents('li').find('a').addClass('is-active').attr({'aria-selected' : 'true', 'tabindex' : '0'});

			// Set selected tab panel as selected
			$('.tab__content' + selectedTab, thisTabPages).parent().children('.tab__content').removeClass('is-active').attr({'aria-hidden' : 'true', 'aria-expanded' : 'false'});
			$('.tab__content' + selectedTab, thisTabPages).addClass('is-active').attr({'aria-hidden' : 'false', 'aria-expanded' : 'true'});

		});

		// Keyboard navigation
		tabNav.delegate('a', 'keydown', function(e) {

			// If left arrow key
			if (e.keyCode == 37) {

				// If there's another tab nav item before the selected tab
				if ($(this).parent().prev().length != 0) {

					$(this).parent().prev().children('a').focus().click();

				}
				// Reached the first tab, go select the last tab
				else {

					tabNav.find('li:last > a').focus().click();

				}
			}

			// If right arrow key
			if (e.keyCode == 39) {

				// If there's another tab nav item after the selected tab
				if ($(this).parent().next().length != 0) {

					$(this).parent().next().children('a').focus().click();

				}
				// Reached the last tab, go select the first tab
				else {

					tabNav.find('li:first > a').focus().click();

				}
			}
		});
	});
}