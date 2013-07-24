Summary:     Westfield Customer Console
Name:        wf-customerconsole
Version:     0.0.265
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
       Gemfile.lock .bundle ${RPM_BUILD_ROOT}%{appdir}/current/

%clean
rm -rf ${RPM_BUILD_ROOT}

%post
ln -sfT %{appdir}/shared/log %{appdir}/current/log
ln -sfT %{appdir}/shared/pids %{appdir}/current/tmp/pids
service httpd reload
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
%attr(755,nobody,nobody)%{appdir}/shared
%attr(755,nobody,nobody)%{appdir}/current/tmp
%dir %{appdir}/shared/log
%config(noreplace) %{_sysconfdir}/httpd/conf.d/customer_console.conf


%changelog
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
