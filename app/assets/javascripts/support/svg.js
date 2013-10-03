if (!Modernizr.svg) {
  // Replace SVG logo with PNG version for non-supporting browsers (Non JS support: http://www.noupe.com/tutorial/svg-clickable-71346.html - last technique)
  $('img[data-svg-fallback]').each(function() {
    $(this).attr('src', $(this).data('svgFallback'));
  });
}
