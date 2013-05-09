%define rail_home %{_var}/www
%define appdir %{_var}/www/customerconsole

Version: %{version}
Release: %{candidate}


Name:           customerconsole
Vendor:		      Westfield Labs
Summary:	      Customer Console
URL:            %{BUILD_URL}
Source0:        git@github.dbg.westfield.com:digital/customerconsole.git
Group:          Applications/Westfield
License:        Proprietary
BuildRoot:      %{_tmppath}/%{name}-%{version}-%{release}-root-%(%{__id_u} -n)
AutoReqProv:	no

# Install requirements: these can be either packages (as below) or the path to a file (i think)
# Requires: libxml2

# Users and groups
Requires(pre): shadow-utils

%description
Customer Console

#
# Build Section
#


#The "build". Given theres no compiling required, i'm using this section to remove all files we dont need deployed on disk
%build

# Honour the cap deploy exclude list by kulling the items from the build tree
rm -rf features spec

#Install phase. This builds a file system in the build root as it is meant to appear on the destination host and populates it with the needed files.
%install
rm -rf ${RPM_BUILD_ROOT}

#Install file_store application specific filesystem
mkdir -p ${RPM_BUILD_ROOT}%{appdir}/current

cp -a app config config.ru lib public script vendor Rakefile Gemfile \
      Gemfile.lock .bundle ${RPM_BUILD_ROOT}%{appdir}/current/

mkdir -p ${RPM_BUILD_ROOT}%{appdir}/current/tmp/cache
mkdir -p ${RPM_BUILD_ROOT}%{appdir}/current/tmp/sessions
mkdir -p ${RPM_BUILD_ROOT}%{appdir}/current/tmp/sockets


# Bundle gem dependencies with APP
cd ${RPM_BUILD_ROOT}%{appdir}/current
bundle install --path vendor/bundler_gems --without development test


#This is just a post build clean up... nice and simple
%clean
rm -rf ${RPM_BUILD_ROOT}

#
# Deployment Section
#


# Post deployment tasks. Files should now be on disk,
# so time to create symlinks, touch the restart.txt etc etc.

%post

# Logs
ln -sfT %{appdir}/shared/log %{appdir}/current/log
ln -sfT %{appdir}/shared/pids %{appdir}/current/tmp/pids

#Pre uninstall/upgrade
%preun
# $1 kinda refers to the number of application packages present (0 = none, 1 = the current version, 2 = the current verion AND the new version)
# So if this uninstall will leave 0 versions installed. Clean up the post install extras so that the app home can be cleanly removed
if [ $1 = 0 ] ; then
  rm -rf %{appdir}/current/tmp/restart.txt
fi

#Post uninstall/upgrade
%postun
#If no package is left (all uninstalled) clean up totally
if [ $1 = 0 ] ; then
  rm -rf %{appdir}
fi

%files
%defattr(644,root,root,755)
%{appdir}/current
%attr(755,nobody,nobody)%{appdir}/current/script/rails
%attr(755,nobody,nobody)%{appdir}/current/tmp



#
# Specfile changelog
#
%changelog
* Wed May 09 2013 Leon Dewey <ldewey@au.westfield.com> 0.0.1
- Created initial.
