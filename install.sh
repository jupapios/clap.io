useradd -d /home/clap -m clap
#passwd clap
su - clap
cd ~ 
git clone https://github.com/nodejitsu/haibu.git
cd haibu/
npm install optimist flatiron semver pkginfo npm forever request cloudfiles union eyes haibu-carapace
