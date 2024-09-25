FROM ubuntu:latest

RUN apt-get update && apt-get install -y \
    curl \
    git \
    unzip \
    zip \
    nginx

RUN git clone --single-branch --branch stable https://github.com/flutter/flutter.git /flutter
ENV PATH "$PATH:/flutter/bin:/flutter/bin/cache/dart-sdk/bin"

RUN flutter channel stable && \
    flutter upgrade && \
    flutter config --enable-web

COPY ./app /app

WORKDIR /app

RUN flutter pub get
RUN flutter build web --release

RUN cp -r build/web/* /var/www/html

CMD ["nginx", "-g", "daemon off;"]
 
