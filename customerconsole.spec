Summary:     Westfield Customer Console
Name:        wf-customerconsole
Version:     0.1.156
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
 bundle exec rake assets:precompile RAILS_ENV=production
 bundle exec rake cloudinary:sync_static RAILS_ENV=production
 bundle install --path=vendor/bundler_gems --without development test

%install
 mkdir -p ${RPM_BUILD_ROOT}%{appdir}/current
 mkdir -p ${RPM_BUILD_ROOT}%{appdir}/shared/log
 mkdir -p ${RPM_BUILD_ROOT}%{appdir}/current/tmp
 mkdir -p ${RPM_BUILD_ROOT}%{appdir}/current/tmp/cache
 mkdir -p ${RPM_BUILD_ROOT}%{appdir}/current/tmp/sessions
 mkdir -p ${RPM_BUILD_ROOT}%{appdir}/current/tmp/sockets
 %{__mkdir} -p %{buildroot}/%{_sysconfdir}/httpd/conf.d
 %{__install} -Dp -m0644 customer_console.conf %{buildroot}%{_sysconfdir}/httpd/conf.d/customer_console.conf


 cd ${RPM_BUILD_DIR}/*
 cp -va app config config.ru lib public vendor Rakefile Gemfile \
       Gemfile.lock .bundle .cloudinary.static .cloudinary.static.trash ${RPM_BUILD_ROOT}%{appdir}/current/

cp -va system/* ${RPM_BUILD_ROOT}/

%clean
rm -rf ${RPM_BUILD_ROOT}

%post
ln -sfT %{appdir}/shared/log %{appdir}/current/log
ln -sfT %{appdir}/shared/pids %{appdir}/current/tmp/pids
service httpd reload
touch %{appdir}/current/tmp/restart.txt

railsenv=`grep RailsEnv /etc/httpd/conf.d/0passenger.conf | head -1 | awk '{print $2}'`
if [[ "production" == $railsenv ]]; then
  app_name="Customer Console"
else
  app_name="Customer Console ($railsenv)"
fi

https_proxy=http://proxy.dbg.westfield.com:8080 curl -H "x-api-key:fcb397795639d33ca285aff6ce91844bcd9ed68dcca2a7f" -d "deployment[app_name]=$app_name" -d "deployment[description]=RPM deployment (@Leon)" -d "deployment[revision]=%{version}" -d "deployment[user]=`hostname -s`"  https://rpm.newrelic.com/deployments.xml

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
%attr(755,nobody,nobody)%{appdir}/shared
%attr(755,nobody,nobody)%{appdir}/current/tmp
%dir %{appdir}/shared/log
%config %{_sysconfdir}/httpd/conf.d/customer_console.conf
%config %{_sysconfdir}/
%attr(755,root,root) %{_sysconfdir}/


%changelog
* Fri Oct 18 2013 ci <doperations@au.westfield.com> 0.1.156-1
- Merge pull request #507 from ldewey/master (ldewey@au.westfield.com)
- Removing nav contextual in production only. (ldewey@au.westfield.com)
- Fixed product detail map/no map/not in center thing.
  (ldewey@au.westfield.com)
- Added "Westfield <centre_name>" to the available at list.
  (ldewey@au.westfield.com)

* Thu Oct 17 2013 ci <doperations@au.westfield.com> 0.1.155-1
- Merge pull request #506 from bschwarz/sitemaps (ldewey@au.westfield.com)
- Ensure that all environments are routed to the correct sitemap file
  (ben@germanforblack.com)

* Thu Oct 17 2013 ci <doperations@au.westfield.com> 0.1.154-1
- Merge pull request #504 from bschwarz/sitemaps (ben@germanforblack.com)
- Make upload success logging for spunk exactly the same
  (ben@germanforblack.com)
- Add global proxy (ben@germanforblack.com)
- Remove proxy (ben@germanforblack.com)

* Thu Oct 17 2013 ci <doperations@au.westfield.com> 0.1.153-1
- Merge pull request #503 from bschwarz/sitemaps (ldewey@au.westfield.com)
- Skip the link if we don't have the appropriate data (ben@germanforblack.com)

* Thu Oct 17 2013 ci <doperations@au.westfield.com> 0.1.152-1
- Swap display order of Bags and Beauty categories (malc.locke@trineo.co.nz)

* Thu Oct 17 2013 ci <doperations@au.westfield.com> 0.1.151-1
- Merge pull request #483 from mlocke/feature/wsf-4998
  (ldewey@au.westfield.com)
- Added ActiveCategoryNavController (ben@germanforblack.com)
- on locationChangeStart/Success update search results (ben@germanforblack.com)
- Remove additional newlines (ben@germanforblack.com)
- Remove additional space (ben@germanforblack.com)
- Move Products.loading to updateSearch() (ben@germanforblack.com)
- Fully reset search params when receiving them from document.location
  (ben@germanforblack.com)
- Remove conditional block and comments (malc.locke@trineo.co.nz)
- Add super_cat parameter to T2 category links (malc.locke@trineo.co.nz)
- Check children of super_cat for active category (malc.locke@trineo.co.nz)
- Make category section links into regular anchors (malc.locke@trineo.co.nz)
- Remove temporary styles (malc.locke@trineo.co.nz)
- Remove unicorn (malc.locke@trineo.co.nz)
- Add child categories to Shoes. (malc.locke@trineo.co.nz)
- Add T2 level categories to product browse nav (malc.locke@trineo.co.nz)
- Render hard coded list of super categories (malc.locke@trineo.co.nz)
- Return after handle_error (malc.locke@trineo.co.nz)
- Minimal instructions to run locally with foreman (malc.locke@trineo.co.nz)

* Thu Oct 17 2013 ci <doperations@au.westfield.com> 0.1.150-1
- Just generate and upload the sitemap, don't ping google and bing
  (ben@germanforblack.com)
- Rails logger, not pp (ben@germanforblack.com)
- Added proxy (ben@germanforblack.com)
- Replace calls to pp with Rails.logger (ben@germanforblack.com)

* Thu Oct 17 2013 ci <doperations@au.westfield.com> 0.1.149-1
- Updated search box placeholder text (ldewey@au.westfield.com)

* Wed Oct 16 2013 ci <doperations@au.westfield.com> 0.1.148-1
- Added no proxy for dev (ldewey@au.westfield.com)
- Added proxy suport to sitemap.xml.gz request (ldewey@au.westfield.com)

* Wed Oct 16 2013 ci <doperations@au.westfield.com> 0.1.147-1
- Merge pull request #472 from digital/sitemaps (ldewey@au.westfield.com)
- Add sitemap generation to cron daily (ben@germanforblack.com)
- Copy the system directory to the build root (ben@germanforblack.com)
- Point RPM to system directory and chmod (ben@germanforblack.com)
- Added cron placeholder directories (ben@germanforblack.com)
- Merge remote-tracking branch 'origin/master' into sitemaps
  (ben@germanforblack.com)
- Stream the sitemap / sitemap_index through rails (ben@germanforblack.com)
- Environments other than production will have the environment name prepended
  to the sitemap filename. (ben@germanforblack.com)
- Render dynamic robots.txt that has the final url for the sitemap * Remove
  public/robots.txt * Redirect any non-robots.txt respecting spider that tries
  to hit /sitemap.xml.gz to the cloudinary path (ben@germanforblack.com)
- Use the service helper configured url (ben@germanforblack.com)
- Changed link priorities based on feedback from Rohit (ben@germanforblack.com)
- Write exceptions to the rails log using SITEMAP (ben@germanforblack.com)
- Merge remote-tracking branch 'origin/master' into sitemaps
  (ben@germanforblack.com)
- No longer required now that there is a custom uploader
  (ben@germanforblack.com)
- Correct upload filename (as cloudinary does content negotiation
  automagically) Report the non-versioned url path of the final product
  (ben@germanforblack.com)
- Added custom adapter to automatically upload the file to cloudinary
  (ben@germanforblack.com)
- Environment is already loaded (ben@germanforblack.com)
- Don't run requests in parallel because it'll end up tripping over itself when
  it makes 70 requests at once. (ben@germanforblack.com)
- Added task to upload sitemap to cloudinary (ben@germanforblack.com)
- Added sitemap configuration * Builds centre urls for root, events, deals,
  movies, stores, hours, info, stores * Products at a national level
  (ben@germanforblack.com)
- Added sitemap generator gem (ben@germanforblack.com)

* Wed Oct 16 2013 ci <doperations@au.westfield.com> 0.1.146-1
- Merge pull request #489 from ldewey/master (ldewey@au.westfield.com)
- Updated the wait time of redirect page (ldewey@au.westfield.com)
- Cleaned up some of my sloppy code (ldewey@au.westfield.com)
- Fixes as per PR's. Made viewport check generic. (ldewey@au.westfield.com)
- Added national homepage centre images (ldewey@au.westfield.com)

* Wed Oct 16 2013 ci <doperations@au.westfield.com> 0.1.145-1
- Merge pull request #482 from fchan/more-fixes (ldewey@au.westfield.com)
- WSF-5520: Increased size of apple touch icon and removed old ones
  (fiona@fionachan.net)
- WSF-5758: Fix alignment of icon in hero banner (fiona@fionachan.net)
- WSF-5658: Remove space between 'am' and 'pm' and movie session time
  (fiona@fionachan.net)
- WSF-5675: Add icon--fixed-width to social icons on info page
  (fiona@fionachan.net)

* Wed Oct 16 2013 ci <doperations@au.westfield.com> 0.1.144-1
- Merge pull request #490 from acohen/feature/WSF-4921
  (ldewey@au.westfield.com)
- Merge pull request #491 from fchan/polish (ldewey@au.westfield.com)
- Fix PR after feedback. And change to .hero-gradient in header
  (fiona@fionachan.net)
- WSF-4921 add initializer to instanciate global redirection vars
  (acohen@au.westfield.com)
- WSF-4921 replace unused memoization with initializer
  (acohen@au.westfield.com)
- WSF-4921 add redirects for au/shopping (acohen@au.westfield.com)
- WSF-5779: Added no. of centres to national landing page (fiona@fionachan.net)
- Added gradient to national landing page (fiona@fionachan.net)
- Change to use cloudinary-url in national sass (fiona@fionachan.net)
- WSF-5772: Added time element to event tile (fiona@fionachan.net)
- WSF-5534: Added PDF icon (fiona@fionachan.net)
- WSF-5687: Increase national image to 1600px wide (fiona@fionachan.net)

* Wed Oct 16 2013 ci <doperations@au.westfield.com> 0.1.143-1
- Merge pull request #484 from gwshaw/feature/WSF-
  5071_click_thru_intermediate_page_using_javascript (ldewey@au.westfield.com)
- WSF-5071 click-thru intermediate page using javascript (g.w.shaw@comcast.net)

* Wed Oct 16 2013 ci <doperations@au.westfield.com> 0.1.142-1
- 

* Wed Oct 16 2013 ci <doperations@au.westfield.com> 0.1.141-1
- 

* Wed Oct 16 2013 ci <doperations@au.westfield.com> 0.1.140-1
- 

* Wed Oct 16 2013 ci <doperations@au.westfield.com> 0.1.139-1
- 

* Wed Oct 16 2013 ci <doperations@au.westfield.com> 0.1.138-1
- 

* Wed Oct 16 2013 ci <doperations@au.westfield.com> 0.1.137-1
- Handle case where products hash is incomplete. (malc.locke@trineo.co.nz)

* Wed Oct 16 2013 ci <doperations@au.westfield.com> 0.1.136-1
- 

* Wed Oct 16 2013 ci <doperations@au.westfield.com> 0.1.135-1
- 

* Wed Oct 16 2013 ci <doperations@au.westfield.com> 0.1.134-1
- 

* Wed Oct 16 2013 ci <doperations@au.westfield.com> 0.1.133-1
- 

* Wed Oct 16 2013 ci <doperations@au.westfield.com> 0.1.132-1
- 

* Tue Oct 15 2013 ci <doperations@au.westfield.com> 0.1.131-1
- 

* Tue Oct 15 2013 ci <doperations@au.westfield.com> 0.1.130-1
- 

* Tue Oct 15 2013 ci <doperations@au.westfield.com> 0.1.129-1
- Merge pull request #487 from ldewey/master (ldewey@au.westfield.com)
- New hero image updates (ldewey@au.westfield.com)

* Tue Oct 15 2013 ci <doperations@au.westfield.com> 0.1.128-1
- Merge pull request #486 from ldewey/master (ldewey@au.westfield.com)
- A fix/hack for rebinding angular directives. (ldewey@au.westfield.com)

* Tue Oct 15 2013 ci <doperations@au.westfield.com> 0.1.127-1
- Changing css images to use 'cloudinary-url' (CPearce@au.westfield.com)
- Moving all CSS images to Cloudinary (CPearce@au.westfield.com)
- Set all cloudinary images to use WebP format - WSF-5729
  (CPearce@au.westfield.com)
- Update 'Prefetch DNS for external assets' list - WSF-5735
  (CPearce@au.westfield.com)
- Compressing all SVG images - WSF-5135 (CPearce@au.westfield.com)

* Tue Oct 15 2013 ci <doperations@au.westfield.com> 0.1.126-1
- Merge pull request #475 from ewee/master (ldewey@au.westfield.com)
- Add check for cinema (ewee@au.westfield.com)

* Tue Oct 15 2013 ci <doperations@au.westfield.com> 0.1.125-1
- Merge pull request #481 from digital/canonical-links
  (ldewey@au.westfield.com)
- Merge pull request #480 from mwratt/feature/fix-selectivizr-js
  (ldewey@au.westfield.com)
- Use url rather than path (ben@germanforblack.com)
- Yield canonical links to national level products from centre pages' product
  pages (ben@germanforblack.com)
- removes bower install of selectivizr (public dir) (matt.wratt@trineo.co.nz)
- puts selectivizr in public avoiding minification (matt.wratt@trineo.co.nz)

* Tue Oct 15 2013 ci <doperations@au.westfield.com> 0.1.124-1
- Revert "Merge pull request #476 from mlocke/feature/wsf-4998"
  (malc.locke@trineo.co.nz)

* Tue Oct 15 2013 ci <doperations@au.westfield.com> 0.1.123-1
- Merge pull request #478 from jfantham/feature/WSF-4816
  (ldewey@au.westfield.com)
- WSF-4816 made the stream service parser handle unknown types
  (j.fantham@gmail.com)
- WSF-4816 added the canned search model (j.fantham@gmail.com)

* Tue Oct 15 2013 ci <doperations@au.westfield.com> 0.1.122-1
- Merge pull request #476 from mlocke/feature/wsf-4998
  (ldewey@au.westfield.com)
- Remove unicorn (malc.locke@trineo.co.nz)
- change l to L, in my name for New Relic message (ldewey@au.westfield.com)
- Set category instead of super_cat for filter type (malc.locke@trineo.co.nz)
- Add child categories to Shoes. (malc.locke@trineo.co.nz)
- Add is-active class to selected T1 category (malc.locke@trineo.co.nz)
- Convert to use Angular (malc.locke@trineo.co.nz)
- Add T2 level categories to product browse nav (malc.locke@trineo.co.nz)
- Render hard coded list of super categories (malc.locke@trineo.co.nz)
- Return after handle_error (malc.locke@trineo.co.nz)
- Minimal instructions to run locally with foreman (malc.locke@trineo.co.nz)
- Add unicorn to development env in Gemfile (malc.locke@trineo.co.nz)

* Tue Oct 15 2013 ci <doperations@au.westfield.com> 0.1.121-1
- Merge pull request #477 from cpearce/server-error-page-redesign
  (cpearce@au.westfield.com)
- Fixing broken path to stylesheet (CPearce@au.westfield.com)

* Tue Oct 15 2013 ci <doperations@au.westfield.com> 0.1.120-1
- bumped the version to try and fix CI. (ldewey@au.westfield.com)
- Merge pull request #473 from ldewey/master (ldewey@au.westfield.com)
- Added my name to the rpm release message (ldewey@au.westfield.com)
- Proper UI and styling for server error pages - WSF-5471
  (CPearce@au.westfield.com)

* Sat Oct 12 2013 ci <doperations@au.westfield.com> 0.1.118-1
- fixes pjax navigation on android (matt.wratt@trineo.co.nz)
- stabilizes map toggle across devices (matt.wratt@trineo.co.nz)
- fixes missing toggle button on storefront map (matt.wratt@trineo.co.nz)
- WSF-5665 fixes disappearing map on toggle issue (matt.wratt@trineo.co.nz)
- move map partials to micello_maps folder (matt.wratt@trineo.co.nz)

* Sat Oct 12 2013 ci <doperations@au.westfield.com> 0.1.117-1
- Fixes missing logos in map popups (matt.wratt@trineo.co.nz)

* Fri Oct 11 2013 ci <doperations@au.westfield.com> 0.1.116-1
- Merge pull request #466 from cpearce/UI-polish (matt.wratt@trineo.co.nz)
- Fixing conflicts in site header and grid css (CPearce@au.westfield.com)
- Restoring the filters to be hidden (CPearce@au.westfield.com)
- Remove store filters for store list when in map view at mobile/tablet size
  and add ARIA attr to applied filter count - WSF-5692
  (CPearce@au.westfield.com)
- Adding selectivizr as the path to the JS file was broke in all env's
  (CPearce@au.westfield.com)
- Fixing 2 links to use correct routes - WSF-5397 (CPearce@au.westfield.com)
- Make all relevant links in the site header have 'is-active' classes -
  WSF-5397 (CPearce@au.westfield.com)
- Fixing up a merge conflict and adding some missing comments to products index
  (CPearce@au.westfield.com)
- Adding 2 new links to site header and 1 link to national home page - WSF-5664
  (CPearce@au.westfield.com)
- Replacing link icon with shopping bag icon for product store click out link -
  WSF-5570 (CPearce@au.westfield.com)
- Fix the pin board bottom margin and general spacing for grids - WSF-5490
  (CPearce@au.westfield.com)
- Removing nav contextual inline initialisation as it is now global
  (CPearce@au.westfield.com)

* Fri Oct 11 2013 ci <doperations@au.westfield.com> 0.1.115-1
- Merge pull request #455 from ldewey/search (matt.wratt@trineo.co.nz)
- Fixups for search (ldewey@au.westfield.com)
- Ignore category in search, will bring it back later.
  (ldewey@au.westfield.com)
- Updates to search, so it works with the new search api data
  (ldewey@au.westfield.com)

* Fri Oct 11 2013 ci <doperations@au.westfield.com> 0.1.114-1
- Merge pull request #456 from fchan/centre-services (matt.wratt@trineo.co.nz)
- Update spacing class and clean up getting here section on centre info
  (fiona@fionachan.net)
- Fix comment (fiona@fionachan.net)
- Enable centre services link in header (fiona@fionachan.net)
- Fix spacing on centre services and info (fiona@fionachan.net)
- Added static images to cloudinary (fiona@fionachan.net)
- Fix images and promo tiles (fiona@fionachan.net)
- Fix centre services after PR feedback (fiona@fionachan.net)
- Fix merge problem on detail-view and minor fix on grid (fiona@fionachan.net)
- Fix promo tile and added temp mark up (fiona@fionachan.net)
- Get centre service data dynamically (ewee@au.westfield.com)
- Create centre services page (fiona@fionachan.net)

* Fri Oct 11 2013 ci <doperations@au.westfield.com> 0.1.113-1
- Merge pull request #467 from mwratt/feature/map_tweaks
  (matt.wratt@trineo.co.nz)
- disables arrow keys in map on product and deals (matt.wratt@trineo.co.nz)
- removes roads from maps (matt.wratt@trineo.co.nz)
- need to use the primary_image as it's a full url (matt.wratt@trineo.co.nz)
- WSF-5698 Fixes product images in beta (matt.wratt@trineo.co.nz)

* Thu Oct 10 2013 ci <doperations@au.westfield.com> 0.1.112-1
- Merge tag 'wf-customerconsole-0.1.111-1' of
  github.dbg.westfield.com:digital/customer_console (matt.wratt@trineo.co.nz)
- Merge pull request #458 from fchan/more-fixes (matt.wratt@trineo.co.nz)
- Merge pull request #457 from ewee/master (matt.wratt@trineo.co.nz)
- Fix comment (fiona@fionachan.net)
- Fix typo in comment (fiona@fionachan.net)
- Add page title and meta description of product faceted page
  (ewee@au.westfield.com)
- Merge pull request #463 from digital/seo-brands (matt.wratt@trineo.co.nz)
- Merge pull request #462 from digital/svg (matt.wratt@trineo.co.nz)
- Merge pull request #460 from gwshaw/feature/WSF-
  5481_phg_for_product_details_page (matt.wratt@trineo.co.nz)
- Added mrg-base class to the category ul (ben@germanforblack.com)
- Merge remote-tracking branch 'origin/master' into seo-brands
  (ben@germanforblack.com)
- Render the brands underneath categories (ben@germanforblack.com)
- Pull brands through controller (ben@germanforblack.com)
- Space for brevity (ben@germanforblack.com)
- Merge the hash! (ben@germanforblack.com)
- Fix background-position (fiona@fionachan.net)
- WSF-5481 phg for product details page (g.w.shaw@comcast.net)
- WSF-5687: Fix national hero image alignment in IE8 (fiona@fionachan.net)
- WSF-5382: Fix up ".txt-break-word" for Firefox (fiona@fionachan.net)
- WSF-5454: Fix logo distorted on deals tile on IE8 (fiona@fionachan.net)

* Thu Oct 10 2013 ci <doperations@au.westfield.com> 0.1.111-1
- Merge pull request #454 from mwratt/feature/WSF-5609-storefront-banner-resize
  (matt.wratt@trineo.co.nz)
- Merge pull request #448 from digital/static-pagination
  (matt.wratt@trineo.co.nz)
- fixed banner size as per spec (matt.wratt@trineo.co.nz)
- resizes storefront banner making it a jpg (matt.wratt@trineo.co.nz)
- resizes storefront banner images reducing size (matt.wratt@trineo.co.nz)
- Added stubs (ben@germanforblack.com)
- Added link rels (ben@germanforblack.com)
- Static, regular old HTML pagination for product browse
  (ben@germanforblack.com)

* Thu Oct 10 2013 ci <doperations@au.westfield.com> 0.1.110-1
- increases hero image resolution (matt.wratt@trineo.co.nz)

* Thu Oct 10 2013 ci <doperations@au.westfield.com> 0.1.109-1
- Removed, will look at this later. (craigm.smith@au.westfield.com)
- Merge pull request #453 from ldewey/images (matt.wratt@trineo.co.nz)
- Centre images! (ldewey@au.westfield.com)

* Wed Oct 09 2013 ci <doperations@au.westfield.com> 0.1.108-1
- WSF-5663: Added no-content-fallback-msg extender (fiona@fionachan.net)

* Wed Oct 09 2013 ci <doperations@au.westfield.com> 0.1.107-1
- Merge pull request #452 from mwratt/feature/WSF-4655-featured-products
  (ldewey@au.westfield.com)
- adds old school fileservice image support back (matt.wratt@trineo.co.nz)

* Wed Oct 09 2013 ci <doperations@au.westfield.com> 0.1.106-1
- Merge pull request #451 from digital/search-events (ldewey@au.westfield.com)
- Don't search when key up or down is pressed (ben@germanforblack.com)

* Wed Oct 09 2013 ci <doperations@au.westfield.com> 0.1.105-1
- 

* Wed Oct 09 2013 ci <doperations@au.westfield.com> 0.1.104-1
- Fixed timing issue in movies helper spec. (craigm.smith@au.westfield.com)
- recreated movie VCR (craigm.smith@au.westfield.com)
- Refactored choosing whether we should show T&C's or not.
  (craigm.smith@au.westfield.com)
- Don't show terms and conditions when there aren't any.
  (craigm.smith@au.westfield.com)

* Tue Oct 08 2013 ci <doperations@au.westfield.com> 0.1.103-1
- 

* Tue Oct 08 2013 ci <doperations@au.westfield.com> 0.1.102-1
- Merge pull request #442 from fchan/little-fixes (ldewey@au.westfield.com)
- Fixed national nav links (ldewey@au.westfield.com)
- Update datetime (fiona@fionachan.net)
- Fix up T&C and privacy policy (fiona@fionachan.net)
- Remove id from detail view header (fiona@fionachan.net)
- Enable links in national landing page footer and header dropdown
  (fiona@fionachan.net)
- Fix styles and reworked controller and routes for t&c and privacy policy
  (fiona@fionachan.net)
- Added Privacy Policy and updated T&C (fiona@fionachan.net)
- Added terms and conditions (fiona@fionachan.net)
- Fix PR after feedback (fiona@fionachan.net)
- Convert all tel: links to use new helper (fiona@fionachan.net)
- Fix spacing collapsing between contact us and follow us sections, and social
  links spacing (fiona@fionachan.net)

* Tue Oct 08 2013 ci <doperations@au.westfield.com> 0.1.101-1
- Merge pull request #436 from csmith/master (craigM.smith@au.westfield.com)
- New movie vcd details. (craigm.smith@au.westfield.com)
- Added a fallback for when there are not movies to display.
  (craigm.smith@au.westfield.com)
- Fixing specs (craigm.smith@au.westfield.com)
- Putting movies back in (craigm.smith@au.westfield.com)

* Tue Oct 08 2013 ci <doperations@au.westfield.com> 0.1.100-1
- Merge pull request #425 from mwratt/feature/WSF-4655-featured-products
  (ldewey@au.westfield.com)
- Merge pull request #443 from ewee/master (ldewey@au.westfield.com)
- Merge pull request #447 from cpearce/master (ldewey@au.westfield.com)
- Merge pull request #444 from cpearce/UI-polish (ldewey@au.westfield.com)
- Changing puma gem to thin (CPearce@au.westfield.com)
- Changing puma gem to thin (CPearce@au.westfield.com)
- Replace meta description content as store description is too long
  (ewee@au.westfield.com)
- Reposition Micello logo for detail view map and hide controls for IE8 -
  WSF-5600 (CPearce@au.westfield.com)
- Removing 'js-disabled-hide' class from product filters so search engines can
  crawl it and adding a msg for non JS users (CPearce@au.westfield.com)
- Removing JS to close site search as Angular Toggle Visibility directive can
  handle that (CPearce@au.westfield.com)
- Style product pagination - WSF-5634 (CPearce@au.westfield.com)
- Event detail view checks - WSF-5368 (CPearce@au.westfield.com)
- Update Deal tile and detail view typography - WSF-5444
  (CPearce@au.westfield.com)
- Restore search toggle for stores - WSF-5548 (CPearce@au.westfield.com)
- excludes product facets from request (matt.wratt@trineo.co.nz)
- pads featured product images to be the same height (matt.wratt@trineo.co.nz)
- adds featured products to store page (matt.wratt@trineo.co.nz)

* Mon Oct 07 2013 ci <doperations@au.westfield.com> 0.1.99-1
- Merge pull request #446 from ldewey/pin-board-ie-fix
  (ldewey@au.westfield.com)
- A pin board fix for IE8 (ldewey@au.westfield.com)
- Removed all of the search stuff so i can update search with out breaking
  things. (ldewey@au.westfield.com)

* Fri Oct 04 2013 ci <doperations@au.westfield.com> 0.1.98-1
- 

* Fri Oct 04 2013 ci <doperations@au.westfield.com> 0.1.97-1
- 

* Fri Oct 04 2013 ci <doperations@au.westfield.com> 0.1.96-1
- Merge pull request #441 from ldewey/auth (ldewey@au.westfield.com)
- Adding JS auth (ldewey@au.westfield.com)

* Fri Oct 04 2013 ci <doperations@au.westfield.com> 0.1.95-1
- 

* Fri Oct 04 2013 ci <doperations@au.westfield.com> 0.1.94-1
- Noscript disabled. (ben@germanforblack.com)

* Fri Oct 04 2013 ci <doperations@au.westfield.com> 0.1.93-1
- Merge pull request #439 from digital/seo-category-nav
  (ldewey@au.westfield.com)
- Create a magic object to stub the controller (ben@germanforblack.com)
- Merge remote-tracking branch 'origin/master' into seo-category-nav
  (ben@germanforblack.com)
- Render a category navigation for noscript/web spiders
  (ben@germanforblack.com)

* Fri Oct 04 2013 ci <doperations@au.westfield.com> 0.1.92-1
- 

* Fri Oct 04 2013 ci <doperations@au.westfield.com> 0.1.91-1
- 

* Fri Oct 04 2013 ci <doperations@au.westfield.com> 0.1.90-1
- 

* Fri Oct 04 2013 ci <doperations@au.westfield.com> 0.1.89-1
- 

* Fri Oct 04 2013 ci <doperations@au.westfield.com> 0.1.88-1
- Merge pull request #433 from cpearce/category-nav (ldewey@au.westfield.com)
- adds all stores to storefront for pjax navigation (matt.wratt@trineo.co.nz)
- fixes broken link and shopping hours (matt.wratt@trineo.co.nz)
- Fixing merge conflict and making nav contextual script initialisation global
  (CPearce@au.westfield.com)
- Finalising category nav (CPearce@au.westfield.com)
- WIP category nav (CPearce@au.westfield.com)
- WIP category nav (CPearce@au.westfield.com)
- WIP for category nav (CPearce@au.westfield.com)

* Thu Oct 03 2013 ci <doperations@au.westfield.com> 0.1.87-1
- Merge pull request #432 from digital/svg-png-fallback
  (ldewey@au.westfield.com)
- Merge pull request #431 from mwratt/feature/WSF-4655-tweaks-and-fixes
  (ldewey@au.westfield.com)
- Merge pull request #430 from digital/gemfile (ldewey@au.westfield.com)
- Merge remote-tracking branch 'origin/master' into svg-png-fallback
  (ben@germanforblack.com)
- default font size on maps (matt.wratt@trineo.co.nz)
- Use the data-* attribute for SVG replacement (ben@germanforblack.com)
- Added SVG—png fallback helper method (ben@germanforblack.com)
- unselects store when returning to store list (matt.wratt@trineo.co.nz)
- adds default zoom to maps (matt.wratt@trineo.co.nz)
- Re-cut the gem file lock so that service_api is updated
  (ben@germanforblack.com)
- Merge remote-tracking branch 'origin/master' (ben@germanforblack.com)
- Missing semi (ben@germanforblack.com)

* Thu Oct 03 2013 ci <doperations@au.westfield.com> 0.1.86-1
- 

* Thu Oct 03 2013 ci <doperations@au.westfield.com> 0.1.85-1
- 

* Thu Oct 03 2013 ci <doperations@au.westfield.com> 0.1.84-1
- Revert "Merge pull request #429 from csmith/feature/movies_polish"
  (craigm.smith@au.westfield.com)

* Wed Oct 02 2013 ci <doperations@au.westfield.com> 0.1.83-1
- 

* Wed Oct 02 2013 ci <doperations@au.westfield.com> 0.1.82-1
- Merge pull request #428 from fchan/add-links (matt.wratt@trineo.co.nz)
- Added in link to national product browse page (fiona@fionachan.net)

* Wed Oct 02 2013 ci <doperations@au.westfield.com> 0.1.81-1
- 

* Wed Oct 02 2013 ci <doperations@au.westfield.com> 0.1.80-1
- 

* Wed Oct 02 2013 ci <doperations@au.westfield.com> 0.1.79-1
- Tidied up the movies helper a little. (craigm.smith@au.westfield.com)
- Keeping code in line with the rest of CC. (craigm.smith@au.westfield.com)
- A little clean up. (craigm.smith@au.westfield.com)
- Fixed request spec. (craigm.smith@au.westfield.com)
- Updated hero.icon, code clean up and updated retailer code
  (fiona@fionachan.net)
- Set detail-view fixed width as default at iPad portrait (fiona@fionachan.net)
- Added new static assets to Cloudinary and check for images that don't load
  (fiona@fionachan.net)
- More fixes after code review (fiona@fionachan.net)
- Fixed timeline, enabled cinema link and fix mark up (fiona@fionachan.net)
- Worked movies show and index code in designed layouts.
  (craigm.smith@au.westfield.com)
- Fix up CSS for movies after code review (fiona@fionachan.net)
- Some cleanup of movies page (fiona@fionachan.net)
- Add and update image size (fiona@fionachan.net)
- Updated movie index and show page (fiona@fionachan.net)
- First commit of movies page (fiona@fionachan.net)

* Wed Oct 02 2013 ci <doperations@au.westfield.com> 0.1.78-1
- 

* Wed Oct 02 2013 ci <doperations@au.westfield.com> 0.1.77-1
- 

* Wed Oct 02 2013 ci <doperations@au.westfield.com> 0.1.76-1
- Merge pull request #427 from ewee/master (matt.wratt@trineo.co.nz)
- Add page title and meta description to products show page
  (ewee@au.westfield.com)

* Wed Oct 02 2013 ci <doperations@au.westfield.com> 0.1.75-1
- Merge pull request #426 from ewee/master (matt.wratt@trineo.co.nz)
- Add page title and meta description to products index page
  (ewee@au.westfield.com)

* Wed Oct 02 2013 ci <doperations@au.westfield.com> 0.1.74-1
- Merge pull request #424 from mwratt/feature/WSF-4655-tweaks-and-fixes
  (ldewey@au.westfield.com)
- Merge pull request #415 from ewee/master (ldewey@au.westfield.com)
- improves click handling on touch devices (matt.wratt@trineo.co.nz)
- Add separator to store and product counts (ewee@au.westfield.com)
- Add page title and meta description (ewee@au.westfield.com)
- updates storefront maps visual style (matt.wratt@trineo.co.nz)

* Tue Oct 01 2013 ci <doperations@au.westfield.com> 0.1.73-1
- 

* Tue Oct 01 2013 ci <doperations@au.westfield.com> 0.1.72-1
- Merge pull request #423 from mwratt/feature/WSF-4655-tweaks-and-fixes
  (matt.wratt@trineo.co.nz)
- fixes performance failures when scrolling stores (matt.wratt@trineo.co.nz)
- Merge pull request #421 from thiago/master (tfigueiro@au.westfield.com)
- Add missing apache module (tfigueiro@au.westfield.com)

* Tue Oct 01 2013 ci <doperations@au.westfield.com> 0.1.71-1
- Merge pull request #422 from mwratt/feature/WSF-4655-tweaks-and-fixes
  (matt.wratt@trineo.co.nz)
- fixes undef method error on nil (matt.wratt@trineo.co.nz)

* Tue Oct 01 2013 ci <doperations@au.westfield.com> 0.1.70-1
- adds phone link helper (matt.wratt@trineo.co.nz)
- also apply to map toggle fix to android (matt.wratt@trineo.co.nz)
- fixes store path to include retailer_code (matt.wratt@trineo.co.nz)
- fixes iOS map toggle button (matt.wratt@trineo.co.nz)
- WSF-4916 Formats phone number as per comments (matt.wratt@trineo.co.nz)
- we do not use BEM for js hooks (matt.wratt@trineo.co.nz)
- fixes broken page when toggling back from maps (matt.wratt@trineo.co.nz)
- Merge pull request #420 from ldewey/auth (matt.wratt@trineo.co.nz)
- Added Redirect on auth-me page (ldewey@au.westfield.com)

* Tue Oct 01 2013 ci <doperations@au.westfield.com> 0.1.69-1
- Merge pull request #418 from ldewey/auth (matt.wratt@trineo.co.nz)
- Merge pull request #419 from cpearce/stores-updates (matt.wratt@trineo.co.nz)
- Added back in simple auth to help with cut over (ldewey@au.westfield.com)
- Commented out JS auth to help with cut over (ldewey@au.westfield.com)
- Removing blue colour from store map/list toggle button
  (CPearce@au.westfield.com)
- Fixing issue with Chrome when 2nd slide is in view for storefront carousel
  (CPearce@au.westfield.com)
- Changed it from a password popup to a auth me page! (ldewey@au.westfield.com)
- Removed http simple auth and replaced it with some JS auth!
  (ldewey@au.westfield.com)

* Tue Oct 01 2013 ci <doperations@au.westfield.com> 0.1.68-1
- 

* Tue Oct 01 2013 ci <doperations@au.westfield.com> 0.1.67-1
- Merge pull request #416 from fchan/refactor-application
  (ldewey@au.westfield.com)
- Remove extra space (fiona@fionachan.net)
- New Relic release tracking (tfigueiro@au.westfield.com)
- Refactored application and national (fiona@fionachan.net)

* Mon Sep 30 2013 ci <doperations@au.westfield.com> 0.1.66-1
- Merge pull request #414 from thiago/master (tfigueiro@au.westfield.com)
- Cache fingerprinted assets for 1 year (tfigueiro@us.westfield.com)

* Mon Sep 30 2013 ci <doperations@au.westfield.com> 0.1.65-1
- Small date fix for events (ldewey@au.westfield.com)

* Mon Sep 30 2013 ci <doperations@au.westfield.com> 0.1.64-1
- Merge pull request #412 from cpearce/stores-updates (ldewey@au.westfield.com)
- Removing the dulled out affect for when content is ajaxed in due to
  performance issues (CPearce@au.westfield.com)
- Adding phone number text to make page easier to understand for screen readers
  (CPearce@au.westfield.com)
- Dulling out the ajaxed content rather than hiding it
  (CPearce@au.westfield.com)
- Removing js-disabled-hide from stores index/show preloader
  (CPearce@au.westfield.com)
- Adding ARIA to products pin board (CPearce@au.westfield.com)
- Removing uneeded label element from products sort (CPearce@au.westfield.com)
- Fixing placement of h3 in applied filters area of products filters
  (CPearce@au.westfield.com)
- Fixing issue where container was blocking interacting with the map and adding
  ARIA attrs (CPearce@au.westfield.com)

* Mon Sep 30 2013 ci <doperations@au.westfield.com> 0.1.63-1
- Merge pull request #411 from ldewey/product-browse-price-fix
  (chorn@au.westfield.com)
- Product browse price facet fix. (ldewey@au.westfield.com)

* Fri Sep 27 2013 ci <doperations@au.westfield.com> 0.1.62-1
- Remove pagination when no results (ldewey@au.westfield.com)

* Fri Sep 27 2013 ci <doperations@au.westfield.com> 0.1.61-1
- Merge pull request #409 from ldewey/events-image-fix
  (matt.wratt@trineo.co.nz)
- Fixed event image link (ldewey@au.westfield.com)
- Build fix (ldewey@au.westfield.com)
- Added style fixes for pagination. (ldewey@au.westfield.com)
- Browser will now scroll to top when you paginate. (ldewey@au.westfield.com)
- Added puma to dev (ldewey@au.westfield.com)
- Small pagination fixes (ldewey@au.westfield.com)
- Added new markup for pagination (ldewey@au.westfield.com)
- Added btn to pagination (ldewey@au.westfield.com)
- WIP (ldewey@au.westfield.com)
- Move call back loop to out of the ajax requst for speed!
  (ldewey@au.westfield.com)

* Thu Sep 26 2013 ci <doperations@au.westfield.com> 0.1.60-1
- Merge pull request #405 from mwratt/feature/storefront
  (ldewey@au.westfield.com)
- nolonger need to limit the translation (matt.wratt@trineo.co.nz)
- adds spinner on pjax requests (matt.wratt@trineo.co.nz)
- fixes map list toggle on storefront page (matt.wratt@trineo.co.nz)

* Thu Sep 26 2013 ci <doperations@au.westfield.com> 0.1.59-1
- Merge pull request #404 from mwratt/feature/storefront
  (ldewey@au.westfield.com)
- fixes precompiled asset name (matt.wratt@trineo.co.nz)
- fixes flex slider when pjax navigation is used (matt.wratt@trineo.co.nz)

* Thu Sep 26 2013 ci <doperations@au.westfield.com> 0.1.58-1
- Fixing merge conflict from another feature (CPearce@au.westfield.com)
- Adding HTML comments to keep elements on seperate lines for readability
  (CPearce@au.westfield.com)
- Adding gift card toggle to stores filters - WSF-5489
  (CPearce@au.westfield.com)

* Thu Sep 26 2013 ci <doperations@au.westfield.com> 0.1.57-1
- Merge pull request #395 from cpearce/map-control-styling-storefront-updates
  (matt.wratt@trineo.co.nz)
- Storefront various updates/fixes/improvements - WSF-4655
  (CPearce@au.westfield.com)
- Micello map control styling WSF-5488 (CPearce@au.westfield.com)

* Thu Sep 26 2013 ci <doperations@au.westfield.com> 0.1.56-1
- 

* Thu Sep 26 2013 ci <doperations@au.westfield.com> 0.1.55-1
- Merge pull request #393 from ldewey/deal-state-update
  (ldewey@au.westfield.com)
- Merge pull request #399 from ldewey/master (ldewey@au.westfield.com)
- A fix to bring the price facet back (ldewey@au.westfield.com)
- Added state: 'live' to deals controller (ldewey@au.westfield.com)

* Wed Sep 25 2013 ci <doperations@au.westfield.com> 0.1.54-1
- 

* Wed Sep 25 2013 ci <doperations@au.westfield.com> 0.1.53-1
- More Fixes for national page centre selection URL (ldewey@au.westfield.com)
- Fixed national page centre selection URL (ldewey@au.westfield.com)

* Wed Sep 25 2013 ci <doperations@au.westfield.com> 0.1.52-1
- 

* Wed Sep 25 2013 ci <doperations@au.westfield.com> 0.1.51-1
- Merge pull request #397 from ldewey/chirs-master (matt.wratt@trineo.co.nz)
- Updated links as per feed back (ldewey@au.westfield.com)
- Android roate crash fix (ldewey@au.westfield.com)

* Wed Sep 25 2013 ci <doperations@au.westfield.com> 0.1.50-1
- Merge pull request #388 from ldewey/chirs-master (ldewey@au.westfield.com)
- Added some very basic specs to product (ldewey@au.westfield.com)
- More work to nat product routes. (ldewey@au.westfield.com)
- Adding national product routes. (ldewey@au.westfield.com)
- Refactor all centres helper method for alternate site header for national
  view - WSF-5066 (CPearce@au.westfield.com)
- Using a helper for site logo to Rails helper for alternate site header for
  national view - WSF-5066 (CPearce@au.westfield.com)
- Updating controller for alternate site header for national view - WSF-5066
  (CPearce@au.westfield.com)
- Removing duplicate padding for alternate site header for national view -
  WSF-5066 (CPearce@au.westfield.com)
- Removing layout from application layout for alternate site header for
  national view - WSF-5066 (CPearce@au.westfield.com)
- Removing redundant selector from alternate site header for national view -
  WSF-5066 (CPearce@au.westfield.com)
- Creating the alternate site header for national view - WSF-5066
  (CPearce@au.westfield.com)

* Wed Sep 25 2013 ci <doperations@au.westfield.com> 0.1.49-1
- Merge pull request #392 from mwratt/fix/slow_store_response
  (ldewey@au.westfield.com)
- allows centre to be set (fixes slow response) (matt.wratt@trineo.co.nz)

* Tue Sep 24 2013 ci <doperations@au.westfield.com> 0.1.48-1
- 

* Tue Sep 24 2013 ci <doperations@au.westfield.com> 0.1.47-1
- Merge pull request #391 from btillman/api_comments
  (tfigueiro@au.westfield.com)
- adds intense debate comments to API docs (ben.tillman@gmail.com)

* Tue Sep 24 2013 ci <doperations@au.westfield.com> 0.1.46-1
- 

* Tue Sep 24 2013 ci <doperations@au.westfield.com> 0.1.45-1
- Merge pull request #390 from ldewey/site-wide-cache (matt.wratt@trineo.co.nz)
- Added blanket site wide cache of one hour. (ldewey@au.westfield.com)

* Mon Sep 23 2013 ci <doperations@au.westfield.com> 0.1.44-1
- Merge pull request #387 from csmith/master (craigM.smith@au.westfield.com)
- Swapped deals url around to keep it consistent with product.
  (craigm.smith@au.westfield.com)
- Added retailer code in to deal show url for analytics.
  (craigm.smith@au.westfield.com)

* Mon Sep 23 2013 ci <doperations@au.westfield.com> 0.1.43-1
- Merge pull request #382 from fchan/iphone-height-fix
  (cpearce@au.westfield.com)
- Fixing the ipad height (fiona@fionachan.net)

* Fri Sep 20 2013 ci <doperations@au.westfield.com> 0.1.42-1
- Fixed typo (ldewey@au.westfield.com)

* Fri Sep 20 2013 ci <doperations@au.westfield.com> 0.1.41-1
- 

* Fri Sep 20 2013 ci <doperations@au.westfield.com> 0.1.40-1
- cloudinary asset update (ldewey@au.westfield.com)

* Fri Sep 20 2013 ci <doperations@au.westfield.com> 0.1.39-1
- Merge pull request #383 from ldewey/WSF-4687 (fchan@au.westfield.com)
- Fixed google map alt text. (ldewey@au.westfield.com)
- Added image of bondijunction (ldewey@au.westfield.com)
- Added Customer pin to static google maps (ldewey@au.westfield.com)
- More cleanup to centre info map (ldewey@au.westfield.com)
- Added marker to static map (ldewey@au.westfield.com)
- Revert "Merge pull request #380 from ldewey/WSF-4687"
  (ldewey@au.westfield.com)

* Fri Sep 20 2013 ci <doperations@au.westfield.com> 0.1.38-1
- Merge pull request #384 from fchan/national-bug (ldewey@au.westfield.com)
- Merge pull request #381 from mwratt/feature/WSF-4655-storefront
  (ldewey@au.westfield.com)
- Re-saved hero image (fiona@fionachan.net)
- Re-saved national hero images (fiona@fionachan.net)
- improved pan for our given layout (matt.wratt@trineo.co.nz)

* Thu Sep 19 2013 ci <doperations@au.westfield.com> 0.1.37-1
- 

* Thu Sep 19 2013 ci <doperations@au.westfield.com> 0.1.36-1
- Merge pull request #379 from mwratt/feature/WSF-4655-storefront
  (ldewey@au.westfield.com)
- Merge pull request #372 from btillman/pretty_api_response
  (ldewey@au.westfield.com)
- fixes broken westfield gift card icon (matt.wratt@trineo.co.nz)
- displays api doc responses in a simpler format (aka yaml) by default
  (ben.tillman@gmail.com)

* Thu Sep 19 2013 ci <doperations@au.westfield.com> 0.1.35-1
- Revert "Merge pull request #378 from ldewey/WSF-4687"
  (ldewey@au.westfield.com)

* Thu Sep 19 2013 ci <doperations@au.westfield.com> 0.1.34-1
- Change to_sign to a hash, as thats better than building a string up
  (ldewey@au.westfield.com)
- Added getting hear to links at the top of centre info
  (ldewey@au.westfield.com)
- Added google maps to centre info page (ldewey@au.westfield.com)

* Wed Sep 18 2013 ci <doperations@au.westfield.com> 0.1.33-1
- 

* Wed Sep 18 2013 ci <doperations@au.westfield.com> 0.1.32-1
- Merge pull request #377 from fchan/iphone-height-fix
  (ldewey@au.westfield.com)
- Merge pull request #376 from ewee/master (ldewey@au.westfield.com)
- Changed ios white gap fix to be for ipad only (fiona@fionachan.net)
- Changed ios white gap fix to be for ipad only (fiona@fionachan.net)
- Fetch results for multiple services in parallel (ewee@au.westfield.com)

* Wed Sep 18 2013 ci <doperations@au.westfield.com> 0.1.31-1
- Merge pull request #375 from fchan/national-bug (cpearce@au.westfield.com)
- Remove redundant class (fiona@fionachan.net)
- Added comment about national centre tile (fiona@fionachan.net)
- Optimise large image a bit more (fiona@fionachan.net)
- Remote unused images and rotation mixn, and fixed background issue on ios5
  (fiona@fionachan.net)

* Wed Sep 18 2013 ci <doperations@au.westfield.com> 0.1.30-1
- Merge pull request #366 from csmith/feature/parking-hours
  (craigM.smith@au.westfield.com)
- Fix to quoting (craigm.smith@au.westfield.com)
- Don't display a paragraph for a blank line. (craigm.smith@au.westfield.com)
- Don't show credit card %% if there isn't one. (craigm.smith@au.westfield.com)
- When max daily rates are 0 or empty, don't say free. Say nothing or say -.
  (craigm.smith@au.westfield.com)
- Classes that are used in testing I've prefixed with test-, so they aren't
  confused when styling. (craigm.smith@au.westfield.com)
- Fixed dodgy formatting. (craigm.smith@au.westfield.com)
- Removed free parking instructions (craigm.smith@au.westfield.com)
- Updated flat rate parking copy. (craigm.smith@au.westfield.com)
- Added all the text fields to each view of parking.
  (craigm.smith@au.westfield.com)
- Moved t&c and text parking info into partials.
  (craigm.smith@au.westfield.com)
- Added a trivial test for t&c on the rates page.
  (craigm.smith@au.westfield.com)
- Using proper cloudinary helper (craigm.smith@au.westfield.com)
- Added link to Ts and Cs for parking. (craigm.smith@au.westfield.com)
- Added parking to centre info page. (craigm.smith@au.westfield.com)

* Wed Sep 18 2013 ci <doperations@au.westfield.com> 0.1.29-1
- Merge pull request #371 from mwratt/feature/WSF-4655-storefront
  (ldewey@au.westfield.com)
- improves 300 character limit (matt.wratt@trineo.co.nz)
- moves store model creation to service (matt.wratt@trineo.co.nz)
- removes fixed comment (matt.wratt@trineo.co.nz)
- fixes map popup links to work as expected (matt.wratt@trineo.co.nz)
- adds pjax transition to stores index/show pages (matt.wratt@trineo.co.nz)
- fixes mobile view, hides incomplete deals/products (matt.wratt@trineo.co.nz)
- fixes broken bower.json file (matt.wratt@trineo.co.nz)
- adds closing time to stores list page detail popup (matt.wratt@trineo.co.nz)
- adds closing time to store front (matt.wratt@trineo.co.nz)
- extracts responsive map js for show/index pages (matt.wratt@trineo.co.nz)
- fixes header class name relating to banners (matt.wratt@trineo.co.nz)
- adds dynamic storefront banner phone email etc. (matt.wratt@trineo.co.nz)

* Wed Sep 18 2013 ci <doperations@au.westfield.com> 0.1.28-1
- Merge pull request #373 from ldewey/master (matt.wratt@trineo.co.nz)
- Addded more pin board breakpoints (ldewey@au.westfield.com)

* Wed Sep 18 2013 ci <doperations@au.westfield.com> 0.1.27-1
- Centre show pinboard has wrong data passing to the tiles
  (ldewey@au.westfield.com)

* Wed Sep 18 2013 ci <doperations@au.westfield.com> 0.1.26-1
- Merge pull request #367 from ldewey/WSF-4906 (cpearce@au.westfield.com)
- Class ordering (ldewey@au.westfield.com)
- Updated global_search VCR cassette to fix tests (ldewey@au.westfield.com)
- Removed un-needed styles from non pinboard tiles (ldewey@au.westfield.com)
- removed un-needed CSS/SCSS (ldewey@au.westfield.com)
- Reorderd the css class names (ldewey@au.westfield.com)
- Added comments and renamed "is-active" to "is-pin-board-loaded"
  (ldewey@au.westfield.com)
- Coverted px to em's (ldewey@au.westfield.com)
- Change comment from palm to Lap large (ldewey@au.westfield.com)
- Show 15 products per page by default (ldewey@au.westfield.com)
- PR comment fixes (ldewey@au.westfield.com)
- Templates are now build not hardcoded (ldewey@au.westfield.com)
- Removed the guard reload info (ldewey@au.westfield.com)
- Small fix to karma.conf.js to fix js tests (ldewey@au.westfield.com)
- Events and Deals now uses the new pin board rendering
  (ldewey@au.westfield.com)
- Renamed tiles.js.coffee to pin-board.js.coffee (ldewey@au.westfield.com)
- pin board selector clean up. Also moved xhr stuff to pinboard template
  (ldewey@au.westfield.com)
- Tile images will be removed if they 404 (ldewey@au.westfield.com)
- Moved pin-board layout to layouts (ldewey@au.westfield.com)
- Moved all product browse code to use coffee script (ldewey@au.westfield.com)
- Removed isotope (ldewey@au.westfield.com)
- Fixes for new pinboard (ldewey@au.westfield.com)
- Removed livereload, any using it? (ldewey@au.westfield.com)
- rebuilt the pinboard layout system (ldewey@au.westfield.com)
- Added a half width gutter to the gird (ldewey@au.westfield.com)
- Only products (index) can use the the new isotope rendering way
  (ldewey@au.westfield.com)
- Fixes as per PR comments. (ldewey@au.westfield.com)
- Isotope now does not need to wait for image to load (ldewey@au.westfield.com)
- Removed the un-need info from the gon data. (ldewey@au.westfield.com)

* Tue Sep 17 2013 ci <doperations@au.westfield.com> 0.1.25-1
- Merge pull request #364 from fchan/national-hp (ldewey@au.westfield.com)
- Reduce height of header at palm size (fiona@fionachan.net)
- More little fixes (fiona@fionachan.net)
- Added nav around list of centre links (fiona@fionachan.net)
- Use dynamic values on national landing page (ewee@au.westfield.com)
- Comment out unused code and fix footer nav (fiona@fionachan.net)
- Added nav element (fiona@fionachan.net)
- Update some styles after feedback (fiona@fionachan.net)
- More PR feedback fixes (fiona@fionachan.net)
- Fixes after PR feedback (fiona@fionachan.net)
- Few more fixes, comments and hidden centre background img
  (fiona@fionachan.net)
- Fixes after PR review (fiona@fionachan.net)
- Hiding preloader for now and added footer links (fiona@fionachan.net)
- Cleanup (fiona@fionachan.net)
- Added video thumbnail and various fixes (fiona@fionachan.net)
- Updated icon font and some tweaks (fiona@fionachan.net)
- Nationl centre tiles and footer (fiona@fionachan.net)
- Fixes after code review (fiona@fionachan.net)
- Some updates to gallery and added centre tile (fiona@fionachan.net)
- Cleaned up gallery css and various fixes (fiona@fionachan.net)
- Added gallery mixin (fiona@fionachan.net)
- Update fading animation (fiona@fionachan.net)
- Some CSS animation stuff (fiona@fionachan.net)
- National homepage header (fiona@fionachan.net)
- First commit of national homepage (fiona@fionachan.net)

* Mon Sep 16 2013 ci <doperations@au.westfield.com> 0.1.24-1
- fixes WSF-5235 date format for event list (ben.tillman@gmail.com)

* Mon Sep 16 2013 ci <doperations@au.westfield.com> 0.1.23-1
- Merge pull request #361 from cpearce/master (ldewey@au.westfield.com)
- Adding indentation to markup when inside if statement to improve readability
  (CPearce@au.westfield.com)
- Adding fallback messages when there is no content/search results for
  products, deals and events (CPearce@au.westfield.com)

* Mon Sep 16 2013 ci <doperations@au.westfield.com> 0.1.22-1
- Merge pull request #362 from ldewey/master (ben.tillman@trineo.co.nz)
- Remvoed AAA, as it required redis. (ldewey@au.westfield.com)

* Fri Sep 13 2013 ci <doperations@au.westfield.com> 0.1.21-1
- Merge pull request #359 from btillman/api_docs_update
  (ldewey@au.westfield.com)
- adds descriptive sections for API docs (ben.tillman@gmail.com)
- updates links and copy for API docs (ben.tillman@gmail.com)

* Fri Sep 13 2013 ci <doperations@au.westfield.com> 0.1.20-1
- Merge pull request #360 from cpearce/master (ldewey@au.westfield.com)
- UI Polish - WSF-5381 (CPearce@au.westfield.com)
- UI Polish - WSF-5429 (CPearce@au.westfield.com)
- Removing 'quality: 25' for store logos (CPearce@au.westfield.com)
- UI Polish - WSF-5398 (CPearce@au.westfield.com)
- UI Polish - WSF-5374 (CPearce@au.westfield.com)
- UI Polish - WSF-5373 (CPearce@au.westfield.com)
- UI Polish - WSF-5378 (CPearce@au.westfield.com)
- UI Polish - WSF-5379 (CPearce@au.westfield.com)
- UI Polish - WSF-5379 (CPearce@au.westfield.com)
- UI Polish - WSF-5379 (CPearce@au.westfield.com)
- UI Polish - WSF-5370 (CPearce@au.westfield.com)

* Thu Sep 12 2013 ci <doperations@au.westfield.com> 0.1.19-1
- 

* Thu Sep 12 2013 ci <doperations@au.westfield.com> 0.1.18-1
- fixes broken store model specs (matt.wratt@trineo.co.nz)
- Allows store logos to work with cloudinary (matt.wratt@trineo.co.nz)

* Thu Sep 12 2013 ci <doperations@au.westfield.com> 0.1.17-1
- Merge pull request #357 from cpearce/master (ldewey@au.westfield.com)
- Merge pull request #355 from mwratt/fix/placeholder (ldewey@au.westfield.com)
- Merge pull request #351 from ewee/master (ldewey@au.westfield.com)
- Header updates - WSF-5134 (CPearce@au.westfield.com)
- removes jquery placeholer polyfill (matt.wratt@trineo.co.nz)
- UPdate google plus to google+ (ewee@au.westfield.com)
- Open social media links in new window (ewee@au.westfield.com)
- Convert certain HTML tags to Rails actionview helper methods
  (ewee@au.westfield.com)

* Sat Sep 07 2013 ci <doperations@au.westfield.com> 0.1.16-1
- Merge pull request #354 from thiago/master (ldewey@au.westfield.com)
- Add non-lorem-ipsum placeholder copy for API Documentation
  (tfigueiro@au.westfield.com)

* Sat Sep 07 2013 ci <doperations@au.westfield.com> 0.1.15-1
- Merge pull request #347 from btillman/api_doc_theme
  (tfigueiro@au.westfield.com)
- updates theme for api docs (ben.tillman@gmail.com)

* Fri Sep 06 2013 ci <doperations@au.westfield.com> 0.1.14-1
- Merge remote-tracking branch 'digital/master' (ben@germanforblack.com)
- * Added esc key close * Added click-off close (ben@germanforblack.com)

* Fri Sep 06 2013 ci <doperations@au.westfield.com> 0.1.13-1
- When you hit enter on search with out selecting an item it will work
  (ldewey@au.westfield.com)

* Fri Sep 06 2013 ci <doperations@au.westfield.com> 0.1.12-1
- Merge pull request #350 from bschwarz/master (ldewey@au.westfield.com)
- * Added suggestionsVisible, rather than emptying the suggestions list * Added
  a delay to closing the suggestions list so that the links can receive the
  click event * Cycle through the list in both directions
  (ben@germanforblack.com)

* Fri Sep 06 2013 ci <doperations@au.westfield.com> 0.1.11-1
- Merge pull request #348 from fchan/centre-info-footer (ewee@au.westfield.com)
- Fix up link syntax (fiona@fionachan.net)
- Added promo tile images and path to centre hours (fiona@fionachan.net)

* Thu Sep 05 2013 ci <doperations@au.westfield.com> 0.1.10-1
- Merge remote-tracking branch 'digital/master' into search-enhancements
  (ben@germanforblack.com)
- Add String#trim for IE8 (ben@germanforblack.com)
- Not required now that we're using a callback (ben@germanforblack.com)
- $window is required to set $window.location (ben@germanforblack.com)
- Set active search result colour to dotted line (ben@germanforblack.com)
- Remove window click and use mg-blur and focus (ben@germanforblack.com)
- Search suggestion keyboard controls as described in #335
  (ben@germanforblack.com)

* Thu Sep 05 2013 ci <doperations@au.westfield.com> 0.1.9-1
- Comment out footer on centre info page until its ready
  (ewee@au.westfield.com)

* Thu Sep 05 2013 ci <doperations@au.westfield.com> 0.1.8-1
- Merge pull request #344 from ewee/master (ldewey@au.westfield.com)
- Commented out incomplete sections (ewee@au.westfield.com)

* Wed Sep 04 2013 ci <doperations@au.westfield.com> 0.1.7-1
- Merge pull request #343 from cpearce/master (ben@germanforblack.com)
- Creating UI for when a product is not available at a centre - WSF-5029
  (CPearce@au.westfield.com)
- Removing @extend rules for drop down menu, filters and micello map modules to
  prevent bloated css (CPearce@au.westfield.com)
- Creating UI for when a product is not available at a centre - WSF-5029
  (CPearce@au.westfield.com)
- Creating UI for when a product is not available at a centre - WSF-5029
  (CPearce@au.westfield.com)
- Creating UI for when a product is not available at a centre - WSF-5029
  (CPearce@au.westfield.com)

* Wed Sep 04 2013 ci <doperations@au.westfield.com> 0.1.6-1
- Merge pull request #341 from fchan/fix-hero (cpearce@au.westfield.com)
- Fix hero images and module (fiona@fionachan.net)

* Wed Sep 04 2013 ci <doperations@au.westfield.com> 0.1.5-1
- 

* Tue Sep 03 2013 ci <doperations@au.westfield.com> 0.1.4-1
- Merge pull request #336 from fchan/5090-centre-info
  (cpearce@au.westfield.com)
- PR feedback fix (fiona@fionachan.net)
- PR feedback fix (fiona@fionachan.net)
- PR feedback fixes (fiona@fionachan.net)
- PR feedback fixes (fiona@fionachan.net)
- More PR fixes (fiona@fionachan.net)
- Update comment (fiona@fionachan.net)
- Move code to one line and add back ticks (fiona@fionachan.net)
- Combine mixin in centre location (fiona@fionachan.net)
- Move divider div (fiona@fionachan.net)
- Fixes after PR feedback (fiona@fionachan.net)
- Added conditional checks for contact us and social media
  (ewee@au.westfield.com)
- Reworked the nav-contextual (fiona@fionachan.net)
- Fix spacing issue on icon (fiona@fionachan.net)
- Added promo tiles (fiona@fionachan.net)
- Fix up centre location width (fiona@fionachan.net)
- Small updates to JS for nav-contextual (ldewey@au.westfield.com)
- Fixed reference to centre phone number on CTA button (ewee@au.westfield.com)
- Added Js for nav-contextual (ldewey@au.westfield.com)
- Reworked centre location module a bit (fiona@fionachan.net)
- More code review changes (fiona@fionachan.net)
- Updated follow us section (fiona@fionachan.net)
- Some changes after code reviews (fiona@fionachan.net)
- Adjustments to centre map and google map modules (fiona@fionachan.net)
- Adjusted hero size and added centre info img (fiona@fionachan.net)
- More centre info stuff. Also refactored centres-list class name
  (fiona@fionachan.net)
- More centre info page stuff (fiona@fionachan.net)
- Extended box, fix island extender class and fine-print (fiona@fionachan.net)
- Refactor hero to become module (fiona@fionachan.net)
- Added non-palm-island to center info and hours page (fiona@fionachan.net)
- Added fine-print abstraction (fiona@fionachan.net)
- Update grid and added new google map static module (fiona@fionachan.net)

* Tue Sep 03 2013 ci <doperations@au.westfield.com> 0.1.3-1
- removes jquery-placeholder (matt.wratt@trineo.co.nz)

* Tue Sep 03 2013 ci <doperations@au.westfield.com> 0.1.2-1
- Merge pull request #337 from cpearce/master (ldewey@au.westfield.com)
- Spec fix (ldewey@au.westfield.com)
- Styling search results - WSF-5042 (CPearce@au.westfield.com)

* Mon Sep 02 2013 ci <doperations@au.westfield.com> 0.1.1-1
- set application to version 0.1 (pmcinerney@au.westfield.com)

* Mon Sep 02 2013 ci <doperations@au.westfield.com> 0.0.439-1
- Change password for global auth (itinsley@Ians-MacBook-Pro.local)

* Mon Sep 02 2013 ci <doperations@au.westfield.com> 0.0.438-1
- Merge pull request #332 from ldewey/master (itinsley@au.westfield.com)
- Adding basic auth to the customer console for UAT and PROD.
  (ldewey@au.westfield.com)

* Mon Sep 02 2013 ci <doperations@au.westfield.com> 0.0.437-1
- Marking up original price more semantic for product detail view
  (CPearce@au.westfield.com)
- Changing map popup to use icon font to eliminate bg img
  (CPearce@au.westfield.com)

* Fri Aug 30 2013 ci <doperations@au.westfield.com> 0.0.436-1
- Merge pull request #331 from cpearce/master (fchan@au.westfield.com)
- Adding a conditional rule to Angular Cloak abstraction
  (CPearce@au.westfield.com)

* Fri Aug 30 2013 ci <doperations@au.westfield.com> 0.0.435-1
- Merge pull request #330 from cpearce/master (fchan@au.westfield.com)
- Fixing drop down menu arrow pointer so it always go behind scrollable list
  (CPearce@au.westfield.com)

* Fri Aug 30 2013 ci <doperations@au.westfield.com> 0.0.434-1
- Merge pull request #329 from cpearce/master (matt.wratt@trineo.co.nz)
- MVP Stores filter - WSF-4897 (CPearce@au.westfield.com)

* Fri Aug 30 2013 ci <doperations@au.westfield.com> 0.0.433-1
- Merge pull request #328 from mwratt/fix/popup_logo (matt.wratt@trineo.co.nz)
- removes #(store.logo} from popup without no logo (matt.wratt@trineo.co.nz)

* Fri Aug 30 2013 ci <doperations@au.westfield.com> 0.0.432-1
- Merge pull request #327 from mwratt/fix/popup_logo (ldewey@au.westfield.com)
- fixes popup logo tidyup after error or no logo (matt.wratt@trineo.co.nz)

* Thu Aug 29 2013 ci <doperations@au.westfield.com> 0.0.431-1
- Merge pull request #325 from mwratt/fix/popup_logo (ldewey@au.westfield.com)
- Merge pull request #323 from ldewey/WSF-5091 (ldewey@au.westfield.com)
- includes only jquery.cloudinary js (matt.wratt@trineo.co.nz)
- Removed retina rendering from event images. (ldewey@au.westfield.com)
- Removed retina rendering from product images. (ldewey@au.westfield.com)
- removes dup cloudinary js and fixes js include (matt.wratt@trineo.co.nz)
- revmoves unused js specs and script (matt.wratt@trineo.co.nz)
- fixes icons sizes and switches to use cloudinary (matt.wratt@trineo.co.nz)

* Thu Aug 29 2013 ci <doperations@au.westfield.com> 0.0.430-1
- Product tile alt tag clean up. (ldewey@au.westfield.com)

* Thu Aug 29 2013 ci <doperations@au.westfield.com> 0.0.429-1
- Filters will now close when option has been selected on mobile.
  (ldewey@au.westfield.com)

* Wed Aug 28 2013 ci <doperations@au.westfield.com> 0.0.428-1
- Merge pull request #321 from cpearce/master (ldewey@au.westfield.com)
- Fixing IE8 issue for Angular cloak and removing html selector
  (CPearce@au.westfield.com)
- Changing the drop down menu to use icon font for the arrow pointer and some
  other small mods (CPearce@au.westfield.com)

* Wed Aug 28 2013 ci <doperations@au.westfield.com> 0.0.427-1
- Do not show facet if it has no values (ldewey@au.westfield.com)
- Added 10 mins of page cache to products (ldewey@au.westfield.com)
- Added angular http cache (ldewey@au.westfield.com)

* Wed Aug 28 2013 ci <doperations@au.westfield.com> 0.0.426-1
- Merge pull request #319 from ldewey/WSF-5169 (matt.wratt@trineo.co.nz)
- Fixed double loading and fixed up preloader (ldewey@au.westfield.com)

* Wed Aug 28 2013 ci <doperations@au.westfield.com> 0.0.425-1
- Clean up from the angular version revert (ldewey@au.westfield.com)
- Revert "Add angular, angular-touch and angular-sanitise at the new 1.2.0rc1
  release" (ldewey@au.westfield.com)
- Revert "Use bower managed angular" (ldewey@au.westfield.com)
- Revert "Remove hand-build HEAD angular" (ldewey@au.westfield.com)
- Revert "ngMobile has been renamed to ngTouch" (ldewey@au.westfield.com)
- Revert "Angular 1.2.0rc1 has issues with ng-includes nested within ng-if
  directives. (https://github.com/angular/angular.js/issues/3307)"
  (ldewey@au.westfield.com)
- Revert "Use angular from bower" (ldewey@au.westfield.com)

* Tue Aug 27 2013 ci <doperations@au.westfield.com> 0.0.424-1
- Merge pull request #317 from ldewey/WSF-5091 (ldewey@au.westfield.com)
- Updated the dates on the event detail page. (ldewey@au.westfield.com)
- Replaced event description with event date, on the event tiles.
  (ldewey@au.westfield.com)

* Tue Aug 27 2013 ci <doperations@au.westfield.com> 0.0.423-1
- Merge pull request #316 from csmith/master (ldewey@au.westfield.com)
- Pass the id of the store on store service, not on deal service.
  (craigm.smith@au.westfield.com)

* Tue Aug 27 2013 ci <doperations@au.westfield.com> 0.0.422-1
- The movie service json has changed structure. (craigm.smith@au.westfield.com)

* Tue Aug 27 2013 ci <doperations@au.westfield.com> 0.0.421-1
- Merge pull request #314 from cpearce/master (ldewey@au.westfield.com)
- Removing redundant class from product browse category buttons
  (CPearce@au.westfield.com)

* Tue Aug 27 2013 ci <doperations@au.westfield.com> 0.0.420-1
- Merge pull request #313 from cpearce/master (ldewey@au.westfield.com)
- Moving if statement up a level in the DOM for product detail availability at
  (CPearce@au.westfield.com)

* Tue Aug 27 2013 ci <doperations@au.westfield.com> 0.0.419-1
- Merge pull request #312 from cpearce/master (ldewey@au.westfield.com)
- Adding new CSS Normalize (CPearce@au.westfield.com)

* Tue Aug 27 2013 ci <doperations@au.westfield.com> 0.0.418-1
- Merge pull request #311 from cpearce/master (matt.wratt@trineo.co.nz)
- Updating CSS overflow properties to use x/y direction
  (CPearce@au.westfield.com)

* Tue Aug 27 2013 ci <doperations@au.westfield.com> 0.0.417-1
- Merge pull request #310 from cpearce/master (ldewey@au.westfield.com)
- Removing redudant CSS rule from product browse filters
  (CPearce@au.westfield.com)

* Tue Aug 27 2013 ci <doperations@au.westfield.com> 0.0.416-1
- Merge pull request #309 from cpearce/master (ldewey@au.westfield.com)
- Fixing up product browse issues post device testing
  (CPearce@au.westfield.com)

* Tue Aug 27 2013 ci <doperations@au.westfield.com> 0.0.415-1
- rename images centre folder to ie8-maps (matt.wratt@trineo.co.nz)

* Tue Aug 27 2013 ci <doperations@au.westfield.com> 0.0.414-1
- 

* Tue Aug 27 2013 ci <doperations@au.westfield.com> 0.0.413-1
- Merge pull request #307 from mwratt/feature/remove_yepnope_style
  (ldewey@au.westfield.com)
- no-longer defers loading of enquire (matt.wratt@trineo.co.nz)

* Tue Aug 27 2013 ci <doperations@au.westfield.com> 0.0.412-1
- 

* Tue Aug 27 2013 ci <doperations@au.westfield.com> 0.0.411-1
- Merge pull request #302 from cpearce/master (matt.wratt@trineo.co.nz)
- Updating Angular cloak and non JS hide styles to make the site more accesible
  (CPearce@au.westfield.com)
- Applying max width to applied filter tags (CPearce@au.westfield.com)
- Removing placeholder PNG image (CPearce@au.westfield.com)
- Removing large preloader gif (CPearce@au.westfield.com)
- Updates to preloader (CPearce@au.westfield.com)
- Removing grey bg for product browse filter drop down headers - WSF-5084
  (CPearce@au.westfield.com)
- Fixing sort position in product browse when applied filter tags are in view
  (CPearce@au.westfield.com)
- Increasing box shadow for product browse filter drop downs - WSF-5084
  (CPearce@au.westfield.com)
- Making the product browse sort select list sit in the middle of it's
  container (CPearce@au.westfield.com)
- Adding active states to buttons for drop down triggers
  (CPearce@au.westfield.com)
- Updates to angular toggle visibility directive to remove inline CSS for
  hide/show and fix missing aria-hidden attr on loaded state
  (CPearce@au.westfield.com)

* Mon Aug 26 2013 ci <doperations@au.westfield.com> 0.0.410-1
- Merge pull request #306 from mwratt/feature/remove_yepnope_style
  (matt.wratt@trineo.co.nz)
- fixes $script enquire dependency loading (matt.wratt@trineo.co.nz)

* Mon Aug 26 2013 ci <doperations@au.westfield.com> 0.0.409-1
- Merge pull request #305 from mwratt/feature/remove_yepnope_style
  (matt.wratt@trineo.co.nz)
- allows enquire to be loaded first where its needed (matt.wratt@trineo.co.nz)

* Mon Aug 26 2013 ci <doperations@au.westfield.com> 0.0.408-1
- 

* Mon Aug 26 2013 ci <doperations@au.westfield.com> 0.0.407-1
- Merge pull request #304 from mwratt/feature/remove_yepnope_style
  (ldewey@au.westfield.com)
- fixes maps on products, deals, events pages (matt.wratt@trineo.co.nz)
- removes Modernizr.load (matt.wratt@trineo.co.nz)
- service proxy fix (ldewey@au.westfield.com)

* Fri Aug 23 2013 ci <doperations@au.westfield.com> 0.0.406-1
- Merge pull request #300 from bschwarz/aria-toggle-visibility
  (cpearce@au.westfield.com)
- Use is-active (ben@germanforblack.com)
- Rewrote the toggle-visibility directive to add aria-support
  (ben@germanforblack.com)

* Fri Aug 23 2013 ci <doperations@au.westfield.com> 0.0.405-1
- Merge pull request #301 from cpearce/master (fchan@au.westfield.com)
- Fixing the drop down arrow colour to be set based on whether you're in the
  root or sub levels for product browse filters (CPearce@au.westfield.com)

* Fri Aug 23 2013 ci <doperations@au.westfield.com> 0.0.404-1
- 

* Fri Aug 23 2013 ci <doperations@au.westfield.com> 0.0.403-1
- Merge pull request #299 from cpearce/master (ben@germanforblack.com)
- Fixing issue where product browse filters disappear between viewports -
  WSF-5132, tiles overlapping (CPearce@au.westfield.com)
- Automatic commit of package [wf-customerconsole] release [0.0.402-1]. (ci)
- Changing the layout of product browse filters to stop it colliding with
  product sort (CPearce@au.westfield.com)
- Fixing formatting issues with on sale toggle for product browse filters
  (CPearce@au.westfield.com)

* Fri Aug 23 2013 ci <doperations@au.westfield.com> 0.0.402-1
- 

* Fri Aug 23 2013 ci <doperations@au.westfield.com> 0.0.401-1
- 

* Fri Aug 23 2013 ci <doperations@au.westfield.com> 0.0.400-1
- Merge pull request #295 from ldewey/master (matt.wratt@trineo.co.nz)
- Retailer logos are now rendered via cloudinary (ldewey@au.westfield.com)
- Image resize fixups for product show (ldewey@au.westfield.com)
- Events now use mywf.io and cloudinary (ldewey@au.westfield.com)
- Removed duplicate service_helper gem in Gemfile. (ldewey@au.westfield.com)
- Removed uneeded hacks as now product service is doing the right thing.
  (ldewey@au.westfield.com)

* Fri Aug 23 2013 ci <doperations@au.westfield.com> 0.0.399-1
- Merge pull request #292 from fchan/nav-contextual (cpearce@au.westfield.com)
- Move CSS rule to 1 line (fiona@fionachan.net)
- Fix PR feedback (fiona@fionachan.net)
- Fix PR feedback (fiona@fionachan.net)
- More tiding up and remove container-wide from nav-contextual
  (fiona@fionachan.net)
- Fix up nav contextual after PR feedback (fiona@fionachan.net)
- More tidying up in centre-selector module (fiona@fionachan.net)
- Added some comments (fiona@fionachan.net)
- Rename _nav_contextual to _section_nav (fiona@fionachan.net)
- Rework nav-contextual and centre-selector (fiona@fionachan.net)
- Move centre selector as its own module (fiona@fionachan.net)
- Move nav-contextual to modules (fiona@fionachan.net)
- Some nav-contextual refactoring (fiona@fionachan.net)

* Fri Aug 23 2013 ci <doperations@au.westfield.com> 0.0.398-1
- 

* Fri Aug 23 2013 ci <doperations@au.westfield.com> 0.0.397-1
- Merge pull request #296 from mwratt/feature/IE8_maps
  (ldewey@au.westfield.com)
- Merge pull request #289 from btillman/api_docs (ldewey@au.westfield.com)
- adds js spec coverage of IE8 maps (matt.wratt@trineo.co.nz)
- extracted makeArray for clarity (matt.wratt@trineo.co.nz)
- bug fix for IE8 maps (matt.wratt@trineo.co.nz)
- altered to use $script loading (matt.wratt@trineo.co.nz)
- fixes undefined map error (matt.wratt@trineo.co.nz)
- adds Modernizr.load support with $script (matt.wratt@trineo.co.nz)
- replaces yepnope with $script (matt.wratt@trineo.co.nz)
- adds API documentation for Cloudinary (ben.tillman@gmail.com)
- fixes bug with pre-expanded navigation not being added to accordian group
  (ben.tillman@gmail.com)
- disables put, post and delete api documentation test methods
  (ben.tillman@gmail.com)
- adds API docs landing page links (ben.tillman@gmail.com)
- tweaks css for API docs (ben.tillman@gmail.com)
- adds API docs navigation (ben.tillman@gmail.com)

* Fri Aug 23 2013 ci <doperations@au.westfield.com> 0.0.396-1
- Merge pull request #297 from cpearce/master (ben@germanforblack.com)
- Refactoring prod browse filter headers and replicating trigger for non-palm
  (CPearce@au.westfield.com)
- Closing icon span element in product filters (CPearce@au.westfield.com)

* Thu Aug 22 2013 ci <doperations@au.westfield.com> 0.0.395-1
- Decreasing the top margin of the drop down offset (CPearce@au.westfield.com)
- Fixing padding inconsistency for filter tags (CPearce@au.westfield.com)
- Removing deals and events from global search placeholder - WSF-5061
  (CPearce@au.westfield.com)
- Refactoring filter/drop down modules to be more modular and truncating
  store/brand names (CPearce@au.westfield.com)
- Bringing filter styles over to drop down menu module so it can be reused
  (CPearce@au.westfield.com)
- Removing arrow icons on category filters - WSF-5080
  (CPearce@au.westfield.com)
- Applying arrows to filter drop downs - WSF-5083 (CPearce@au.westfield.com)
- Isolating filter top spacing for pin board filtering
  (CPearce@au.westfield.com)

* Thu Aug 22 2013 ci <doperations@au.westfield.com> 0.0.394-1
- Merge pull request #293 from ldewey/master (matt.wratt@trineo.co.nz)
- Added the centre info page (ldewey@au.westfield.com)

* Thu Aug 22 2013 ci <doperations@au.westfield.com> 0.0.393-1
- Merge pull request #276 from mwratt/feature/responsive_maps
  (ldewey@au.westfield.com)
- adds sinon build files (matt.wratt@trineo.co.nz)
- improves test coverage of maps js (matt.wratt@trineo.co.nz)
- adds sinon for better js spec stubs (matt.wratt@trineo.co.nz)
- puts js specs in the correct folder structure (matt.wratt@trineo.co.nz)
- fixes load odering issue with IE8 maps (matt.wratt@trineo.co.nz)
- makes maps responsive when browser is resized (matt.wratt@trineo.co.nz)

* Thu Aug 22 2013 ci <doperations@au.westfield.com> 0.0.392-1
- Merge pull request #291 from ldewey/master (ben@germanforblack.com)
- Produdct browse isotope fix (ldewey@au.westfield.com)

* Thu Aug 22 2013 ci <doperations@au.westfield.com> 0.0.391-1
- Merge pull request #290 from bschwarz/filter-starts-with
  (ldewey@au.westfield.com)
- Add a new custom filter to the angular app that uses a case insensitive regex
  to search/sort the retailer and brand filter drop downs on product browse
  (ben@germanforblack.com)

* Thu Aug 22 2013 ci <doperations@au.westfield.com> 0.0.390-1
- 

* Thu Aug 22 2013 ci <doperations@au.westfield.com> 0.0.389-1
- Merge remote-tracking branch 'digital/master' into angular-search-reorg
  (ben@germanforblack.com)
- Move the global search controller to the angular controllers directory
  (ben@germanforblack.com)
- Format properly in sublime (ben@germanforblack.com)
- ProductSearch (ben@germanforblack.com)
- Move global search service to angular dir Service now has its own url
  (ben@germanforblack.com)
- Rename Search service to Product service (ben@germanforblack.com)
- Move suggestions builder to angular/services (ben@germanforblack.com)

* Thu Aug 22 2013 ci <doperations@au.westfield.com> 0.0.388-1
- Merge pull request #282 from mmell/master (ldewey@au.westfield.com)
- apache vhost with internal and external hosts (mike.mell@nthwave.net)

* Thu Aug 22 2013 ci <doperations@au.westfield.com> 0.0.387-1
- Merge pull request #279 from ldewey/WSF-5074 (matt.wratt@trineo.co.nz)
- tile load fixes (ldewey@au.westfield.com)

* Wed Aug 21 2013 ci <doperations@au.westfield.com> 0.0.386-1
- Disabling stores filters (CPearce@au.westfield.com)
- Product browse style clean up - WSF-5053 (CPearce@au.westfield.com)

* Wed Aug 21 2013 ci <doperations@au.westfield.com> 0.0.385-1
- 

* Wed Aug 21 2013 ci <doperations@au.westfield.com> 0.0.384-1
- Merge pull request #285 from ldewey/WSF-5079 (ldewey@au.westfield.com)
- Changed scale to limit so we dont get huge speakers :)
  (ldewey@au.westfield.com)

* Wed Aug 21 2013 ci <doperations@au.westfield.com> 0.0.383-1
- Workaround for curl dying when proxied service returned chunked encoding.
  (cwalsh2@au.westfield.com)

* Wed Aug 21 2013 ci <doperations@au.westfield.com> 0.0.382-1
- Merge pull request #283 from ldewey/WSF-5079 (ldewey@au.westfield.com)
- Removed trim as that removed to much white space (ldewey@au.westfield.com)

* Wed Aug 21 2013 ci <doperations@au.westfield.com> 0.0.381-1
- Merge pull request #281 from ldewey/WSF-5079 (matt.wratt@trineo.co.nz)
- Changed product images to use cloudinary (ldewey@au.westfield.com)

* Wed Aug 21 2013 ci <doperations@au.westfield.com> 0.0.380-1
- Update button doc (fiona@fionachan.net)
- Convert form doc to 2 space indentation (fiona@fionachan.net)
- Rename form doc file name (fiona@fionachan.net)
- Update embedded content doc (fiona@fionachan.net)
- Renamed embedded content doc file name (fiona@fionachan.net)
- Added regex to remove empty class attr (fiona@fionachan.net)
- Update table doc (fiona@fionachan.net)
- Rename tables doc file name (fiona@fionachan.net)
- Update typography doc (fiona@fionachan.net)
- Change typography doc file name (fiona@fionachan.net)
- Update styleguide template (fiona@fionachan.net)
- Remove styleguide demo class (fiona@fionachan.net)
- Update modifier class table styles (fiona@fionachan.net)
- Change from list to table of modifier classes (fiona@fionachan.net)
- Update divider doc (fiona@fionachan.net)
- Update arrows doc (fiona@fionachan.net)
- Updated slats and columns doc (fiona@fionachan.net)
- Remove modifier class variable in mark up (fiona@fionachan.net)
- Fix up islet doc (fiona@fionachan.net)
- Update complex link and island to doc (fiona@fionachan.net)
- Added Prism to Bower (fiona@fionachan.net)
- Update section names and def list doc (fiona@fionachan.net)
- Put back in credit for preserve aspect ratio (fiona@fionachan.net)
- Update preserve aspect ratio doc (fiona@fionachan.net)
- Update vertical alignment doc (fiona@fionachan.net)
- Style code block and update horiz list comment (fiona@fionachan.net)
- Updated horizontal-list in style guide (fiona@fionachan.net)

* Tue Aug 20 2013 ci <doperations@au.westfield.com> 0.0.379-1
- Fix callback re-creation (cwalsh2@au.westfield.com)

* Tue Aug 20 2013 ci <doperations@au.westfield.com> 0.0.378-1
- Moved price to the left and added txt-truncate to both lines
  (ldewey@au.westfield.com)

* Tue Aug 20 2013 ci <doperations@au.westfield.com> 0.0.377-1
- Merge pull request #274 from bschwarz/master (ben@germanforblack.com)
- Use preloader--middle for maps too (ben@germanforblack.com)
- Use preloader--middle (ben@germanforblack.com)
- Added a preloader--middle modifier (ben@germanforblack.com)
- Remove unused class (ben@germanforblack.com)

* Tue Aug 20 2013 ci <doperations@au.westfield.com> 0.0.376-1
- Merge pull request #275 from ldewey/WSF-5074 (matt.wratt@trineo.co.nz)
- Created isotope responsive, to create consistent padding between tiles
  (ldewey@au.westfield.com)

* Tue Aug 20 2013 ci <doperations@au.westfield.com> 0.0.375-1
- Nest the selector & Use a non greyscale colour value (ben@germanforblack.com)
- Remove as much of the filter styles from conditional javascript as possible.
  (ben@germanforblack.com)

* Tue Aug 20 2013 ci <doperations@au.westfield.com> 0.0.374-1
- Merge pull request #272 from cpearce/master (matt.wratt@trineo.co.nz)
- Making store name dynamic for back to index link (CPearce@au.westfield.com)

* Tue Aug 20 2013 ci <doperations@au.westfield.com> 0.0.373-1
- Merge pull request #271 from cpearce/master (ldewey@au.westfield.com)
- Adding CSS text truncate to external store link (CPearce@au.westfield.com)

* Tue Aug 20 2013 ci <doperations@au.westfield.com> 0.0.372-1
- Merge pull request #270 from cpearce/master (ldewey@au.westfield.com)
- Changing colour of text selection CSS (CPearce@au.westfield.com)

* Tue Aug 20 2013 ci <doperations@au.westfield.com> 0.0.371-1
- Merge pull request #268 from cpearce/master (ldewey@au.westfield.com)
- Making prod desc full width if no available colours - WSF-4983
  (CPearce@au.westfield.com)
- CSS for product desc: WSF-5023 which is a reusable module for user generated
  content or any content needing base typography styles
  (CPearce@au.westfield.com)

* Tue Aug 20 2013 ci <doperations@au.westfield.com> 0.0.370-1
- Merge pull request #269 from ldewey/WSF-5054 (ldewey@au.westfield.com)
- Changed price to sale_price (ldewey@au.westfield.com)

* Mon Aug 19 2013 ci <doperations@au.westfield.com> 0.0.369-1
- incorrect usage of %%config in rpmspec (pmcinerney@au.westfield.com)

* Mon Aug 19 2013 ci <doperations@au.westfield.com> 0.0.368-1
- re-add .production. and .uat. serveralias entries so that nagios polling of
  health checks work again (pmcinerney@au.westfield.com)
- make rpm install replace existing apache configurations with new copy instead
  of making new file .rpmnew (pmcinerney@au.westfield.com)

* Mon Aug 19 2013 ci <doperations@au.westfield.com> 0.0.367-1
- removes micello loading spinner (matt.wratt@trineo.co.nz)
- refactors deferred image loading (matt.wratt@trineo.co.nz)
- moves deferred loading class to correct container (matt.wratt@trineo.co.nz)

* Mon Aug 19 2013 ci <doperations@au.westfield.com> 0.0.366-1
- Merge pull request #259 from mmell/master (ldewey@au.westfield.com)
- add production vhost (mike.mell@nthwave.net)

* Mon Aug 19 2013 ci <doperations@au.westfield.com> 0.0.365-1
- 

* Mon Aug 19 2013 ci <doperations@au.westfield.com> 0.0.364-1
- Merge pull request #265 from ldewey/WSF-5060 (ben@germanforblack.com)
- Merge pull request #263 from bschwarz/master (ldewey@au.westfield.com)
- Fixed tile/facet menu z-index issue. (ldewey@au.westfield.com)
- Even up the spacing on filters (ben@germanforblack.com)
- Cloak products (Layout jumps around less this way) (ben@germanforblack.com)
- Added SortOptions formatter that will append "Sort by…"
  (ben@germanforblack.com)

* Mon Aug 19 2013 ci <doperations@au.westfield.com> 0.0.363-1
- Merge pull request #264 from cpearce/master (matt.wratt@trineo.co.nz)
- Fixing iOS orientation bug: WSF-5035 (CPearce@au.westfield.com)
- Styling storefront (CPearce@au.westfield.com)

* Fri Aug 16 2013 ci <doperations@au.westfield.com> 0.0.362-1
- Merge pull request #254 from mwratt/feature/logos-fix-up
  (cwalsh2@au.westfield.com)
- use logo ref intead of regex'n it (matt.wratt@trineo.co.nz)
- fixes popping issue with deferred logo spinner (matt.wratt@trineo.co.nz)
- removed double call to image transform service (matt.wratt@trineo.co.nz)
- fixes logo on map popup (matt.wratt@trineo.co.nz)

* Fri Aug 16 2013 ci <doperations@au.westfield.com> 0.0.361-1
- Merge pull request #260 from ldewey/WSF-5054 (ben@germanforblack.com)
- Added product price (ldewey@au.westfield.com)

* Fri Aug 16 2013 ci <doperations@au.westfield.com> 0.0.360-1
- Merge pull request #262 from bschwarz/master (ldewey@au.westfield.com)
- Use angular from bower (ben@germanforblack.com)
- Angular 1.2.0rc1 has issues with ng-includes nested within ng-if directives.
  (https://github.com/angular/angular.js/issues/3307) (ben@germanforblack.com)
- ngMobile has been renamed to ngTouch (ben@germanforblack.com)
- Remove hand-build HEAD angular (ben@germanforblack.com)
- Use bower managed angular (ben@germanforblack.com)
- Add angular, angular-touch and angular-sanitise at the new 1.2.0rc1 release
  (ben@germanforblack.com)

* Fri Aug 16 2013 ci <doperations@au.westfield.com> 0.0.359-1
- Merge pull request #261 from cpearce/master (ldewey@au.westfield.com)
- Adding clearfix to pinboard to better contain tiles pre-isotope
  (CPearce@au.westfield.com)

* Fri Aug 16 2013 ci <doperations@au.westfield.com> 0.0.358-1
- Remove nextPage method (ben@germanforblack.com)
- Merge remote-tracking branch 'digital/master' (ben@germanforblack.com)
- Cloak the entire search bar (ben@germanforblack.com)
- Merge pull request #258 from cpearce/master (matt.wratt@trineo.co.nz)
- Styling storefront (CPearce@au.westfield.com)
- Styling storefront (CPearce@au.westfield.com)

* Fri Aug 16 2013 ci <doperations@au.westfield.com> 0.0.357-1
- 

* Fri Aug 16 2013 ci <doperations@au.westfield.com> 0.0.356-1
- 

* Fri Aug 16 2013 ci <doperations@au.westfield.com> 0.0.355-1
- Merge pull request #257 from ldewey/master (cpearce@au.westfield.com)
- Addded uuid to social share aria (ldewey@au.westfield.com)

* Thu Aug 15 2013 ci <doperations@au.westfield.com> 0.0.354-1
- 

* Thu Aug 15 2013 ci <doperations@au.westfield.com> 0.0.353-1
- Utag data update (ldewey@au.westfield.com)

* Thu Aug 15 2013 ci <doperations@au.westfield.com> 0.0.352-1
- Regenerated vcd run for global search (ben@germanforblack.com)
- Merge remote-tracking branch 'digital/master' into centre-selector
  (ben@germanforblack.com)
- Merge remote-tracking branch 'digital/master' into centre-selector
  (ben@germanforblack.com)
- Added centre selector controller (ben@germanforblack.com)
- Made the on sale filter option more like the other filter options
  (ben@germanforblack.com)
- Added nearby centres query (ben@germanforblack.com)
- Render the contextual navigation (ben@germanforblack.com)
- Change up styles now that canned search is being pulled
  (ben@germanforblack.com)
- Title changed to "Available at" for cases when the product isn't actually
  available at the currently selected centre. (ben@germanforblack.com)
- Copy url params on bootstrap. Move product update to after filters have been
  updated. (ben@germanforblack.com)
- Introduce Search.onChange, product browse controller now registers a global
  callback whenever the search is updated. (ben@germanforblack.com)

* Thu Aug 15 2013 ci <doperations@au.westfield.com> 0.0.351-1
- Fixed social_share's (ldewey@au.westfield.com)

* Thu Aug 15 2013 ci <doperations@au.westfield.com> 0.0.350-1
- WSF-5069 Treat super_cat and category as single-value facets
  (cwalsh2@au.westfield.com)

* Thu Aug 15 2013 ci <doperations@au.westfield.com> 0.0.349-1
- Merge pull request #249 from cpearce/master (ldewey@au.westfield.com)
- Styling storefront (CPearce@au.westfield.com)
- TO REVERT BACK - removing favs from detail views (CPearce@au.westfield.com)
- TO REVERT BACK - removing my account and favs from site header
  (CPearce@au.westfield.com)

* Wed Aug 14 2013 ci <doperations@au.westfield.com> 0.0.348-1
- Merge pull request #248 from ldewey/master (cpearce@au.westfield.com)
- Only show tile heading on stream page. (ldewey@au.westfield.com)
- Merge pull request #246 from cawalsh/feature/wsf-5069
  (DOCallaghan@au.westfield.com)
- WSF-5069 Work with the new search service api (cwalsh2@au.westfield.com)

* Wed Aug 14 2013 ci <doperations@au.westfield.com> 0.0.347-1
- adds params to get correctly resized image (matt.wratt@trineo.co.nz)

* Wed Aug 14 2013 ci <doperations@au.westfield.com> 0.0.346-1
- Merge pull request #245 from cpearce/master (matt.wratt@trineo.co.nz)
- Creating a new global var for box shadow (CPearce@au.westfield.com)

* Wed Aug 14 2013 ci <doperations@au.westfield.com> 0.0.345-1
- Merge pull request #242 from cpearce/master (matt.wratt@trineo.co.nz)
- Merge pull request #240 from ldewey/WSF-4886 (matt.wratt@trineo.co.nz)
- Added Universal Tagging (ldewey@au.westfield.com)
- Styling storefront (CPearce@au.westfield.com)
- Removing text from product tile icon (CPearce@au.westfield.com)
- Removing old PictureFill attributes from Deal tile image
  (CPearce@au.westfield.com)
- Create a meta model, and added page titles to that. (ldewey@au.westfield.com)

* Tue Aug 13 2013 ci <doperations@au.westfield.com> 0.0.344-1
- Link to retailer product url if provided in api (cwalsh2@au.westfield.com)

* Tue Aug 13 2013 ci <doperations@au.westfield.com> 0.0.343-1
- updates selected store style in map (matt.wratt@trineo.co.nz)

* Tue Aug 13 2013 ci <doperations@au.westfield.com> 0.0.342-1
- Merge pull request #239 from bschwarz/also-available-at
  (ben@germanforblack.com)
- Title changed to "Available at" for cases when the product isn't actually
  available at the currently selected centre. (ben@germanforblack.com)

* Tue Aug 13 2013 ci <doperations@au.westfield.com> 0.0.341-1
- 

* Tue Aug 13 2013 ci <doperations@au.westfield.com> 0.0.340-1
- Merge pull request #233 from mwratt/fix/stores-list (matt.wratt@trineo.co.nz)
- Merge pull request #238 from cpearce/master (matt.wratt@trineo.co.nz)
- Styling storefront (CPearce@au.westfield.com)
- refactors deferred image loading to jquery plugin (matt.wratt@trineo.co.nz)
- extracts deferred image loading to a coffeescript (matt.wratt@trineo.co.nz)

* Mon Aug 12 2013 ci <doperations@au.westfield.com> 0.0.339-1
- Merge pull request #237 from cpearce/master (ldewey@au.westfield.com)
- Adding new icon fonts (CPearce@au.westfield.com)

* Mon Aug 12 2013 ci <doperations@au.westfield.com> 0.0.338-1
- Merge pull request #236 from ldewey/master (itinsley@au.westfield.com)
- Fixed dates on centre hours page (ldewey@au.westfield.com)

* Mon Aug 12 2013 ci <doperations@au.westfield.com> 0.0.337-1
- Added New relic to the gem lock (ldewey@au.westfield.com)
- Merge pull request #234 from cpearce/master (ben@germanforblack.com)
- Adding nofollow to rel attr for SEO purposes (CPearce@au.westfield.com)

* Mon Aug 12 2013 ci <doperations@au.westfield.com> 0.0.336-1
- 

* Mon Aug 12 2013 ci <doperations@au.westfield.com> 0.0.335-1
- Merge pull request #231 from cpearce/master (matt.wratt@trineo.co.nz)
- Styling storefront (CPearce@au.westfield.com)

* Sat Aug 10 2013 ci <doperations@au.westfield.com> 0.0.334-1
- add newrelic (pmcinerney@au.westfield.com)

* Fri Aug 09 2013 ci <doperations@au.westfield.com> 0.0.333-1
- Show only retail centres (ewee@au.westfield.com)

* Fri Aug 09 2013 ci <doperations@au.westfield.com> 0.0.332-1
- 

* Fri Aug 09 2013 ci <doperations@au.westfield.com> 0.0.331-1
- Merge pull request #229 from bschwarz/styleguide-routes
  (ben@germanforblack.com)
- Allow style guide in any environment that isn't production
  (ben@germanforblack.com)

* Fri Aug 09 2013 ci <doperations@au.westfield.com> 0.0.330-1
- Removing 'vendor' dir and jQuery UI slider style sheet
  (CPearce@au.westfield.com)

* Fri Aug 09 2013 ci <doperations@au.westfield.com> 0.0.329-1
- Merge pull request #227 from cpearce/master (matt.wratt@trineo.co.nz)
- Styling of storefront and refactoring image carousel to make it more reusable
  (CPearce@au.westfield.com)

* Thu Aug 08 2013 ci <doperations@au.westfield.com> 0.0.328-1
- comments out hard coded store hours (matt.wratt@trineo.co.nz)

* Wed Aug 07 2013 ci <doperations@au.westfield.com> 0.0.327-1
- ImageService uses service_helper (michael@michaelbamford.com)

* Wed Aug 07 2013 ci <doperations@au.westfield.com> 0.0.326-1
- Merge pull request #190 from csmith/master (craigM.smith@au.westfield.com)
- Don't show the retailer logo on a deal if it's not there.
  (craigm.smith@au.westfield.com)

* Wed Aug 07 2013 ci <doperations@au.westfield.com> 0.0.325-1
- 

* Wed Aug 07 2013 ci <doperations@au.westfield.com> 0.0.324-1
- Merge branch 'master' of github.dbg.westfield.com:digital/customer_console
  (ben@germanforblack.com)
- Enable angular-cloak (ben@germanforblack.com)

* Wed Aug 07 2013 ci <doperations@au.westfield.com> 0.0.323-1
- Merge pull request #224 from mwratt/fix/stores-list (matt.wratt@trineo.co.nz)
- fixes broken js map spec (matt.wratt@trineo.co.nz)
- Merge pull request #223 from mwratt/fix/stores-list
  (cpearce@au.westfield.com)
- fixes logo height on stores list page (matt.wratt@trineo.co.nz)
- fixes alt text on store list page logo (matt.wratt@trineo.co.nz)
- Merge pull request #221 from mwratt/fix/stores-list (ben@germanforblack.com)
- Merge pull request #222 from cpearce/master (matt.wratt@trineo.co.nz)
- Removing indent when there is no store logo for Micello map popup
  (CPearce@au.westfield.com)
- fixes missing logo on map popup error (matt.wratt@trineo.co.nz)

* Wed Aug 07 2013 ci <doperations@au.westfield.com> 0.0.322-1
- Fix 500 if centre service reports no store (cwalsh2@au.westfield.com)
- Merge pull request #219 from bschwarz/filter-buttons-desktop
  (ben@germanforblack.com)
- Replace hack with better fix. (Also, for IE) (ben@germanforblack.com)
- Remove firefox hack (ben@germanforblack.com)

* Wed Aug 07 2013 ci <doperations@au.westfield.com> 0.0.321-1
- Merge pull request #218 from bschwarz/hideEmptyLists (ben@germanforblack.com)
- Render filters only if there is data for them (ben@germanforblack.com)
- Gosh damn (ben@germanforblack.com)

* Wed Aug 07 2013 ci <doperations@au.westfield.com> 0.0.320-1
- Merge pull request #217 from mwratt/fix/stores-list
  (cwalsh2@au.westfield.com)
- Merge branch 'ng-cloak' (ben@germanforblack.com)
- Tidy (ben@germanforblack.com)
- improves handling of optional store logos (matt.wratt@trineo.co.nz)
- Remove transition. Use html rather than :root (ben@germanforblack.com)
- Code style. Better doco. (ben@germanforblack.com)
- Use ng-cloak to avoid FOUC for search autocomplete area
  (ben@germanforblack.com)

* Wed Aug 07 2013 ci <doperations@au.westfield.com> 0.0.319-1
- 

* Wed Aug 07 2013 ci <doperations@au.westfield.com> 0.0.318-1
- Merge pull request #216 from cpearce/master (cwalsh2@au.westfield.com)
- Removing Stores search as it's now combined into global search
  (CPearce@au.westfield.com)

* Wed Aug 07 2013 ci <doperations@au.westfield.com> 0.0.317-1
- Link search service documentation (cwalsh2@au.westfield.com)

* Wed Aug 07 2013 ci <doperations@au.westfield.com> 0.0.316-1
- 

* Wed Aug 07 2013 ci <doperations@au.westfield.com> 0.0.315-1
- does not load logos in smallest palm view (matt.wratt@trineo.co.nz)
- deferres init functions until enquire is defined (matt.wratt@trineo.co.nz)

* Tue Aug 06 2013 ci <doperations@au.westfield.com> 0.0.314-1
- implement the cas /sso changes with gem updates (mike.mell@nthwave.net)

* Tue Aug 06 2013 ci <doperations@au.westfield.com> 0.0.313-1
- Merge branch 'master' of github.dbg.westfield.com:digital/customer_console
  (ben@germanforblack.com)
- Don't let the filter buttons content overflow. (ben@germanforblack.com)

* Tue Aug 06 2013 ci <doperations@au.westfield.com> 0.0.312-1
- Merge branch 'master' of github.dbg.westfield.com:digital/customer_console
  (ben@germanforblack.com)
- Remove space in target attribute (ben@germanforblack.com)

* Tue Aug 06 2013 ci <doperations@au.westfield.com> 0.0.311-1
- Merge pull request #212 from cpearce/master (ben@germanforblack.com)
- Merge pull request #211 from mmell/master (mmell@us.westfield.com)
- Changing  to  where applicable (CPearce@au.westfield.com)
- update aaa_client gems (mike.mell@nthwave.net)

* Tue Aug 06 2013 ci <doperations@au.westfield.com> 0.0.310-1
- Remove testing centtre name (cwalsh2@au.westfield.com)
- Add fallback centre names (cwalsh2@au.westfield.com)
- Render correct status (cwalsh2@au.westfield.com)
- Merge pull request #208 from cpearce/master (cwalsh2@au.westfield.com)
- Removing white space from 'tel:' links (CPearce@au.westfield.com)
- Merge pull request #209 from bschwarz/product-browser-bootstrap
  (cwalsh2@au.westfield.com)
- Removing white space from 'tel:' links (CPearce@au.westfield.com)
- Position relative to correct position of sort options
  (ben@germanforblack.com)
- Don't use ng-switch, simply hide / show (ben@germanforblack.com)
- Bootstrap filter data from json returned by 'gon' (ben@germanforblack.com)

* Tue Aug 06 2013 ci <doperations@au.westfield.com> 0.0.309-1
- Merge pull request #210 from mwratt/fix/stores-list
  (cwalsh2@au.westfield.com)
- only renders logo html for stores with a logo (matt.wratt@trineo.co.nz)

* Tue Aug 06 2013 ci <doperations@au.westfield.com> 0.0.308-1
- Merge pull request #207 from mwratt/fix/stores-list (matt.wratt@trineo.co.nz)
- fixes IE8 maps image hidden bug (matt.wratt@trineo.co.nz)

* Tue Aug 06 2013 ci <doperations@au.westfield.com> 0.0.307-1
- Merge pull request #206 from cpearce/master (ben@germanforblack.com)
- Making sure the column dividing line always sits on top of Micello map canvas
  (CPearce@au.westfield.com)

* Tue Aug 06 2013 ci <doperations@au.westfield.com> 0.0.306-1
- Remove some of the hackery around product service, it's no longer required
  (cwalsh2@au.westfield.com)
- Fix double render error (cwalsh2@au.westfield.com)

* Tue Aug 06 2013 ci <doperations@au.westfield.com> 0.0.305-1
- Merge pull request #204 from mwratt/fix/revert_modernizr
  (matt.wratt@trineo.co.nz)
- revert commit modernizr back to correct version (matt.wratt@trineo.co.nz)

* Tue Aug 06 2013 ci <doperations@au.westfield.com> 0.0.304-1
- Adding back in missing css/html from yesterday's commit
  (CPearce@au.westfield.com)
- Remove unused styles (CPearce@au.westfield.com)

* Tue Aug 06 2013 ci <doperations@au.westfield.com> 0.0.303-1
- 

* Tue Aug 06 2013 ci <doperations@au.westfield.com> 0.0.302-1
- Remove Karma config duplication for CI (cwalsh2@au.westfield.com)
- Default to 'Bad Gateway' error (cwalsh2@au.westfield.com)
- Add null centre option to show how it could work if centre service went down
  (cwalsh2@au.westfield.com)
- Pass through error codes if not in the range 200-299
  (cwalsh2@au.westfield.com)
- Merge pull request #202 from bschwarz/master (cwalsh2@au.westfield.com)
- Correct dependency injection (ben@germanforblack.com)
- Karma now processeses coffescript (ben@germanforblack.com)
- Move formatFilters() method into a factory: AppliedFilters
  (ben@germanforblack.com)

* Tue Aug 06 2013 ci <doperations@au.westfield.com> 0.0.301-1
- update apache configuration to work in uat (pmcinerney@au.westfield.com)

* Tue Aug 06 2013 ci <doperations@au.westfield.com> 0.0.300-1
- Merge pull request #196 from mwratt/feature/stores-list
  (matt.wratt@trineo.co.nz)
- Merge remote-tracking branch 'cpearce/feature/stores-list-final' into
  safepoint (matt.wratt@trineo.co.nz)
- Working on styling stores listing - WSF 4896 (CPearce@au.westfield.com)
- deferred logo image loading (matt.wratt@trineo.co.nz)
- minor fixes after rebase (matt.wratt@trineo.co.nz)
- fixes broken js specs (matt.wratt@trineo.co.nz)
- minor fixes after rebase (matt.wratt@trineo.co.nz)
- deferres loading of maps till required (matt.wratt@trineo.co.nz)
- adds dynamic shop logo (matt.wratt@trineo.co.nz)
- Working on styling stores listing - WSF 4896 (CPearce@au.westfield.com)
- fixes maps execution order issue (matt.wratt@trineo.co.nz)
- Working on styling stores listing - WSF-4896 (CPearce@au.westfield.com)
- Working on styling stores listing - WSF 4896 (CPearce@au.westfield.com)
- Working on styling stores listing - WSF 4896 (CPearce@au.westfield.com)
- working on styling stores listing - WSF 4896 (CPearce@au.westfield.com)
- removing unveil plugin (CPearce@au.westfield.com)
- removing unveil plugin (CPearce@au.westfield.com)
- Working on styling stores listing - WSF 4896 (CPearce@au.westfield.com)
- Working on styling stores listing - WSF 4896 (CPearce@au.westfield.com)
- Working on styling stores listing - WSF 4896 (CPearce@au.westfield.com)
- working on styling stores listing - WSF-4896 (CPearce@au.westfield.com)
- working on styling stores listing - WSF-4896 (CPearce@au.westfield.com)
- working on styling stores listing - WSF-4896 (CPearce@au.westfield.com)
- working on styling stores listing - WSF-4896 (CPearce@au.westfield.com)
- bringing Micello map styles into Detail View module
  (CPearce@au.westfield.com)
- adding new module (CPearce@au.westfield.com)
- fixes broken js specs (matt.wratt@trineo.co.nz)
- minor fixes after rebase (matt.wratt@trineo.co.nz)
- deferres loading of maps till required (matt.wratt@trineo.co.nz)
- adds dynamic shop logo (matt.wratt@trineo.co.nz)
- Working on styling stores listing - WSF 4896 (CPearce@au.westfield.com)
- fixes maps execution order issue (matt.wratt@trineo.co.nz)
- Working on styling stores listing - WSF-4896 (CPearce@au.westfield.com)
- Working on styling stores listing - WSF 4896 (CPearce@au.westfield.com)
- Working on styling stores listing - WSF 4896 (CPearce@au.westfield.com)
- working on styling stores listing - WSF 4896 (CPearce@au.westfield.com)
- removing unveil plugin (CPearce@au.westfield.com)
- removing unveil plugin (CPearce@au.westfield.com)
- Working on styling stores listing - WSF 4896 (CPearce@au.westfield.com)
- Working on styling stores listing - WSF 4896 (CPearce@au.westfield.com)
- Working on styling stores listing - WSF 4896 (CPearce@au.westfield.com)
- working on styling stores listing - WSF-4896 (CPearce@au.westfield.com)
- working on styling stores listing - WSF-4896 (CPearce@au.westfield.com)
- working on styling stores listing - WSF-4896 (CPearce@au.westfield.com)
- working on styling stores listing - WSF-4896 (CPearce@au.westfield.com)
- bringing Micello map styles into Detail View module
  (CPearce@au.westfield.com)
- adding new module (CPearce@au.westfield.com)

* Tue Aug 06 2013 ci <doperations@au.westfield.com> 0.0.299-1
- 

* Tue Aug 06 2013 ci <doperations@au.westfield.com> 0.0.298-1
- Merge pull request #201 from mwratt/fix/hours_link (matt.wratt@trineo.co.nz)
- adds link to centre hours (matt.wratt@trineo.co.nz)

* Tue Aug 06 2013 ci <doperations@au.westfield.com> 0.0.297-1
- 

* Tue Aug 06 2013 ci <doperations@au.westfield.com> 0.0.296-1
- 

* Mon Aug 05 2013 ci <doperations@au.westfield.com> 0.0.295-1
- 

* Mon Aug 05 2013 ci <doperations@au.westfield.com> 0.0.294-1
- Tidying up css formatting for icon module and changing 'em' to 'rem' for pill
  module (CPearce@au.westfield.com)

* Mon Aug 05 2013 ci <doperations@au.westfield.com> 0.0.293-1
- Hack: Tiles now link to _self to stop angular grabbing the links
  (cwalsh2@au.westfield.com)

* Mon Aug 05 2013 ci <doperations@au.westfield.com> 0.0.292-1
- Merge pull request #197 from cpearce/master (cpearce@au.westfield.com)
- Changing layouts to use new '.container' extenders and adding bottom padding
  to 'body' element (CPearce@au.westfield.com)

* Mon Aug 05 2013 ci <doperations@au.westfield.com> 0.0.291-1
- Merge pull request #193 from ldewey/WSF-4893 (cpearce@au.westfield.com)
- PR feed back fixes (ldewey@au.westfield.com)
- Using "@extend %%mrg-base;" on table captions (ldewey@au.westfield.com)
- Tests and refactor of centre hours (ldewey@au.westfield.com)
- trading hours test cleanup (ldewey@au.westfield.com)
- Made the hero paragraph optionl (ldewey@au.westfield.com)
- Added hours table (ldewey@au.westfield.com)
- Centre hours (ewee@au.westfield.com)

* Mon Aug 05 2013 ci <doperations@au.westfield.com> 0.0.290-1
- 

* Mon Aug 05 2013 ci <doperations@au.westfield.com> 0.0.289-1
- Cleaning up IE8 Micello maps CSS (CPearce@au.westfield.com)

* Fri Aug 02 2013 ci <doperations@au.westfield.com> 0.0.288-1
- 

* Fri Aug 02 2013 ci <doperations@au.westfield.com> 0.0.287-1
- Merge pull request #189 from cawalsh/master (cwalsh2@au.westfield.com)
- WSF-4649 Add category matches (cwalsh2@au.westfield.com)

* Fri Aug 02 2013 ci <doperations@au.westfield.com> 0.0.286-1
- 

* Fri Aug 02 2013 ci <doperations@au.westfield.com> 0.0.285-1
- add slash to allow /api redirect to work (charles.horn@gmail.com)

* Fri Aug 02 2013 ci <doperations@au.westfield.com> 0.0.284-1
- 

* Fri Aug 02 2013 ci <doperations@au.westfield.com> 0.0.283-1
- Merge pull request #191 from mwratt/feature/maps_enterprise_key
  (ldewey@au.westfield.com)
- updated key to latest/correct key (matt.wratt@trineo.co.nz)

* Thu Aug 01 2013 ci <doperations@au.westfield.com> 0.0.282-1
- Merge pull request #188 from cawalsh/feature/global_search
  (cwalsh2@au.westfield.com)
- Fix more minification issues (cwalsh2@au.westfield.com)

* Thu Aug 01 2013 ci <doperations@au.westfield.com> 0.0.281-1
- Merge pull request #187 from mwratt/feature/maps_enterprise_key
  (ldewey@au.westfield.com)
- updates micello key to enterprise (matt.wratt@trineo.co.nz)

* Thu Aug 01 2013 ci <doperations@au.westfield.com> 0.0.280-1
- Fix minification issues with product browse (cwalsh2@au.westfield.com)
- Fix minification issues in global search (cwalsh2@au.westfield.com)

* Wed Jul 31 2013 ci <doperations@au.westfield.com> 0.0.279-1
- Merge pull request #185 from csmith/master (craigM.smith@au.westfield.com)
- Update service helper to deal with new sys test envs
  (craigm.smith@au.westfield.com)

* Wed Jul 31 2013 ci <doperations@au.westfield.com> 0.0.278-1
- Merge pull request #181 from cawalsh/feature/global_search
  (cwalsh2@au.westfield.com)
- Run Karma tests on CI (cwalsh2@au.westfield.com)
- WSF-4649 Tests for remaining words, fix bug with too many spaces in query
  string (cwalsh2@au.westfield.com)
- WSF-4649 Karma tests for SuggestionsBuilder (cwalsh2@au.westfield.com)
- WSF-4649 Fix bug when to_sentence not given key (cwalsh2@au.westfield.com)
- WSF-4649 Basic spec for submitting the search form (cwalsh2@au.westfield.com)
- WSF-4649 Add capybara, launchy and poltergeist for deeper stack testing
  (cwalsh2@au.westfield.com)
- WSF-4649 Add hidden submit button to enable capybara testing
  (cwalsh2@au.westfield.com)
- WSF-4649 Use box/island classes to achieve white background with padding
  (cwalsh2@au.westfield.com)
- WSF-4649 Add a 'products matching' query to catch everything else
  (cwalsh2@au.westfield.com)
- WSF-4649 Show/Hide search results bar based on number of results
  (cwalsh2@au.westfield.com)
- WSF-4649 Fix namespace clashes with Ben's code (cwalsh2@au.westfield.com)
- WSF-4649 Show/Hide search results dropdown and let enter take you to product
  browse (cwalsh2@au.westfield.com)
- WSF-4649 Capitalise, set to blank when query blank (cwalsh2@au.westfield.com)
- WSF-4649 Generate URLs (cwalsh2@au.westfield.com)
- WSF-4649 Use Angular  instead of jQuery.ajax (cwalsh2@au.westfield.com)
- WSF-4649 Hide duplicate items in a result (cwalsh2@au.westfield.com)
- WSF-4649 Cleaning up, fixing error (cwalsh2@au.westfield.com)
- WSF-4649 Works with SS #ef62e85, but needs cleanup, and keeps throwing errors
  (cwalsh2@au.westfield.com)
- WSF-4649 WIP Proof of concept integration with search service as of 53ea491
  (cwalsh2@au.westfield.com)

* Wed Jul 31 2013 ci <doperations@au.westfield.com> 0.0.277-1
- Merge pull request #184 from cpearce/master (cpearce@au.westfield.com)
- removing links from header and various clean ups for base stylesheets
  (CPearce@au.westfield.com)

* Wed Jul 31 2013 ci <doperations@au.westfield.com> 0.0.276-1
- Include angular-sanitize.js in karma tests (cwalsh2@au.westfield.com)

* Wed Jul 31 2013 ci <doperations@au.westfield.com> 0.0.275-1
- Adding global link style (CPearce@au.westfield.com)
- Removing fade in CSS animation on body element (CPearce@au.westfield.com)
- unfixing the header (CPearce@au.westfield.com)

* Tue Jul 30 2013 ci <doperations@au.westfield.com> 0.0.274-1
- Product tile fixes (ldewey@au.westfield.com)

* Mon Jul 29 2013 ci <doperations@au.westfield.com> 0.0.273-1
- HACK - Fix image on product tile, Leon will fix this up.
  (cwalsh2@au.westfield.com)

* Mon Jul 29 2013 ci <doperations@au.westfield.com> 0.0.272-1
- Chose the 0e0d50818fdd585de5170eef68a164965c3f90bc diff of this spec (passes
  build) (ben@germanforblack.com)
- Added angular-sanitize (ben@germanforblack.com)
- Target _self for header links. Angular will otherwise take over the links on
  the page. (ben@germanforblack.com)
- Use entire path for products endpoint (ben@germanforblack.com)
- ng-bind-html-unsafe has been removed in favour of using $sce (Ref:
  https://github.com/angular/angular.js/pull/3306/files)
  (ben@germanforblack.com)
- Set the base for angular routing / location (ben@germanforblack.com)
- Use document.location.path rather than $location.path (Cross browser fix)
  (ben@germanforblack.com)
- Update angular (Closes router issue for oldIE) (ben@germanforblack.com)
- Set correct icons for mobile (ben@germanforblack.com)
- Added apply button to price range. Price range fields to be able to have
  strings (ben@germanforblack.com)
- Remove counts from filters (ben@germanforblack.com)
- Implemented script for special drop downs (ben@germanforblack.com)
- Styles for filter buttons on desktop breakpoint (ben@germanforblack.com)
- Removed canned search && centre selector (Can be re-added when thew features
  are played) (ben@germanforblack.com)
- Updated styles for canned search bar. (ben@germanforblack.com)
- No drop down. This feature isn't being built yet! (ben@germanforblack.com)
- Render index (ben@germanforblack.com)
- Replaced boilerplate markup with app (ben@germanforblack.com)
- Styles for dropdowns and filters (ben@germanforblack.com)
- Added karma tests for search facet & param cleaner (ben@germanforblack.com)
- Added toggle visibility directive (ben@germanforblack.com)
- Updated layout for new-index (ben@germanforblack.com)
- Unveil updated to 1.1.0 (ben@germanforblack.com)
- Added angular-mocks for tests (ben@germanforblack.com)
- Updated to bower 1.0.0 (ben@germanforblack.com)
- Added new button style, white. Added compact button style for when button
  only contains an icon (ben@germanforblack.com)
- Added nav contextual layout (ben@germanforblack.com)
- Check facet 'value' attribute exists (ben@germanforblack.com)
- Use hash bang (ben@germanforblack.com)
- Added updated icon font (ben@germanforblack.com)
- Added angular app to the body. No adverse effects for pages that aren't using
  angular (ben@germanforblack.com)
- Added first cut of contextual navigation (ben@germanforblack.com)
- Show the back button for the palm only (ben@germanforblack.com)
- Added global rule for search element appearance (ben@germanforblack.com)
- Use a ghost element for the calculated header height (ben@germanforblack.com)
- Remove misplaced class (ben@germanforblack.com)
- Split drop down and filters apart (ben@germanforblack.com)
- Added drop down menu (ben@germanforblack.com)
- Return the facet, not the facet in an array (ben@germanforblack.com)
- Added onChange callback system for Products service. (ben@germanforblack.com)
- Working up filter markup & styles (ben@germanforblack.com)
- Remove angular from bower (ben@germanforblack.com)
- Product tile has image details passed into the partial
  (ben@germanforblack.com)
- Close button (ben@germanforblack.com)
- Remove development styles Added reference to filter module
  (ben@germanforblack.com)
- Remove angular routing (ben@germanforblack.com)
- Added conditional method for when there are no filters
  (ben@germanforblack.com)
- Left alignment for items with a pointer (ben@germanforblack.com)
- Add first cut edition of filter styles (ben@germanforblack.com)
- Send through the title of a given facet (ben@germanforblack.com)
- Completed implementation for tags (ben@germanforblack.com)
- Infinite scroll not coming in yet (ben@germanforblack.com)
- Added new products controller (ben@germanforblack.com)
- Added initial tag styles (ben@germanforblack.com)
- Don't use routes to initialise product browse controller
  (ben@germanforblack.com)
- Update angular-head (ben@germanforblack.com)
- Rename product browse controller Remove use of $routeParams due to bugs in
  angular that aren't fixed in HEAD. Parse centre name from the url
  (ben@germanforblack.com)
- Cleaned up stub deprecation, warnings (ldewey@au.westfield.com)
- Added colours and sizes multi-facets (ben@germanforblack.com)
- Split Search and Product services (ben@germanforblack.com)
- Show products rendered by rails initially, then remove them when angular is
  invoked. (ben@germanforblack.com)
- Added a partial to be rendered either by rails, or a angular ajax request
  (ben@germanforblack.com)
- Render a partial, or the full layout — depending on XHR
  (ben@germanforblack.com)
- Remove CORS configuration for angular. Tell rails that the http request is a
  XMLHTTPRequest (ben@germanforblack.com)
- Moved init/tiles to create a namespace for window.initPlugin
  (ben@germanforblack.com)
- Added product service (ben@germanforblack.com)
- Return an object for search facets (ben@germanforblack.com)
- Made Search#params private after overreaching into the service. Added method
  to return a copy of the params that can't be modified
  (ben@germanforblack.com)
- Fixing deal show issues (craigm.smith@au.westfield.com)
- * Move search facet parsing to its own service * Implement categories *
  Implement filter clearing (ben@germanforblack.com)
- Service not in use (ben@germanforblack.com)
- Inject ngMobile (Tap support) (ben@germanforblack.com)
- Make it easier to see whats going on (ben@germanforblack.com)
- Implemented range / price queries (ben@germanforblack.com)
- * Add price facet * Add mechanism to reset all params to default
  (ben@germanforblack.com)
- Added angular mobile for tap support (ben@germanforblack.com)
- * Added basic loader * Updated methods for multi facet search values * Store
  all params on the customer's url bar and retrieve them on initialisation of
  the application (ben@germanforblack.com)
- Added routes to pass the centre name (ben@germanforblack.com)
- Added angular-head (not in bower) — Temporary until unstable-1.1.6 is
  released. (ben@germanforblack.com)
- Added ParamCleaner service. This prepares params that are compatible with the
  search api. (ben@germanforblack.com)
- Remove directive (ben@germanforblack.com)
- Implement selected filters / remove active filters feature
  (ben@germanforblack.com)
- Render new index (ben@germanforblack.com)
- Add "Show selected filters" to the todo list (ben@germanforblack.com)
- Added throw-away styles to make it manageable for development Added view for
  product browser (ben@germanforblack.com)
- Not a bug! (ben@germanforblack.com)
- Tidy up (ben@germanforblack.com)
- Todo notes (ben@germanforblack.com)
- Filter isn't being used, so don't inject it (ben@germanforblack.com)
- Added stubbed category service (ben@germanforblack.com)
- Added ngChecklist directive (ben@germanforblack.com)
- Added product browser controller (ben@germanforblack.com)
- Add base app. We'll be using CORS, so enable it globally.
  (ben@germanforblack.com)
- Added search service (ben@germanforblack.com)
- Include angular in application. Load any angular files
  (ben@germanforblack.com)
- Added angular-unstable (ben@germanforblack.com)

* Fri Jul 26 2013 ci <doperations@au.westfield.com> 0.0.271-1
- Merge pull request #176 from mwratt/fix/ie_js (ben@germanforblack.com)
- delays running of problem scripts until page ready (matt.wratt@trineo.co.nz)

* Thu Jul 25 2013 ci <doperations@au.westfield.com> 0.0.270-1
- Merge pull request #175 from ldewey/master (matt.wratt@trineo.co.nz)
- Changed nil to blank for social shares (ldewey@au.westfield.com)

* Thu Jul 25 2013 ci <doperations@au.westfield.com> 0.0.269-1
- Merge pull request #174 from ldewey/WSF-4933 (cpearce@au.westfield.com)
- Border radius fix up for social shares, when on tiles.
  (ldewey@au.westfield.com)

* Thu Jul 25 2013 ci <doperations@au.westfield.com> 0.0.268-1
- Added save button back in. (ldewey@au.westfield.com)

* Thu Jul 25 2013 ci <doperations@au.westfield.com> 0.0.267-1
- fixes white stip on micello map level selector (matt.wratt@trineo.co.nz)

* Thu Jul 25 2013 ci <doperations@au.westfield.com> 0.0.266-1
- The tiles will now pass the right link to the social shares.
  (ldewey@au.westfield.com)

* Wed Jul 24 2013 ci <doperations@au.westfield.com> 0.0.265-1
- Merge pull request #170 from ldewey/master (matt.wratt@trineo.co.nz)
- Cleaning up and bug fixing for the tile urls (ldewey@au.westfield.com)

* Wed Jul 24 2013 ci <doperations@au.westfield.com> 0.0.264-1
- uses asset_path becuase filenames change in prod (matt.wratt@trineo.co.nz)
- Merge pull request #168 from ldewey/WSF-4933 (ldewey@au.westfield.com)
- Tile/socal share z-index fix (ldewey@au.westfield.com)

* Wed Jul 24 2013 ci <doperations@au.westfield.com> 0.0.263-1
- Touch device fix for social shares (ldewey@au.westfield.com)

* Wed Jul 24 2013 ci <doperations@au.westfield.com> 0.0.262-1
- Merge pull request #166 from mwratt/feature/map_dependency_injection
  (ldewey@au.westfield.com)
- removed duplicate map popup partial (matt.wratt@trineo.co.nz)

* Wed Jul 24 2013 ci <doperations@au.westfield.com> 0.0.261-1
- Merge pull request #165 from ldewey/master (matt.wratt@trineo.co.nz)
- Tile fixes (ldewey@au.westfield.com)

* Wed Jul 24 2013 ci <doperations@au.westfield.com> 0.0.260-1
- Merge pull request #164 from mwratt/feature/map_dependency_injection
  (ldewey@au.westfield.com)
- hides stores list (matt.wratt@trineo.co.nz)
- uses modernizer to check map support (matt.wratt@trineo.co.nz)

* Wed Jul 24 2013 ci <doperations@au.westfield.com> 0.0.259-1
- Build fix (ldewey@au.westfield.com)
- Systest fix (ldewey@au.westfield.com)

* Wed Jul 24 2013 ci <doperations@au.westfield.com> 0.0.258-1
- Merge pull request #161 from ldewey/WSF-4933-image-cleanup
  (matt.wratt@trineo.co.nz)
- responsive becomes retina, as this is what its really doing.
  (ldewey@au.westfield.com)
- Removed responsive_image_tag, and made ImageService responsive
  (ldewey@au.westfield.com)

* Tue Jul 23 2013 ci <doperations@au.westfield.com> 0.0.257-1
- 

* Tue Jul 23 2013 ci <doperations@au.westfield.com> 0.0.256-1
- Merge pull request #160 from ldewey/WSF-4933 (matt.wratt@trineo.co.nz)
- Added in commented deal fields (ldewey@au.westfield.com)
- Merge pull request #159 from mwratt/feature/maps (ldewey@au.westfield.com)
- adds missing floor (no image currently) (matt.wratt@trineo.co.nz)
- renames ie map stylesheet to match convention (matt.wratt@trineo.co.nz)
- restuctures map namespace for better understanding (matt.wratt@trineo.co.nz)

* Tue Jul 23 2013 ci <doperations@au.westfield.com> 0.0.255-1
- Merge pull request #157 from ldewey/WSF-4933 (cpearce@au.westfield.com)
- Css fixes for social tiles (ldewey@au.westfield.com)
- Added a wrapper the social shares, for the tiles. (ldewey@au.westfield.com)
- Event spec fix (ldewey@au.westfield.com)
- Tile clean up and added socal links (ldewey@au.westfield.com)
- A start tile socal styles (ldewey@au.westfield.com)
- Added page titles (ldewey@au.westfield.com)
- Event specs (ldewey@au.westfield.com)

* Tue Jul 23 2013 ci <doperations@au.westfield.com> 0.0.254-1
- Merge pull request #155 from mwratt/feature/maps (ldewey@au.westfield.com)
- extracts micello address api url into own method (matt.wratt@trineo.co.nz)
- Display the movie classification (craigm.smith@au.westfield.com)
- refactor and split up javascript for maps (matt.wratt@trineo.co.nz)

* Tue Jul 23 2013 ci <doperations@au.westfield.com> 0.0.253-1
- Merge pull request #146 from ldewey/apache_modules (ldewey@au.westfield.com)
- More apache rules/config (ldewey@au.westfield.com)

* Tue Jul 23 2013 ci <doperations@au.westfield.com> 0.0.252-1
- Build fix (ldewey@au.westfield.com)
- Merge pull request #151 from mwratt/feature/maps (ldewey@au.westfield.com)
- Merge pull request #153 from ldewey/aaa (mike.mell@nthwave.net)
- Removed _header_visitor.html.erb (ldewey@au.westfield.com)
- removes non-ie specific styles (matt.wratt@trineo.co.nz)
- moves ie maps import to ie specific style sheet (matt.wratt@trineo.co.nz)
- makes centre levels for ie maps dynamic (matt.wratt@trineo.co.nz)
- adds mouse drag to IE8 maps (matt.wratt@trineo.co.nz)
- adds zoom to IE8 versions of maps (matt.wratt@trineo.co.nz)
- adds partial IE8 support (matt.wratt@trineo.co.nz)

* Tue Jul 23 2013 ci <doperations@au.westfield.com> 0.0.251-1
- 

* Tue Jul 23 2013 ci <doperations@au.westfield.com> 0.0.250-1
- create visitor controller (mike.mell@nthwave.net)

* Fri Jul 19 2013 ci <doperations@au.westfield.com> 0.0.249-1
- Merge pull request #149 from ldewey/master (ewee@au.westfield.com)
- Added 404 on centre show for when a centre does not exist.
  (ldewey@au.westfield.com)

* Fri Jul 19 2013 ci <doperations@au.westfield.com> 0.0.248-1
- Merge pull request #147 from mmell/aaa_service_documentation
  (ldewey@au.westfield.com)
- add AAA Service api links (mike.mell@nthwave.net)

* Fri Jul 19 2013 ci <doperations@au.westfield.com> 0.0.247-1
- Merge pull request #148 from cpearce/master (matt.wratt@trineo.co.nz)
- making 'store details' button clickable for detail view maps and setting up
  structure for 'Stores' (CPearce@au.westfield.com)

* Fri Jul 19 2013 ci <doperations@au.westfield.com> 0.0.246-1
- rename app from Customerconsole to CustomerConsole (mike.mell@nthwave.net)

* Thu Jul 18 2013 ci <doperations@au.westfield.com> 0.0.245-1
- Added correct markup for Cinema images. (craigm.smith@au.westfield.com)

* Thu Jul 18 2013 ci <doperations@au.westfield.com> 0.0.244-1
- Update customer_console.conf (ldewey@au.westfield.com)

* Thu Jul 18 2013 ci <doperations@au.westfield.com> 0.0.243-1
- Merge pull request #143 from ldewey/master (matt.wratt@trineo.co.nz)
- Fixing stores docs link (ldewey@au.westfield.com)
- Proper MIME types for all files (ldewey@au.westfield.com)

* Thu Jul 18 2013 ci <doperations@au.westfield.com> 0.0.242-1
- Merge pull request #142 from ldewey/master (matt.wratt@trineo.co.nz)
- Added published flag to events (ldewey@au.westfield.com)

* Thu Jul 18 2013 ci <doperations@au.westfield.com> 0.0.241-1
- Merge pull request #140 from csmith/feature/store_details_on_movie_index
  (ldewey@au.westfield.com)
- Add the store information on the movies page. (craigm.smith@au.westfield.com)

* Thu Jul 18 2013 ci <doperations@au.westfield.com> 0.0.240-1
- Filter by nearby centres (cwalsh2@au.westfield.com)

* Wed Jul 17 2013 ci <doperations@au.westfield.com> 0.0.239-1
- Merge pull request #135 from mwratt/feature/deal-map-insert
  (cwalsh2@au.westfield.com)
- Build fix, the url calling VCR was based on today. (ldewey@au.westfield.com)
- Merge pull request #137 from csmith/master (ldewey@au.westfield.com)
- Added the movie show page. (craigm.smith@au.westfield.com)
- centre stores only passed to the map (matt.wratt@trineo.co.nz)
- extracts popup into own views, fixes js disabled (matt.wratt@trineo.co.nz)

* Tue Jul 16 2013 ci <doperations@au.westfield.com> 0.0.238-1
- Merge pull request #136 from cpearce/master (ldewey@au.westfield.com)
- changing heading levels for events/deals/products detail views
  (CPearce@au.westfield.com)

* Tue Jul 16 2013 ci <doperations@au.westfield.com> 0.0.237-1
- 

* Tue Jul 16 2013 ci <doperations@au.westfield.com> 0.0.236-1
- start of the 'Stores' styling (CPearce@au.westfield.com)
- re-working social share module to make it reusable with 'tiles'
  (CPearce@au.westfield.com)
- adding fix for absolutely positioned elements in 'main'
  (CPearce@au.westfield.com)
- adding new module (CPearce@au.westfield.com)

* Tue Jul 16 2013 ci <doperations@au.westfield.com> 0.0.235-1
- 

* Tue Jul 16 2013 ci <doperations@au.westfield.com> 0.0.234-1
- Merge pull request #133 from mwratt/fix/build_rpm_host
  (mmancuso@au.westfield.com)
- corrected new deployment host (matt.wratt@trineo.co.nz)

* Tue Jul 16 2013 ci <doperations@au.westfield.com> 0.0.233-1
- Merge pull request #128 from ewee/master (ldewey@au.westfield.com)
- Convert trading hour time to 12 hour format (ewee@au.westfield.com)

* Tue Jul 16 2013 ci <doperations@au.westfield.com> 0.0.232-1
- updates deployment host as per recent ops changes (matt.wratt@trineo.co.nz)

* Tue Jul 16 2013 ci <doperations@au.westfield.com> 0.0.231-1
- Merge pull request #130 from mwratt/feature/deal-map-insert
  (ldewey@au.westfield.com)
- adds code required for maps to deals controller (matt.wratt@trineo.co.nz)
- tweaks map UX and popup overlay (matt.wratt@trineo.co.nz)

* Mon Jul 15 2013 ci <doperations@au.westfield.com> 0.0.230-1
- Bug fix. (craigm.smith@au.westfield.com)

* Mon Jul 15 2013 ci <doperations@au.westfield.com> 0.0.229-1
- Use routes helpers (craigm.smith@au.westfield.com)
- Show the list of days sessions are available and allow the user to filter
  movies by those days. (craigm.smith@au.westfield.com)

* Mon Jul 15 2013 ci <doperations@au.westfield.com> 0.0.228-1
- Merge pull request #124 from cpearce/master (ldewey@au.westfield.com)
- changing icons over to IcoMoon (CPearce@au.westfield.com)
- finishing detail view controls and a few touch ups for product/deal detail
  views (CPearce@au.westfield.com)

* Mon Jul 15 2013 ci <doperations@au.westfield.com> 0.0.227-1
- Merge pull request #127 from ldewey/master (craigM.smith@au.westfield.com)
- Cleaned up stub deprecation, warnings (ldewey@au.westfield.com)

* Mon Jul 15 2013 ci <doperations@au.westfield.com> 0.0.226-1
- Merge pull request #125 from ldewey/master (craigM.smith@au.westfield.com)
- Fixed up dates for events (ldewey@au.westfield.com)

* Fri Jul 12 2013 ci <doperations@au.westfield.com> 0.0.225-1
- Merge pull request #123 from ldewey/master (matt.wratt@trineo.co.nz)
- CSS/SASS minification fix (ldewey@au.westfield.com)

* Fri Jul 12 2013 ci <doperations@au.westfield.com> 0.0.224-1
- 

* Fri Jul 12 2013 ci <doperations@au.westfield.com> 0.0.223-1
- Merge pull request #122 from cpearce/master (ldewey@au.westfield.com)
- working on detail view controls (CPearce@au.westfield.com)
- adding a new helper to get the current URL (CPearce@au.westfield.com)
- fixing 'z-index' values to make the site more bullet proof
  (CPearce@au.westfield.com)
- tidying up drop down abstraction formatting (CPearce@au.westfield.com)

* Thu Jul 11 2013 ci <doperations@au.westfield.com> 0.0.222-1
- Merge pull request #120 from csmith/master (ldewey@au.westfield.com)
- Removed comments (craigm.smith@au.westfield.com)
- Fixing deal show issues (craigm.smith@au.westfield.com)

* Thu Jul 11 2013 ci <doperations@au.westfield.com> 0.0.221-1
- Merge pull request #121 from ldewey/master (ben@germanforblack.com)
- The dev proxy should now work if you are using localhost:3000 etc
  (ldewey@au.westfield.com)

* Thu Jul 11 2013 ci <doperations@au.westfield.com> 0.0.220-1
- Merge pull request #118 from cpearce/master (ldewey@au.westfield.com)
- removing bottom border for header as it should only be for centre home page
  version (CPearce@au.westfield.com)
- adding non JS fallback and updating position of 'if' statement for products
  show (CPearce@au.westfield.com)
- working on finalising product/deal detail views (CPearce@au.westfield.com)
- adding a new button (CPearce@au.westfield.com)
- removing redundant text-decoration rules (CPearce@au.westfield.com)
- removing redundant toggle button rules (CPearce@au.westfield.com)
- adding a new button (CPearce@au.westfield.com)
- cleaning up indentation (CPearce@au.westfield.com)
- adding bottom spacing for non-palm (CPearce@au.westfield.com)
- fixing up bg image path (CPearce@au.westfield.com)
- removing redudant rules (CPearce@au.westfield.com)
- increasing the z-index of the fixed header to ensure any absolutely
  positioned elements outside of the header will always sit under it
  (CPearce@au.westfield.com)
- Updating IE7 fallback msg after product owner review
  (CPearce@au.westfield.com)

* Thu Jul 11 2013 ci <doperations@au.westfield.com> 0.0.219-1
- Added uat symlink of config/environments/production.rb
  (ldewey@au.westfield.com)
- Fix /api to work like /api/ does (cwalsh2@au.westfield.com)

* Wed Jul 10 2013 ci <doperations@au.westfield.com> 0.0.218-1
- update links to imageservice and fileservice (acohen@au.westfield.com)

* Wed Jul 10 2013 ci <doperations@au.westfield.com> 0.0.217-1
- Open deals and events tab up in swagger (craigm.smith@au.westfield.com)
- Fixed small bug that was preventing swagger from working.
  (craigm.smith@au.westfield.com)
- Removing unused code. (craigm.smith@au.westfield.com)

* Wed Jul 10 2013 ci <doperations@au.westfield.com> 0.0.216-1
- Updated API list to include swagger API docs. (craigm.smith@au.westfield.com)

* Wed Jul 10 2013 ci <doperations@au.westfield.com> 0.0.215-1
- Add category API docs link and sort alphabetically (malc@wholemeal.co.nz)

* Wed Jul 10 2013 ci <doperations@au.westfield.com> 0.0.214-1
- Merge pull request #112 from mwratt/feature/deal-map-insert
  (cwalsh2@au.westfield.com)
- adds retailer_code to filter the store in the map (matt.wratt@trineo.co.nz)

* Wed Jul 10 2013 ci <doperations@au.westfield.com> 0.0.213-1
- Precompile flexslider assets (cwalsh2@au.westfield.com)
- WSF-4294 Display only 4 images on carousel (cwalsh2@au.westfield.com)

* Tue Jul 09 2013 ci <doperations@au.westfield.com> 0.0.212-1
- Merge pull request #113 from cpearce/master (ldewey@au.westfield.com)
- removing some rules to temporarily fix 'Stores' (CPearce@au.westfield.com)
- working on map component for product detail view (CPearce@au.westfield.com)
- messing with the logo size to stress test (CPearce@au.westfield.com)
- renaming selector so doesn't conflict with Micello map module
  (CPearce@au.westfield.com)
- update module name: map = map-micello (CPearce@au.westfield.com)
- update for non JS users to content isn't hidden (CPearce@au.westfield.com)

* Tue Jul 09 2013 ci <doperations@au.westfield.com> 0.0.211-1
- Only show unique colours (cwalsh2@au.westfield.com)
- Don't show 'also available at' if there aren't any centres
  (cwalsh2@au.westfield.com)

* Tue Jul 09 2013 ci <doperations@au.westfield.com> 0.0.210-1
- 

* Tue Jul 09 2013 ci <doperations@au.westfield.com> 0.0.209-1
- Link through to products from the product stream (cwalsh2@au.westfield.com)
- Fix available colours display (cwalsh2@au.westfield.com)
- Fix products tile links (cwalsh2@au.westfield.com)

* Tue Jul 09 2013 ci <doperations@au.westfield.com> 0.0.208-1
- Fix 500 if no colours on product (cwalsh2@au.westfield.com)

* Tue Jul 09 2013 ci <doperations@au.westfield.com> 0.0.207-1
- Remove hashie requires and just autorequire from Gemfile
  (cwalsh2@au.westfield.com)

* Tue Jul 09 2013 ci <doperations@au.westfield.com> 0.0.206-1
- WSF-4294 Fix code review findings (cwalsh2@au.westfield.com)
- Fix alt tags (cwalsh2@au.westfield.com)
- WSF-4924 Show 'also available at' (cwalsh2@au.westfield.com)
- WSF-4924 Build stores from json - should make the Store model do this
  (cwalsh2@au.westfield.com)
- WSF-4924 Build Centre models from centre_service - they have a short name
  (cwalsh2@au.westfield.com)
- WSF-4924 Link up the 'also available at' centres (cwalsh2@au.westfield.com)
- WSF-4924 Add Photo of product.name as alt tag (cwalsh2@au.westfield.com)
- WSF-4924 Hook up images and colours (cwalsh2@au.westfield.com)
- WSF-4924 Use a Product model to contain product logic
  (cwalsh2@au.westfield.com)
- WSF-4924 Hook up product name, price, retailer name, phone no, desc.
  (cwalsh2@au.westfield.com)
- WSF-4924 Add the Money gem for money formatting (cwalsh2@au.westfield.com)

* Tue Jul 09 2013 ci <doperations@au.westfield.com> 0.0.205-1
- Merge pull request #111 from ldewey/master (ldewey@au.westfield.com)
- Moved swagger into the API folder (ldewey@au.westfield.com)

* Tue Jul 09 2013 ci <doperations@au.westfield.com> 0.0.204-1
- Systest fix, only require the service proxy in dev (ldewey@au.westfield.com)

* Tue Jul 09 2013 ci <doperations@au.westfield.com> 0.0.203-1
- Merge pull request #109 from ldewey/master (matt.wratt@trineo.co.nz)
- Renamed app proxy to service proxy (ldewey@au.westfield.com)
- Added proxy and swagger ui (ldewey@au.westfield.com)
- Gem update (ldewey@au.westfield.com)

* Mon Jul 08 2013 ci <doperations@au.westfield.com> 0.0.202-1
- Moved the parsing of deal available_to date in to the model.
  (craigm.smith@au.westfield.com)
- Added link to movies. (craigm.smith@au.westfield.com)
- Make the terms and conditions display code a little more readable.
  (craigm.smith@au.westfield.com)
- HTML editing has been removed so preserving the white space like this.
  (craigm.smith@au.westfield.com)
- Merge pull request #105 from cpearce/master (ldewey@au.westfield.com)
- fixing up the bg image for retina (CPearce@au.westfield.com)
- removing redundant @mixin (CPearce@au.westfield.com)
- updating bg image path to use asset pipeline (CPearce@au.westfield.com)
- Merge pull request #104 from csmith/master (ldewey@au.westfield.com)
- working on deal detail view (CPearce@au.westfield.com)
- adding toggle content plugin and styles (CPearce@au.westfield.com)
- fixing annoying Chrome bug and tidying up 'Pointer' extender
  (CPearce@au.westfield.com)
- finalising box--torn abstraction (CPearce@au.westfield.com)
- removing hover state for search toggle button at palm size as it sticks
  (CPearce@au.westfield.com)
- adding a 'Firefox' specific hook to make it behave (CPearce@au.westfield.com)
- adding a new abstraction - 'Toggle Content' (CPearce@au.westfield.com)
- tidying up broken characters (CPearce@au.westfield.com)
- Added images to movies page. (craigm.smith@au.westfield.com)

* Fri Jul 05 2013 ci <doperations@au.westfield.com> 0.0.201-1
- adds zoom to and inserts map into product show (matt.wratt@trineo.co.nz)
- adds default store pre-select to maps (matt.wratt@trineo.co.nz)

* Fri Jul 05 2013 ci <doperations@au.westfield.com> 0.0.200-1
- Merge pull request #101 from ldewey/master (cpearce@au.westfield.com)
- Removed code thats not working / not used (ldewey@au.westfield.com)
- Indentation fixup (ldewey@au.westfield.com)

* Fri Jul 05 2013 ci <doperations@au.westfield.com> 0.0.199-1
- Delete .ruby-version, Gemfile does the job with ruby 2.0.0 anyway
  (cwalsh2@au.westfield.com)

* Fri Jul 05 2013 ci <doperations@au.westfield.com> 0.0.198-1
- Merge pull request #100 from cpearce/master (ldewey@au.westfield.com)
- adding hooks to 'Deal Main' module (CPearce@au.westfield.com)
- adding a new module - 'Deal Main' (CPearce@au.westfield.com)
- adding a new extender (WIP) (CPearce@au.westfield.com)
- cleaning up comments (CPearce@au.westfield.com)
- cleaning up comments (CPearce@au.westfield.com)
- cleaning up comments (CPearce@au.westfield.com)
- adding text colour to make it more legible (CPearce@au.westfield.com)
- Fixing up indentation (CPearce@au.westfield.com)
- adding a new module: 'Deal Main' (CPearce@au.westfield.com)
- adding 'box' abstraction to detail view layout (CPearce@au.westfield.com)

* Fri Jul 05 2013 ci <doperations@au.westfield.com> 0.0.197-1
- Assign @product on products#show (cwalsh2@au.westfield.com)
- Change product show URL to include retailer code and sku
  (cwalsh2@au.westfield.com)
- ProductService - work with show url too (cwalsh2@au.westfield.com)
- Product Service url has changed, no need to use AppConfig now.
  (cwalsh2@au.westfield.com)

* Fri Jul 05 2013 ci <doperations@au.westfield.com> 0.0.196-1
- Update trading hour method name (ewee@au.westfield.com)

* Thu Jul 04 2013 ci <doperations@au.westfield.com> 0.0.195-1
- Merge pull request #98 from cawalsh/master (ldewey@au.westfield.com)
- Use cwalsh/guard-jasmine to fix issue running specs with coverage
  (cwalsh2@au.westfield.com)

* Thu Jul 04 2013 ci <doperations@au.westfield.com> 0.0.194-1
- Merge pull request #96 from bschwarz/chris-bootstrap
  (cpearce@au.westfield.com)
- Replace bootstrap from bower with chris' edition. (ben@germanforblack.com)

* Thu Jul 04 2013 ci <doperations@au.westfield.com> 0.0.193-1
- Added description and some alt text to the store show page.
  (craigm.smith@au.westfield.com)

* Thu Jul 04 2013 ci <doperations@au.westfield.com> 0.0.192-1
- 

* Thu Jul 04 2013 ci <doperations@au.westfield.com> 0.0.191-1
- 

* Thu Jul 04 2013 ci <doperations@au.westfield.com> 0.0.190-1
- 

* Thu Jul 04 2013 ci <doperations@au.westfield.com> 0.0.189-1
- Added twitter bootstrap. Included bootstrap dropdown.
  (ben@germanforblack.com)

* Thu Jul 04 2013 ci <doperations@au.westfield.com> 0.0.188-1
- 

* Thu Jul 04 2013 ci <doperations@au.westfield.com> 0.0.187-1
- Merge pull request #94 from bschwarz/html5shiv (cpearce@au.westfield.com)
- Added print shiv to asset pipeline / build list (ben@germanforblack.com)
- Move the shiv include to !IEMobile (ben@germanforblack.com)
- Remove shiv/printshiv from modernizr in favour of its upstream edition (which
  includes the <main> element) (ben@germanforblack.com)

* Thu Jul 04 2013 ci <doperations@au.westfield.com> 0.0.186-1
- 

* Thu Jul 04 2013 ci <doperations@au.westfield.com> 0.0.185-1
- 

* Thu Jul 04 2013 ci <doperations@au.westfield.com> 0.0.184-1
- Update customerconsole.spec (ldewey@au.westfield.com)

* Thu Jul 04 2013 ci <doperations@au.westfield.com> 0.0.183-1
- Merge pull request #88 from csmith/master (ldewey@au.westfield.com)
- Merge pull request #91 from cpearce/master (ldewey@au.westfield.com)
- Merge pull request #93 from ldewey/master (ldewey@au.westfield.com)
- RPM fix for asset precompile (ldewey@au.westfield.com)
- Adding top border to meta element (CPearce@au.westfield.com)
- Adding comments and arranging properties better (CPearce@au.westfield.com)
- CSS comments (CPearce@au.westfield.com)
- removing jQuery UI slider CSS (CPearce@au.westfield.com)
- cleaning up shame CSS (CPearce@au.westfield.com)
- working on product detail view (CPearce@au.westfield.com)
- adding new colour vars (CPearce@au.westfield.com)
- working on product detail view (CPearce@au.westfield.com)
- adding main button styles (CPearce@au.westfield.com)
- working on product detail view (CPearce@au.westfield.com)
- adding hover states (CPearce@au.westfield.com)
- adding a global var (CPearce@au.westfield.com)
- The deals detail page. (craigm.smith@au.westfield.com)

* Thu Jul 04 2013 ci <doperations@au.westfield.com> 0.0.182-1
- Added required javascript files to the precompile array
  (ldewey@au.westfield.com)
- Ignore asset pipeline output (ldewey@au.westfield.com)
- Centre background images now use asset pipeline (ldewey@au.westfield.com)
- Updated style sheets to use asset pipeline (ldewey@au.westfield.com)

* Wed Jul 03 2013 ci <doperations@au.westfield.com> 0.0.181-1
- Merge pull request #90 from ldewey/master (ldewey@au.westfield.com)
- Added the hashie require (ldewey@au.westfield.com)

* Wed Jul 03 2013 ci <doperations@au.westfield.com> 0.0.180-1
- adds symlink to production env for systest (matt.wratt@trineo.co.nz)

* Wed Jul 03 2013 ci <doperations@au.westfield.com> 0.0.179-1
- Added old-ie to the precompile list (ldewey@au.westfield.com)

* Wed Jul 03 2013 ci <doperations@au.westfield.com> 0.0.178-1
- Merge pull request #85 from ldewey/master (cpearce@au.westfield.com)
- Changed dd to be nested. (ldewey@au.westfield.com)
- Added event microdata (ldewey@au.westfield.com)
- Fixed ups for event Schedule / Timeline (ldewey@au.westfield.com)

* Wed Jul 03 2013 ci <doperations@au.westfield.com> 0.0.177-1
- removes phantomjs binaries which cause rpm issues (matt.wratt@trineo.co.nz)

* Wed Jul 03 2013 ci <doperations@au.westfield.com> 0.0.176-1
- Merge branch 'master' of github.dbg.westfield.com:digital/customer_console
  (ben@germanforblack.com)
- Callback, not complete (ben@germanforblack.com)

* Wed Jul 03 2013 ci <doperations@au.westfield.com> 0.0.175-1
- * jQuery required for conditional support items * SVG when you don't have
  support for SVG! * Init placeholder after its been loaded
  (ben@germanforblack.com)
- Move enquire && init to be loaded asynchronously after the matchMedia
  polyfill(s). (ben@germanforblack.com)
- Move conditional support to be loaded before other libraries
  (ben@germanforblack.com)
- Tab space fix up (ldewey@au.westfield.com)
- Event body data is now wraped in a paragraph tag (ldewey@au.westfield.com)

* Wed Jul 03 2013 ci <doperations@au.westfield.com> 0.0.174-1
- Merge pull request #83 from bschwarz/async-enquire (ben@germanforblack.com)
- Move enquire && init to be loaded asynchronously after the matchMedia
  polyfill(s). (ben@germanforblack.com)
- Move conditional support to be loaded before other libraries
  (ben@germanforblack.com)
- Tab space fix up (ldewey@au.westfield.com)
- Event body data is now wraped in a paragraph tag (ldewey@au.westfield.com)

* Wed Jul 03 2013 ci <doperations@au.westfield.com> 0.0.173-1
- Merge pull request #81 from mwratt/master (matt.wratt@trineo.co.nz)
- excludes phantomjs binaries from rpm build (matt.wratt@trineo.co.nz)

* Wed Jul 03 2013 ci <doperations@au.westfield.com> 0.0.172-1
- removes example file (matt.wratt@trineo.co.nz)

* Wed Jul 03 2013 ci <doperations@au.westfield.com> 0.0.171-1
- Merge pull request #76 from cpearce/master (ldewey@au.westfield.com)
- Merge pull request #75 from mwratt/feature/maps (ldewey@au.westfield.com)
- updating to matchMedia.addListener for enquire lib (CPearce@au.westfield.com)
- removing angular, changing ios hook name and updating flexslider path
  (CPearce@au.westfield.com)
- Use jQuery 1.10.1 rather than 2 (ben@germanforblack.com)
- Merge branch 'master' of github.dbg.westfield.com:digital/customer_console
  (ben@germanforblack.com)
- working on product detail view (CPearce@au.westfield.com)
- fixing up some device/Old IE/Non JS issues (CPearce@au.westfield.com)
- Merge pull request #78 from bschwarz/add-flexslider
  (cpearce@au.westfield.com)
- Added flex slider (ben@germanforblack.com)
- Merge pull request #77 from bschwarz/remove-jquery-ui
  (ben@germanforblack.com)
- Kill Unicorn. kgio wouldn't install on windows and nobody used unicorn anyway
  (cwalsh2@au.westfield.com)
- Remove jquery-ui (ben@germanforblack.com)
- adds specs for the custom theme (matt.wratt@trineo.co.nz)
- adds custom theming to maps (matt.wratt@trineo.co.nz)
- Styles for the timeline (ldewey@au.westfield.com)
- Added a event model, to model the time. (ldewey@au.westfield.com)
- adds some basic tests (matt.wratt@trineo.co.nz)
- Use digital/phantomjs-binaries (cwalsh2@au.westfield.com)
- Timeline wip (ldewey@au.westfield.com)
- Merge remote-tracking branch 'origin' into introducing-bower
  (ben@germanforblack.com)
- .css.scss created issues (ldewey@au.westfield.com)
- working on product detail view (CPearce@au.westfield.com)
- fixing indentation (CPearce@au.westfield.com)
- adding a new extender (CPearce@au.westfield.com)
- tweaking base and main button styles (CPearce@au.westfield.com)
- adding a new extender (CPearce@au.westfield.com)
- adding new icons (CPearce@au.westfield.com)
- adding a new module (CPearce@au.westfield.com)
- working on product detail view (CPearce@au.westfield.com)
- adding a new size extender (CPearce@au.westfield.com)
- fixing an extender (CPearce@au.westfield.com)
- adding new extenders (CPearce@au.westfield.com)
- adding a new extender (CPearce@au.westfield.com)
- Rename enquire-blackberry to enquire (ben@germanforblack.com)
- Moved oldie helpers to a partial for the style guide layout
  (ben@germanforblack.com)
- No more ujs in the bower manifest (ben@germanforblack.com)
- Robots.txt now disallows all (ldewey@au.westfield.com)
- Remove ujs (ben@germanforblack.com)
- Add conditional support for match media, placeholder and svg
  (ben@germanforblack.com)
- Get slider styles from ./vendor (ben@germanforblack.com)
- Add console.log fallback (ben@germanforblack.com)
- Replace javascript libs with bower counterparts (ben@germanforblack.com)
- Moved tests to modernizr and "support" directory (ben@germanforblack.com)
- Added notes (ben@germanforblack.com)
- Move add bower references to items previously handled in rubygems
  (ben@germanforblack.com)
- Remove script supplied by rubygems (ben@germanforblack.com)
- Added moderniser and moved javascript detection oldie helpers to
  application.html.erb * Selectivizr from bower package
  (ben@germanforblack.com)
- Remove cloudflare dns prefetch (ben@germanforblack.com)
- Added bower support (ben@germanforblack.com)
- fixes js specs to run correctly (matt.wratt@trineo.co.nz)
- includes js specs in default rake task (matt.wratt@trineo.co.nz)
- adds jasminerice for js testing with guard for CI (matt.wratt@trineo.co.nz)

* Mon Jul 01 2013 ci <doperations@au.westfield.com> 0.0.170-1
- adds phantomjs binaries (matt.wratt@trineo.co.nz)

* Fri Jun 28 2013 ci <doperations@au.westfield.com> 0.0.169-1
- Merge pull request #69 from mwratt/feature/javascript_specs
  (matt.wratt@trineo.co.nz)
- removes phantomjs from the rpm (matt.wratt@trineo.co.nz)
- Merge pull request #68 from mwratt/feature/javascript_specs
  (matt.wratt@trineo.co.nz)
- makes phantomjs a requirement (matt.wratt@trineo.co.nz)
- Merge pull request #11 from mwratt/feature/javascript_specs
  (matt.wratt@trineo.co.nz)
- adds phantomjs as a dependency to run js tests (matt.wratt@trineo.co.nz)
- includes js specs in default rake task (matt.wratt@trineo.co.nz)
- adds jasminerice for js testing with guard for CI (matt.wratt@trineo.co.nz)

* Fri Jun 28 2013 ci <doperations@au.westfield.com> 0.0.168-1
- Merge pull request #67 from cpearce/master (ldewey@au.westfield.com)
- working on product detail view (CPearce@au.westfield.com)
- working on product detail view image carousel (CPearce@au.westfield.com)
- adding a new extender (CPearce@au.westfield.com)
- adding a new extender (CPearce@au.westfield.com)
- tidying up indentation (CPearce@au.westfield.com)
- adding new product dummy images (CPearce@au.westfield.com)

* Fri Jun 28 2013 ci <doperations@au.westfield.com> 0.0.167-1
- Merge pull request #66 from ldewey/master (tfigueiro@au.westfield.com)
- Robots.txt now disallows all (ldewey@au.westfield.com)

* Thu Jun 27 2013 ci <doperations@au.westfield.com> 0.0.166-1
- add image service and file service to index page (acohen@au.westfield.com)

* Thu Jun 27 2013 ci <doperations@au.westfield.com> 0.0.165-1
- remove individual index files from services (acohen@au.westfield.com)
- Merge pull request #65 from mwratt/feature/maps (matt.wratt@trineo.co.nz)
- removes "Unit|" from 3rd party shop number data (matt.wratt@trineo.co.nz)

* Thu Jun 27 2013 ci <doperations@au.westfield.com> 0.0.164-1
- The detal-page now has a dynamic modifier based of the controller name
  (ldewey@au.westfield.com)

* Thu Jun 27 2013 ci <doperations@au.westfield.com> 0.0.163-1
- Merge pull request #63 from mwratt/feature/maps (ldewey@au.westfield.com)
- fixes script loading race condition (matt.wratt@trineo.co.nz)

* Thu Jun 27 2013 ci <doperations@au.westfield.com> 0.0.162-1
- Merge pull request #61 from cpearce/master (ldewey@au.westfield.com)
- changing back to 'event' extender class - should be dynamic
  (CPearce@au.westfield.com)
- markup for product detail view (CPearce@au.westfield.com)
- rough styles for the image gallery carousel (CPearce@au.westfield.com)
- styles for product detail view (CPearce@au.westfield.com)
- creating styles for main and main alternate buttons
  (CPearce@au.westfield.com)
- adding a new colour var - cta (CPearce@au.westfield.com)
- small updates to 2 abstractions so they can be better used
  (CPearce@au.westfield.com)
- adding flexslider image carousel for product detail view
  (CPearce@au.westfield.com)
- adding dummy images for product detail view (CPearce@au.westfield.com)
- Ian added 'show' to the controller so I can see the page in the browser
  (CPearce@au.westfield.com)
- working on product detail view (CPearce@au.westfield.com)
- working on product detail view (CPearce@au.westfield.com)
- changing selectors to new detail view selector (CPearce@au.westfield.com)
- removing redundant styles (CPearce@au.westfield.com)

* Thu Jun 27 2013 ci <doperations@au.westfield.com> 0.0.161-1
- 

* Thu Jun 27 2013 ci <doperations@au.westfield.com> 0.0.160-1
- Added the product tile (ldewey@au.westfield.com)

* Wed Jun 26 2013 ci <doperations@au.westfield.com> 0.0.159-1
- 

* Wed Jun 26 2013 ci <doperations@au.westfield.com> 0.0.158-1
- Updated service_api (cwalsh2@au.westfield.com)
- add documentation placeholder pages (acohen@au.westfield.com)

* Wed Jun 26 2013 ci <doperations@au.westfield.com>
- Updated service_api (cwalsh2@au.westfield.com)
- add documentation placeholder pages (acohen@au.westfield.com)

* Wed Jun 26 2013 ci <doperations@au.westfield.com> 0.0.156-1
- 

* Wed Jun 26 2013 ci <doperations@au.westfield.com> 0.0.155-1
- 

* Wed Jun 26 2013 ci <doperations@au.westfield.com> 0.0.154-1
- 

* Wed Jun 26 2013 ci <doperations@au.westfield.com> 0.0.153-1
- put index into unordered list (acohen@au.westfield.com)

* Wed Jun 26 2013 ci <doperations@au.westfield.com> 0.0.152-1
- 

* Wed Jun 26 2013 ci <doperations@au.westfield.com> 0.0.151-1
- move api listing page (acohen@au.westfield.com)

* Wed Jun 26 2013 ci <doperations@au.westfield.com>
- move api listing page (acohen@au.westfield.com)

* Wed Jun 26 2013 ci <doperations@au.westfield.com> 0.0.149-1
- 

* Wed Jun 26 2013 ci <doperations@au.westfield.com> 0.0.148-1
- add index.html to list all services (acohen@au.westfield.com)

* Wed Jun 26 2013 ci <doperations@au.westfield.com> 0.0.147-1
- Merge pull request #60 from mwratt/feature/maps (matt.wratt@trineo.co.nz)
- repositions map zoom and level select to top right (matt.wratt@trineo.co.nz)

* Wed Jun 26 2013 ci <doperations@au.westfield.com> 0.0.146-1
- The deal partial needs to refer to a result, so that centre index can call
  it. (craigm.smith@au.westfield.com)

* Wed Jun 26 2013 ci <doperations@au.westfield.com> 0.0.145-1
- Merge pull request #55 from ldewey/master (cpearce@au.westfield.com)
- Added class_for_body (ldewey@au.westfield.com)
- Removed main and br's that were not needed (ldewey@au.westfield.com)
- Added layout for deals, movies and products (ldewey@au.westfield.com)
- "sub layout", for detail_view (ldewey@au.westfield.com)

* Wed Jun 26 2013 ci <doperations@au.westfield.com> 0.0.144-1
- WSF-4837 Store page (michael@michaelbamford.com)

* Wed Jun 26 2013 ci <doperations@au.westfield.com> 0.0.143-1
- Merge pull request #57 from mwratt/feature/maps (ldewey@au.westfield.com)
- removes erroneous + from commit diff (matt.wratt@trineo.co.nz)

* Wed Jun 26 2013 ci <doperations@au.westfield.com> 0.0.142-1
- Merge pull request #49 from mwratt/feature/maps (ldewey@au.westfield.com)
- WSF-4837 Store store_front link; stores index to store show
  (michael@michaelbamford.com)
- adds placeholder image to assets (matt.wratt@trineo.co.nz)
- adds unveil script for lazy loading images (matt.wratt@trineo.co.nz)
- replaces px with rem's (matt.wratt@trineo.co.nz)
- fixes style after rebase now takes up whole page (matt.wratt@trineo.co.nz)
- improves browser not supported message (matt.wratt@trineo.co.nz)
- adds default placeholder image (matt.wratt@trineo.co.nz)
- improves style on store list (matt.wratt@trineo.co.nz)
- adds responsive image tag helper (matt.wratt@trineo.co.nz)
- adds store model and groups stores alphabetically (matt.wratt@trineo.co.nz)
- adds custom popups and highlighting (matt.wratt@trineo.co.nz)
- removed redundant config file (matt.wratt@trineo.co.nz)
- pulls micello community from centre-service (matt.wratt@trineo.co.nz)
- adds basic map with simple config (matt.wratt@trineo.co.nz)

* Wed Jun 26 2013 ci <doperations@au.westfield.com> 0.0.141-1
- adding latest for detail view work (CPearce@au.westfield.com)
- adding JS so main content area is always underneath fixed header
  (CPearce@au.westfield.com)
- removing main container back into application layout
  (CPearce@au.westfield.com)

* Wed Jun 26 2013 ci <doperations@au.westfield.com> 0.0.140-1
- Merge pull request #54 from ldewey/master (mike.mell@nthwave.net)
- Upgraded to rails 4 ! (ldewey@au.westfield.com)

* Wed Jun 26 2013 ci <doperations@au.westfield.com> 0.0.139-1
- Merge pull request #53 from ldewey/master (ldewey@au.westfield.com)
- Added temp <br /> to fix layout for now. (ldewey@au.westfield.com)
- Event tile clean up (ldewey@au.westfield.com)
- Added event images (ldewey@au.westfield.com)

* Wed Jun 26 2013 ci <doperations@au.westfield.com> 0.0.138-1
- Added event name back in (ldewey@au.westfield.com)

* Wed Jun 26 2013 ci <doperations@au.westfield.com> 0.0.137-1
- Merge branch 'master' of github.dbg.westfield.com:digital/customer_console
  (pmcinerney@au.westfield.com)
- fix bad config path in rpm spec (pmcinerney@au.westfield.com)

* Wed Jun 26 2013 ci <doperations@au.westfield.com> 0.0.136-1
- update tito process to build from tag (pmcinerney@au.westfield.com)

* Tue Jun 25 2013 ci <doperations@au.westfield.com> 0.0.135-1
- A bit of temporary styling for Deals. (craigm.smith@au.westfield.com)

* Tue Jun 25 2013 ci <doperations@au.westfield.com> 0.0.134-1
- Merge pull request #47 from cpearce/master (ldewey@au.westfield.com)
- fixing up meta element - event date and location (CPearce@au.westfield.com)
- fixing up meta element - event date and location (CPearce@au.westfield.com)
- tidying indentation (CPearce@au.westfield.com)
- removing display block rule (CPearce@au.westfield.com)
- updating icons (CPearce@au.westfield.com)
- updating favs icon to be grey by default and adding styles for when favs are
  added (CPearce@au.westfield.com)
- cleaning up indentation (CPearce@au.westfield.com)
- adding conditional markup for detail view container based on lightbox if
  statement (CPearce@au.westfield.com)
- changing bg colour to body element not html as it makes things easier
  (CPearce@au.westfield.com)
- deleting hero images that I had to rename to be made dynamic
  (CPearce@au.westfield.com)
- adding another yeild for custom styles placed in the HTML Head
  (CPearce@au.westfield.com)
- adding inline styles for hero banner (CPearce@au.westfield.com)
- changing hero filenames to make them dynamic (CPearce@au.westfield.com)
- remove extender from box abstraction (CPearce@au.westfield.com)
- mods to markup to make styles more abstracted (CPearce@au.westfield.com)
- working on detail view module styles (CPearce@au.westfield.com)
- adding a new color var and some comments (CPearce@au.westfield.com)
- fixing longest shopping centre from wrapping at smallest palm size
  (CPearce@au.westfield.com)
- adding extenders to island abstraction (CPearce@au.westfield.com)
- adding comments to divider abstraction (CPearce@au.westfield.com)
- adding an extender to box abstraction (CPearce@au.westfield.com)
- adding partial for detail view controls (CPearce@au.westfield.com)
- removing comments for dynamic stuff and adding dynamic shopping hours to 2nd
  link (CPearce@au.westfield.com)

* Mon Jun 24 2013 ci <doperations@au.westfield.com> 0.0.133-1
- Remove code that's not implemented yet. (craigm.smith@au.westfield.com)
- Don't need this styling. (craigm.smith@au.westfield.com)
- Added the store name to the image alt text. (craigm.smith@au.westfield.com)
- Show the retailer logo per Deal. (craigm.smith@au.westfield.com)
- Beginnings of have Deals on CC (craigm.smith@au.westfield.com)

* Mon Jun 24 2013 ci <doperations@au.westfield.com> 0.0.132-1
- Fixed a typo (ldewey@au.westfield.com)
- Renamed detail_view to detail-view (ldewey@au.westfield.com)

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
