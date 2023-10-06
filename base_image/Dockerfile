FROM python:3.9
WORKDIR /app
COPY ./requirements.txt ./requirements.txt
RUN pip install -U -r ./requirements.txt
COPY . .
RUN python setup.py install