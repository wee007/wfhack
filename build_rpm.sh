rm -rf /tmp/tito/
gem install bundler --no-ri --no-rdoc
bundle install
sudo yum-builddep *.spec --nogpgcheck -y
git checkout master
git pull origin master
tito tag --accept-auto-changelog
git push
git push --tags
tito build --rpm
RPM_FILE=$(ls -rt /tmp/tito/noarch/ | tail -1)
cp /tmp/tito/noarch/${RPM_FILE} .
scp ${RPM_FILE} deploy@aubdc-appsyt02.dbg.westfield.com:
ssh -t deploy@aubdc-appsyt02.dbg.westfield.com sudo /usr/bin/yum -y install ${RPM_FILE}
ssh -t deploy@aubdc-appsyt02.dbg.westfield.com \\rm ${RPM_FILE}
