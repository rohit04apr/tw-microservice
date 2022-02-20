FROM java:8

RUN mkdir /app
WORKDIR /app

COPY front-end.jar front-end.jar

EXPOSE 8001

CMD [ "java", "-jar", "front-end.jar" ]