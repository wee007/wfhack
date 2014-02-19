/*
 * User-agent sniffing to detect devices
 */

// iPAD
Modernizr.addTest('ipad', function () {
  return !!navigator.userAgent.match(/iPad/i);
});

// iPhone
Modernizr.addTest('iphone', function () {
  return !!navigator.userAgent.match(/iPhone/i);
});

// iPod
Modernizr.addTest('ipod', function () {
  return !!navigator.userAgent.match(/iPod/i);
});

// iOS
Modernizr.addTest('ios', function () {
  return (Modernizr.ipad || Modernizr.ipod || Modernizr.iphone);
});

// Android
Modernizr.addTest('android', function () {
  return !!navigator.userAgent.match(/android/i);
});