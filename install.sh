useradd -d /home/clap -m clap
#passwd clap
su - clap
cd ~ 
git clone https://github.com/nodejitsu/haibu.git
cd haibu/
npm install optimist
npm install flatiron
npm install semver 
npm install pkginfo
npm install npm
npm install forever
npm install request
npm install cloudfiles
npm install union
npm install eyes
npm install haibu-carapace
