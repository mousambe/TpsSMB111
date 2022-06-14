FROM node:14-alpine

WORKDIR /app

COPY . .

RUN npm install

RUN npm run build
# Copy app files
# Expose port
EXPOSE 3000

#ENTRYPOINT [ "/app" ]
# Start the app
CMD [ "npm", "start" ]