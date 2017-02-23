#!/usr/bin/bash

pip install virtualenv --upgrade
pip install setuptools --upgrade
echo "virtualenv version ... $(virtualenv --version)"
echo "python version ... $(python -V)"
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
sudo dpkg -i google-chrome*.deb
pip install -r requirements.txt
pip install --pre vmprof

wget https://chromedriver.storage.googleapis.com/2.27/chromedriver_linux64.zip
unzip chromedriver_linux64.zip
sudo mv chromedriver /usr/bin
git clone --depth 1 git://github.com/vmprof/vmprof-server.git
cd vmprof-server
pip install -r requirements/testing.txt
python manage.py migrate
python vmlog/test/data/loggen.py
python manage.py loaddata vmlog/test/fixtures.yaml

export CHROME_BIN=/usr/bin/google-chrome
export DISPLAY=:99.0
sh -e /etc/init.d/xvfb start
sleep 3 # give xvfb some time to start
# download the chrome driver
python manage.py runserver -v 3 &
sleep 3 # wait for django