FROM node:20

WORKDIR /app

COPY server.js .

EXPOSE 8080

CMD ["node", "server.js"]
