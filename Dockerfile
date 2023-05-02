FROM node:12.2.0-alpine

WORKDIR /app

COPY package*.json ./

RUN npm install --production

RUN npm install --save-dev mocha

COPY . .

RUN npm test

EXPOSE 8000

CMD ["node","app.js"]