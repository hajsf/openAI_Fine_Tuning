FROM pytorch/pytorch

RUN apt-get -y update
RUN apt-get install -y ffmpeg
RUN apt-get -y install curl
RUN apt-get install git
RUN apt-get install gh
# To avoid having: RuntimeError: Unsupported compiler -- at least C++11 support is needed
RUN apt-get install build-essential -y

ENV OPENAI_API_KEY "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"

COPY readme.md .
COPY requirements.txt .
#COPY training-data.json .

RUN pip install --no-cache-dir -r requirements.txt

#Endless loop to keep the container running
ENTRYPOINT ["tail", "-f", "/dev/null"]