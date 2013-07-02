Modernizr.addTest('ipad', function () {
  return !!navigator.userAgent.match(/iPad/i);
});

Modernizr.addTest('iphone', function () {
  return !!navigator.userAgent.match(/iPhone/i);
});

Modernizr.addTest('ipod', function () {
  return !!navigator.userAgent.match(/iPod/i);
});

Modernizr.addTest('appleios', function () {
  return (Modernizr.ipad || Modernizr.ipod || Modernizr.iphone);
});

// basic android test based on user agent string
Modernizr.addTest('android', function () {
  return !!navigator.userAgent.match(/android/i);
});

// android v2 test
Modernizr.addTest('androidv2', function () {
  androidV2 = false;
  androidStart = navigator.userAgent.indexOf('Android ');
  androidVer = navigator.userAgent.substr(androidStart+8,1);

  return (androidVer <= 2);
});