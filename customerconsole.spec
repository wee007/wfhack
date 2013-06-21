Summary:     Westfield Customer Console
Name:        wf-customerconsole
Version:     0.0.131
Release:     1%{?%dist}
Group:       Applications/Databases
License:     Proprietary
URL:         %{BUILD_URL}
Source0:     %{name}-%{version}.tar.gz
Vendor:      Westfield Labs
AutoReqProv: no

# Requirements
BuildRequires: git
# Required for rake tasks (needs a javascript library)
BuildRequires: nodejs
BuildArch:     noarch

%define rail_home %{_var}/www
%define appdir %{_var}/www/customerconsole

# need to disable debug_package, otherwise the RPM won't build
%define debug_package %{nil}

%description
Customer Console

%prep
%setup -q

%build
 cd ${RPM_BUILD_DIR}/*
 bundle exec rake assets:precompile
 bundle install --path=vendor/bundler_gems --without development test

%install
 mkdir -p ${RPM_BUILD_ROOT}%{appdir}/current
 mkdir -p ${RPM_BUILD_ROOT}%{appdir}/current/tmp
 mkdir -p ${RPM_BUILD_ROOT}%{appdir}/current/tmp/cache
 mkdir -p ${RPM_BUILD_ROOT}%{appdir}/current/tmp/sessions
 mkdir -p ${RPM_BUILD_ROOT}%{appdir}/current/tmp/sockets

 cd ${RPM_BUILD_DIR}/*
 cp -va app config config.ru lib public vendor Rakefile Gemfile \
       Gemfile.lock .bundle ${RPM_BUILD_ROOT}%{appdir}/current/

%clean
rm -rf ${RPM_BUILD_ROOT}

%post
ln -sfT %{appdir}/shared/log %{appdir}/current/log
ln -sfT %{appdir}/shared/pids %{appdir}/current/tmp/pids
touch %{appdir}/current/tmp/restart.txt

%preun
if [ $1 = 0 ] ; then
  rm -rf %{appdir}/current/tmp/restart.txt
fi

%postun
if [ $1 = 0 ] ; then
  rm -rf %{appdir}
fi

%files
%defattr(644,root,root,755)
%{appdir}/current
%attr(755,nobody,nobody)%{appdir}/current/tmp

%changelog
* Sat Jun 22 2013 ci <doperations@au.westfield.com> 0.0.131-1
- Merge pull request #44 from ewee/master (ldewey@au.westfield.com)
- Show today's trading hour for a centre (ewee@au.westfield.com)

* Sat Jun 22 2013 ci <doperations@au.westfield.com> 0.0.130-1
- Merge pull request #45 from cpearce/master (ldewey@au.westfield.com)
- tweaks after device testing (CPearce@au.westfield.com)
- removing redundant iOS style (CPearce@au.westfield.com)
- aligning the primary nav icons better for iOS (CPearce@au.westfield.com)
- applying updates to header after design review (CPearce@au.westfield.com)

* Fri Jun 21 2013 ci <doperations@au.westfield.com> 0.0.129-1
- Fix facets and product styles (cwalsh2@au.westfield.com)

* Fri Jun 21 2013 ci <doperations@au.westfield.com> 0.0.128-1
- Add trading hours link and add temp inline css on trading hours page for
  showcasing (ewee@au.westfield.com)

* Fri Jun 21 2013 ci <doperations@au.westfield.com> 0.0.127-1
- Merge pull request #42 from ldewey/master (cwalsh2@au.westfield.com)
- Deal tile WIP, should not error any more tho. (ldewey@au.westfield.com)

* Fri Jun 21 2013 ci <doperations@au.westfield.com> 0.0.126-1
- Update old-ie.scss (ldewey@au.westfield.com)

* Fri Jun 21 2013 ci <doperations@au.westfield.com> 0.0.125-1
- tweaks for mobile menu toggle (CPearce@au.westfield.com)
- removing the toggle to change header position (CPearce@au.westfield.com)
- moving the global search field under the toggle button for palm devices
  (CPearce@au.westfield.com)
- creating new header partial and adding centre home page headerstyles and
  markup (CPearce@au.westfield.com)
- updating toggle menu/search plugins from static build
  (CPearce@au.westfield.com)
- increasing header padding for tablet/desktop views (CPearce@au.westfield.com)

* Thu Jun 20 2013 ci <doperations@au.westfield.com> 0.0.124-1
- Merge pull request #40 from ldewey/master (ldewey@au.westfield.com)
- Added accessibility enhancements. (ldewey@au.westfield.com)
- Added centre homepage link to header (ldewey@au.westfield.com)
- Adding the national layout (ldewey@au.westfield.com)
- Removed the main wrap on yield (ldewey@au.westfield.com)
- Removed centre layout from national page. (ldewey@au.westfield.com)
- Made the nav links active when they need to be (ldewey@au.westfield.com)
- Added event detail and Stream / Pinboard (ldewey@au.westfield.com)
- Added "stub" lightbox check (ldewey@au.westfield.com)
- Copied JS from front end project (ldewey@au.westfield.com)
- Copied styles from front end project (ldewey@au.westfield.com)
- Added a root path (ldewey@au.westfield.com)

* Wed Jun 19 2013 ci <doperations@au.westfield.com> 0.0.123-1
- Merge pull request #39 from cpearce/master (ldewey@au.westfield.com)
- removing testing styles from header and fixing hero img paths
  (CPearce@au.westfield.com)

* Wed Jun 19 2013 ci <doperations@au.westfield.com> 0.0.122-1
- Merge pull request #38 from cpearce/master (ldewey@au.westfield.com)
- completed html/css for centre home page header mobile view
  (CPearce@au.westfield.com)
- adding centre home page header hero images (CPearce@au.westfield.com)
- updating Google Lato font to 300 weight (CPearce@au.westfield.com)

* Wed Jun 19 2013 ci <doperations@au.westfield.com> 0.0.121-1
- Merge pull request #36 from cpearce/master (ldewey@au.westfield.com)
- Move interim styles to the hall of shame (cwalsh2@au.westfield.com)
- Add scrollbars to filtered facets (cwalsh2@au.westfield.com)
- Allow filtering with numbers (cwalsh2@au.westfield.com)
- Facet values can now be filtered (cwalsh2@au.westfield.com)
- adding favicons (CPearce@au.westfield.com)
- updating the stylesheet_path to application (CPearce@au.westfield.com)
- removing jquery library CDN (CPearce@au.westfield.com)
- adding a helper to output class for centre home page header
  (CPearce@au.westfield.com)
- adding jquery library (CPearce@au.westfield.com)

* Tue Jun 18 2013 ci <doperations@au.westfield.com> 0.0.120-1
- Merge pull request #35 from cpearce/master (cpearce@au.westfield.com)
- updating main import to application (CPearce@au.westfield.com)
- Functional price slider (cwalsh2@au.westfield.com)
- Merge pull request #33 from mwratt/rename/application.css
  (cpearce@au.westfield.com)
- Merge pull request #34 from cpearce/master (cpearce@au.westfield.com)
- adding old IE style sheet to app (CPearce@au.westfield.com)
- renames .scss to .css.scss to follow convention (matt.wratt@trineo.co.nz)
- removing header hero banner images and renaming dir name
  (CPearce@au.westfield.com)

* Tue Jun 18 2013 ci <doperations@au.westfield.com> 0.0.119-1
- Redirect styleguide to /styleguides (cwalsh2@au.westfield.com)

* Tue Jun 18 2013 ci <doperations@au.westfield.com> 0.0.118-1
- Test building assets before packaging gems (cwalsh2@au.westfield.com)

* Tue Jun 18 2013 ci <doperations@au.westfield.com> 0.0.117-1
- Require jquery.ui.slider styles (cwalsh2@au.westfield.com)
- Remove utf-8 declaration (added automatically) - allows require to work
  (cwalsh2@au.westfield.com)
- yield to per-page javascript (cwalsh2@au.westfield.com)
- Require jquery.ui.slider correctly (cwalsh2@au.westfield.com)

* Tue Jun 18 2013 ci <doperations@au.westfield.com> 0.0.116-1
- Add jquery.ui.slider back (cwalsh2@au.westfield.com)

* Tue Jun 18 2013 ci <doperations@au.westfield.com> 0.0.115-1
- Added facet summary view (cwalsh2@au.westfield.com)
- No need to munge the applied_filters (cwalsh2@au.westfield.com)

* Tue Jun 18 2013 ci <doperations@au.westfield.com> 0.0.114-1
- Updated image paths (ben@germanforblack.com)
- Added jquery slider (ben@germanforblack.com)
- Remove duped styles (ben@germanforblack.com)
- Moved layout from frontend_framework (ben@germanforblack.com)
- Copied over style guide views (ben@germanforblack.com)
- Copied over new styles from frontend_framework (ben@germanforblack.com)
- Use kneath/canonical kss (ben@germanforblack.com)
- Copied over assets from frontend_framework. These will need updating after
  the PR is merged. (ben@germanforblack.com)
- Added controller & route to catch & serve style guide * Added views for the
  style guide and copied over Chris' styling * Added abstractions demo
  (ben@germanforblack.com)
- Added KSS gem (Hosted on my repository until a couple of PR's drop)
  (ben@germanforblack.com)
- Added styleguides.yml to configure the style guide navigation. * Initialiser
  to load the yml (ben@germanforblack.com)
- Added live-reload support. * Rack live reload is added only in development
  mode (no browser plugins required) (ben@germanforblack.com)

* Tue Jun 18 2013 ci <doperations@au.westfield.com> 0.0.113-1
- jQuery-UI: only require slider, not everything (cwalsh2@au.westfield.com)
- Add a price slider, need to hook it up to do something.
  (cwalsh2@au.westfield.com)
- Add jQuery UI (cwalsh2@au.westfield.com)
- Basic HTML to support the new facet nav design (cwalsh2@au.westfield.com)
- Don't discard info from applied_filters (cwalsh2@au.westfield.com)

* Mon Jun 17 2013 ci <doperations@au.westfield.com> 0.0.112-1
-

* Thu Jun 13 2013 ci <doperations@au.westfield.com> 0.0.111-1
- On sale facet (cwalsh2@au.westfield.com)
- Display sale price on products (cwalsh2@au.westfield.com)
- Remove duplicate empty params (cwalsh2@au.westfield.com)
- Add sort options to product browse (cwalsh2@au.westfield.com)
- Basic pagination (cwalsh2@au.westfield.com)

* Thu Jun 13 2013 ci <doperations@au.westfield.com> 0.0.110-1
- Fix centre service to work without a root node (cwalsh2@au.westfield.com)

* Thu Jun 13 2013 ci <doperations@au.westfield.com> 0.0.109-1
- Update rails to 4.0.0.rc2 (cwalsh2@au.westfield.com)

* Wed Jun 12 2013 ci <doperations@au.westfield.com> 0.0.108-1
- Delete appropriate facets when removing applied categories
  (cwalsh2@au.westfield.com)
- Make applied category facet tag render a link with data attributes
  (cwalsh2@au.westfield.com)
- Add the applied_filters to the product search results
  (cwalsh2@au.westfield.com)
- Replace include_blank on facet tags (cwalsh2@au.westfield.com)
- More, shorter methods (cwalsh2@au.westfield.com)
- Basic category nav working, no ability to deselect categories yet
  (cwalsh2@au.westfield.com)
- Allow deselecting from single-value select boxes (cwalsh2@au.westfield.com)
- Filter out blank params before sending request to product service
  (cwalsh2@au.westfield.com)
- Extract facet_tag rendering to its own method (cwalsh2@au.westfield.com)

* Wed Jun 12 2013 ci <doperations@au.westfield.com> 0.0.107-1
- Slightly more coverage (cwalsh2@au.westfield.com)
- Add SimpleCov for spec coverage (cwalsh2@au.westfield.com)
- Clean up Gemfile (cwalsh2@au.westfield.com)

* Wed Jun 12 2013 ci <doperations@au.westfield.com> 0.0.106-1
- Merge pull request #25 from ewee/master (cwalsh2@au.westfield.com)
- Remove therubyracer (ewee@au.westfield.com)

* Tue Jun 11 2013 ci <doperations@au.westfield.com> 0.0.105-1
- Merge pull request #24 from ewee/master (ewee@au.westfield.com)
- Add therubyracer to test group only (ewee@au.westfield.com)

* Tue Jun 11 2013 ci <doperations@au.westfield.com> 0.0.104-1
- Remove therubyracer as using node.js (ewee@au.westfield.com)
- Add trading hours link to top nav (ewee@au.westfield.com)

* Tue Jun 11 2013 ci <doperations@au.westfield.com> 0.0.103-1
- Fix specs (cwalsh2@au.westfield.com)
- Basic navigation menu items (cwalsh2@au.westfield.com)
- Handle error conditions better - just return empty stream
  (cwalsh2@au.westfield.com)
- Add "product stream" (cwalsh2@au.westfield.com)

* Tue Jun 11 2013 ci <doperations@au.westfield.com> 0.0.102-1
- Create trading hours controller (ewee@au.westfield.com)
- Expose trading hours (ewee@au.westfield.com)

* Tue Jun 11 2013 ci <doperations@au.westfield.com> 0.0.101-1
- Basic last facet filtering (cwalsh2@au.westfield.com)
- Clean up (cwalsh2@au.westfield.com)
- Add store, brand and colour facets to product browse
  (cwalsh2@au.westfield.com)
- The very basics of product search (cwalsh2@au.westfield.com)
- Add chosen-rails (cwalsh2@au.westfield.com)

* Tue Jun 11 2013 ci <doperations@au.westfield.com> 0.0.100-1
- Added ServiceHelper (craigm.smith@au.westfield.com)

* Fri Jun 07 2013 ci <doperations@au.westfield.com> 0.0.99-1
- Show centres by state on home page (cwalsh2@au.westfield.com)
- Added per service overides (ldewey@au.westfield.com)
- Moved stores to use standard "service" (ldewey@au.westfield.com)
- Moved app_config into initializers so we dont have to require it
  (ldewey@au.westfield.com)

* Wed Jun 05 2013 ci <doperations@au.westfield.com> 0.0.98-1
- Make VCR hook in to faraday instead of webmock - otherwise all vcr playback
  tests fail (cwalsh2@au.westfield.com)
- Clean up movie service (cwalsh2@au.westfield.com)

* Wed Jun 05 2013 ci <doperations@au.westfield.com> 0.0.97-1
- Removed un needed gem (ldewey@au.westfield.com)
- Marking failing tests as pending (ldewey@au.westfield.com)
- Refactor per feedback. (ldewey@au.westfield.com)
- Added .env to the git ignore (ldewey@au.westfield.com)
- Cleaned up events (ldewey@au.westfield.com)
- Renamed HOST to API_HOST (ldewey@au.westfield.com)

* Wed Jun 05 2013 ci <doperations@au.westfield.com> 0.0.96-1
- WSF-4762 Don't tie requests to localhost. (craigm.smith@au.westfield.com)
- WSF-4762 Removed ROAR (craigm.smith@au.westfield.com)
- WSF-4762 Moved movie route up a little. (craigm.smith@au.westfield.com)
- WSF-4762 Removed ROAR from Customer Console. (craigm.smith@au.westfield.com)
- WSF-4762 Ensure movies display from the mocked API on the movies page.
  (craigm.smith@au.westfield.com)
- WSF-4762 First pass at movies in CC (craigm.smith@au.westfield.com)

* Wed Jun 05 2013 ci <doperations@au.westfield.com> 0.0.95-1
- Merge pull request #14 from mbamford/master (ldewey@au.westfield.com)
- Touch tmp/restart.txt on deployment (cwalsh2@au.westfield.com)
- Added Stores model, controller and index view (michael@michaelbamford.com)

* Wed Jun 05 2013 ci <doperations@au.westfield.com> 0.0.94-1
- Don't 500 if stream service adds new types (cwalsh2@au.westfield.com)

* Wed Jun 05 2013 ci <doperations@au.westfield.com> 0.0.93-1
- Use latest service_api from digital (cwalsh2@au.westfield.com)

* Wed Jun 05 2013 ci <doperations@au.westfield.com> 0.0.92-1
- Use latest service_api (cwalsh2@au.westfield.com)

* Tue Jun 04 2013 ci <doperations@au.westfield.com> 0.0.91-1
- Fix specs (cwalsh2@au.westfield.com)
- Use correct url for centre service (cwalsh2@au.westfield.com)
- Request stream service from its own host (cwalsh2@au.westfield.com)

* Tue Jun 04 2013 ci <doperations@au.westfield.com> 0.0.90-1
- Use latest faraday-http-cache and service_api (cwalsh2@au.westfield.com)
- Remove unused partial (cwalsh2@au.westfield.com)

* Tue Jun 04 2013 ci <doperations@au.westfield.com> 0.0.89-1
- Touch readme for tito/spec test (cwalsh2@au.westfield.com)
- Keep .bundle in rpm (cwalsh2@au.westfield.com)
- And the same for the stream (cwalsh2@au.westfield.com)
- Let it work in series not just parallel (cwalsh2@au.westfield.com)
- Make service API a bit cleaner by extracting common code to a concern
  (cwalsh2@au.westfield.com)
- Remove unnecessary code (cwalsh2@au.westfield.com)
- Use the service.build method to remove logic from the controller
  (cwalsh2@au.westfield.com)
- Basic fetching and display of stream and centre info in customer_console
  (cwalsh2@au.westfield.com)
- Fix gem source in Gemfile.lock (cwalsh2@au.westfield.com)
- Updated the gem source to "https://rubygems.org" (ldewey@au.westfield.com)
- Changed to use https://gems.dbg.westfield.com (ldewey@au.westfield.com)
- Added in basic event rendering (ldewey@au.westfield.com)
- Added service_api (cwalsh2@au.westfield.com)
- Whoops, don't ignore Gemfile.lock (cwalsh2@au.westfield.com)
- Added health_check (cwalsh2@au.westfield.com)
- Update gems (cwalsh2@au.westfield.com)
- More ignores (cwalsh2@au.westfield.com)

* Fri May 24 2013 ci <doperations@au.westfield.com> 0.0.88-1
-

* Fri May 24 2013 ci <doperations@au.westfield.com> 0.0.87-1
-

* Fri May 24 2013 ci <doperations@au.westfield.com> 0.0.86-1
-

* Fri May 24 2013 ci <doperations@au.westfield.com> 0.0.85-1
-

* Fri May 24 2013 ci <doperations@au.westfield.com> 0.0.84-1
-

* Fri May 24 2013 ci <doperations@au.westfield.com> 0.0.83-1
-

* Fri May 24 2013 ci <doperations@au.westfield.com> 0.0.82-1
-

* Fri May 24 2013 ci <doperations@au.westfield.com> 0.0.81-1
-

* Fri May 24 2013 ci <doperations@au.westfield.com> 0.0.80-1
-

* Fri May 24 2013 ci <doperations@au.westfield.com> 0.0.79-1
-

* Fri May 24 2013 ci <doperations@au.westfield.com> 0.0.78-1
-

* Fri May 24 2013 ci <doperations@au.westfield.com> 0.0.77-1
-

* Fri May 24 2013 ci <doperations@au.westfield.com> 0.0.76-1
-

* Fri May 24 2013 ci <doperations@au.westfield.com> 0.0.75-1
-

* Fri May 24 2013 ci <doperations@au.westfield.com> 0.0.74-1
-

* Fri May 24 2013 ci <doperations@au.westfield.com> 0.0.73-1
-

* Fri May 24 2013 ci <doperations@au.westfield.com> 0.0.72-1
-

* Fri May 24 2013 ci <doperations@au.westfield.com> 0.0.71-1
-

* Fri May 24 2013 ci <doperations@au.westfield.com> 0.0.70-1
-

* Fri May 24 2013 ci <doperations@au.westfield.com> 0.0.69-1
-

* Fri May 24 2013 ci <doperations@au.westfield.com> 0.0.68-1
-

* Fri May 24 2013 ci <doperations@au.westfield.com> 0.0.67-1
-

* Fri May 24 2013 ci <doperations@au.westfield.com> 0.0.66-1
-

* Fri May 24 2013 ci <doperations@au.westfield.com> 0.0.65-1
-

* Fri May 24 2013 ci <doperations@au.westfield.com> 0.0.64-1
-

* Fri May 24 2013 ci <doperations@au.westfield.com> 0.0.63-1
-

* Fri May 24 2013 ci <doperations@au.westfield.com> 0.0.62-1
-

* Fri May 24 2013 ci <doperations@au.westfield.com> 0.0.61-1
-

* Fri May 24 2013 ci <doperations@au.westfield.com> 0.0.60-1
-

* Fri May 24 2013 ci <doperations@au.westfield.com> 0.0.59-1
-

* Fri May 24 2013 ci <doperations@au.westfield.com> 0.0.58-1
-

* Fri May 24 2013 ci <doperations@au.westfield.com> 0.0.57-1
-

* Fri May 24 2013 ci <doperations@au.westfield.com> 0.0.56-1
-

* Fri May 24 2013 ci <doperations@au.westfield.com> 0.0.55-1
-

* Fri May 24 2013 ci <doperations@au.westfield.com> 0.0.54-1
-

* Fri May 24 2013 ci <doperations@au.westfield.com> 0.0.53-1
-

* Fri May 24 2013 ci <doperations@au.westfield.com> 0.0.52-1
-

* Fri May 24 2013 ci <doperations@au.westfield.com> 0.0.51-1
-

* Fri May 24 2013 ci <doperations@au.westfield.com> 0.0.50-1
-

* Fri May 24 2013 ci <doperations@au.westfield.com> 0.0.49-1
-

* Fri May 24 2013 ci <doperations@au.westfield.com> 0.0.48-1
-

* Fri May 24 2013 ci <doperations@au.westfield.com> 0.0.47-1
-

* Fri May 24 2013 ci <doperations@au.westfield.com> 0.0.46-1
-

* Fri May 24 2013 ci <doperations@au.westfield.com> 0.0.45-1
-

* Fri May 24 2013 ci <doperations@au.westfield.com> 0.0.44-1
-

* Fri May 24 2013 ci <doperations@au.westfield.com> 0.0.43-1
-

* Fri May 24 2013 ci <doperations@au.westfield.com> 0.0.42-1
-

* Fri May 24 2013 ci <doperations@au.westfield.com> 0.0.41-1
-

* Fri May 24 2013 ci <doperations@au.westfield.com> 0.0.40-1
-

* Fri May 24 2013 ci <doperations@au.westfield.com> 0.0.39-1
-

* Fri May 24 2013 ci <doperations@au.westfield.com> 0.0.38-1
-

* Fri May 24 2013 ci <doperations@au.westfield.com> 0.0.37-1
-

* Fri May 24 2013 ci <doperations@au.westfield.com> 0.0.36-1
-

* Fri May 24 2013 ci <doperations@au.westfield.com> 0.0.35-1
-

* Fri May 24 2013 ci <doperations@au.westfield.com> 0.0.34-1
-

* Fri May 24 2013 ci <doperations@au.westfield.com> 0.0.33-1
-

* Fri May 24 2013 ci <doperations@au.westfield.com> 0.0.32-1
-

* Fri May 24 2013 ci <doperations@au.westfield.com> 0.0.31-1
-

* Fri May 24 2013 ci <doperations@au.westfield.com> 0.0.30-1
-

* Fri May 24 2013 ci <doperations@au.westfield.com> 0.0.29-1
-

* Fri May 24 2013 ci <doperations@au.westfield.com> 0.0.28-1
-

* Fri May 24 2013 ci <doperations@au.westfield.com> 0.0.27-1
-

* Fri May 24 2013 ci <doperations@au.westfield.com> 0.0.26-1
-

* Fri May 24 2013 ci <doperations@au.westfield.com> 0.0.25-1
-

* Fri May 24 2013 ci <doperations@au.westfield.com> 0.0.24-1
-

* Fri May 24 2013 ci <doperations@au.westfield.com> 0.0.23-1
-

* Fri May 24 2013 ci <doperations@au.westfield.com> 0.0.22-1
-

* Fri May 24 2013 ci <doperations@au.westfield.com> 0.0.21-1
-

* Fri May 24 2013 ci <doperations@au.westfield.com> 0.0.20-1
-

* Fri May 24 2013 ci <doperations@au.westfield.com> 0.0.19-1
-

* Fri May 24 2013 ci <doperations@au.westfield.com> 0.0.18-1
-

* Fri May 24 2013 ci <doperations@au.westfield.com> 0.0.17-1
-

* Fri May 24 2013 ci <doperations@au.westfield.com> 0.0.16-1
-

* Fri May 24 2013 ci <doperations@au.westfield.com> 0.0.15-1
-

* Fri May 24 2013 ci <doperations@au.westfield.com> 0.0.14-1
-

* Fri May 24 2013 ci <doperations@au.westfield.com> 0.0.13-1
-

* Fri May 24 2013 ci <doperations@au.westfield.com> 0.0.12-1
-

* Fri May 24 2013 ci <doperations@au.westfield.com> 0.0.11-1
-

* Fri May 24 2013 ci <doperations@au.westfield.com> 0.0.10-1
-

* Fri May 24 2013 ci <doperations@au.westfield.com> 0.0.9-1
-

* Fri May 24 2013 ci <doperations@au.westfield.com> 0.0.8-1
-

* Fri May 24 2013 ci <doperations@au.westfield.com> 0.0.7-1
-

* Fri May 24 2013 ci <doperations@au.westfield.com> 0.0.6-1
-

* Fri May 24 2013 ci <doperations@au.westfield.com> 0.0.5-1
-

* Fri May 24 2013 ci <doperations@au.westfield.com> 0.0.4-1
- add rpm build script (doperations@au.westfield.com)
- update spec (doperations@au.westfield.com)

* Fri May 24 2013 ci <doperations@au.westfield.com>
- update spec (doperations@au.westfield.com)

* Fri May 24 2013 ci <doperations@au.westfield.com> 0.0.2-1
-

* Tue May 21 2013 Peter McInerney <pmcinerney@au.westfield.com> 0.0.1-1
- new package built with tito

* Wed May 09 2013 Leon Dewey <ldewey@au.westfield.com> 0.0.1
- Created initial.
