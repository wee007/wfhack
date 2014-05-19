/*
 * Wraps a `div` around any user generated tables
 * @desc        used to apply horizontal scroll bars for user generated tables so any wide tables can be viewed mainly on palm devices
 * @initialise  $('.user-generated-formatting table').tableHorizontalScroll();
 */
$.fn.tableHorizontalScroll = function() {
	this.wrap('<div class="table-horiz-scroll" />');
}