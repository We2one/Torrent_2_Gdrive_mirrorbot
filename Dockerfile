FROM breakdowns/mega-sdk-python:latest

WORKDIR /usr/src/app
RUN chmod 777 /usr/src/app

COPY extract /usr/local/bin
COPY pextract /usr/local/bin
RUN chmod +x /usr/local/bin/extract && chmod +x /usr/local/bin/pextract

COPY requirements.txt .
RUN pip3 install --no-cache-dir -r requirements.txt

COPY . .
# RUN cp -r ./aria2-config/* /root/.aria2/
RUN mv /usr/local/bin/yt-dlp /usr/local/bin/youtube-dl
COPY .netrc /root/.netrc
RUN chmod 600 /usr/src/app/.netrc
RUN chmod +x aria.sh

CMD ["bash","comienzo.sh"]
