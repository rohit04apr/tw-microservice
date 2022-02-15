FROM java:8

RUN mkdir /app
WORKDIR /app

COPY newsfeed.jar newsfeed.jar

EXPOSE 8003

CMD [ "java", "-jar", "newsfeed.jar" ]