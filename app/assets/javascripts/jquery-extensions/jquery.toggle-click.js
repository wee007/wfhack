/*
 * Generic toggle function via click event
 * @desc		used to have toggle functions on click event as the toggle() function is deprecated in 1.9+
 * @initialise	$('selector').toggleClick( function1, function2, ... );
 * @credit/ref	http://stackoverflow.com/questions/14382857/what-to-use-instead-of-toggle-in-jquery-1-8
 */
$.fn.toggleClick = function() {
    var methods = arguments, // Store the passed arguments for future reference
        count = methods.length; // Cache the number of methods

    // Use return this to maintain jQuery chainability
    return this.each(function(i, item){
        // For each element you bind to create a local counter for that element
        var index = 0;

        // Bind a click handler to that element that when called will apply the 'index' th method to that element
        $(item).click(function(){
            // The index % count means that we constrain our iterator between 0 and (count-1)
            return methods[index++ % count].apply(this,arguments);
        });
    });
};