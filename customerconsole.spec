Summary:     Westfield Customer Console
Name:        wf-customerconsole
Version:     0.0.0
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

%install
rm -rf ${RPM_BUILD_ROOT}
mkdir -p ${RPM_BUILD_ROOT}%{appdir}/current
mkdir -p ${RPM_BUILD_ROOT}%{appdir}/current/tmp
cp -a * ${RPM_BUILD_ROOT}%{appdir}/current/
mkdir -p ${RPM_BUILD_ROOT}%{appdir}/current/tmp/cache
mkdir -p ${RPM_BUILD_ROOT}%{appdir}/current/tmp/sessions
mkdir -p ${RPM_BUILD_ROOT}%{appdir}/current/tmp/sockets
cd ${RPM_BUILD_ROOT}%{appdir}/current
bundle install --path vendor/bundler_gems --without development test qa

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
* Wed May 09 2013 Leon Dewey <ldewey@au.westfield.com> 0.0.1
- Created initial.
