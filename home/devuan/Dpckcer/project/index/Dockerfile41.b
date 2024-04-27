FROM bitnami/python:3.12 as build
#HUOM.211224:voisi kai sanoa että tagina 3.12 mikä nyt latesdt

#sudo gpg --keyserver pgpkeys.mit.edu --recv-key  <PUBKEY>
#sudo gpg -a --export <PUBKEY> | sudo apt-key add -
#sudo apt-get update
#WORKDIR /
#COPY ./sources.list /etc/apt/sources.list
#COPY ./trusted.gpg /etc/apt/trusted.gpg.d/
#
#RUN apt-get update
#RUN apt-get -y install python3-pip

WORKDIR /app
COPY ./requirements.txt .

#https://github.com/pypa/pip/issues/12330 soveltaen
#RUN rm -rf /opt/bitnami/python/lib/python3.12/site-packages/pip/_internal/operations/build
#RUN rm -rf /opt/bitnami/python/lib/python3.12/site-packages/pip-23.3.2-py3.12.egg/pip/_internal/operations/build
#RUN python3 -m pip install --upgrade build
#RUN python3 -m build

#tmä kusee
#RUN adduser --system index
#USER index
WORKDIR /opt/venv

#tämä saattaa toimia muuten mutta ModuleNotFoundError: No module named 'flask'
#RUN python3 -m venv /opt/venv
#RUN . /opt/venv/bin/activate
#RUN pip install --upgrade pip
#RUN pip uninstall flask && python -m pip install flask

RUN pip install --upgrade pip
RUN pip install -r /app/requirements.txt
#RUN ls -la /opt/venv/bin
#RUN pip show Flask

#TODO:jokin juttu starttaamisen kanssa, pitäisi huomioida INDXIP vs INDXIP0
