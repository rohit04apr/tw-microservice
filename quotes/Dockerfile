FROM java:8

RUN mkdir /app
WORKDIR /app

COPY quotes.jar quotes.jar

EXPOSE 8002

CMD [ "java", "-jar", "quotes.jar" ]