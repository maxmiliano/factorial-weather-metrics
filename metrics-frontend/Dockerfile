FROM node

WORKDIR /frontend
COPY package.json .
COPY package-lock.json .

# Install dependencies
RUN npm install

# Copy the rest of the application files
COPY . .

ENV NODE_ENV=development
EXPOSE 4000

# start the app
CMD ["npm", "start"]
