# Use an official Node.js runtime as a parent image
FROM node:18

# Set the working directory
WORKDIR ./

# Copy the package.json and package-lock.json files
COPY package*.json ./

# Install dependencies, including pg
RUN npm install pg --save
RUN npm install

# Copy the rest of the application code
COPY . .

# Copy the .env file
COPY .env .env

# Expose the port that the Strapi app runs on
EXPOSE 1337

# Define environment variables
ENV NODE_ENV production

# Build the Strapi admin panel
RUN npm run build

# Start the Strapi application
CMD ["npm", "start"]
