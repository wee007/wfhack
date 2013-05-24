Summary:     Westfield Customer Console
Name:        wf-customerconsole
Version:     0.0.45
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
 bundle install --path=vendor/bundler_gems --without development test
 bundle exec rake assets:precompile

%install
 mkdir -p ${RPM_BUILD_ROOT}%{appdir}/current
 mkdir -p ${RPM_BUILD_ROOT}%{appdir}/current/tmp
 mkdir -p ${RPM_BUILD_ROOT}%{appdir}/current/tmp/cache
 mkdir -p ${RPM_BUILD_ROOT}%{appdir}/current/tmp/sessions
 mkdir -p ${RPM_BUILD_ROOT}%{appdir}/current/tmp/sockets

 cd ${RPM_BUILD_DIR}/*
 cp -va app config config.ru lib public vendor Rakefile Gemfile \
       Gemfile.lock ${RPM_BUILD_ROOT}%{appdir}/current/

%clean
rm -rf ${RPM_BUILD_ROOT}

%post
ln -sfT %{appdir}/shared/log %{appdir}/current/log
ln -sfT %{appdir}/shared/pids %{appdir}/current/tmp/pids

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
