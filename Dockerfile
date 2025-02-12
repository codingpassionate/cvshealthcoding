# use lightweight image
FROM node:18-bookworm-slim

# Set working directory
WORKDIR /app

COPY package.json package-lock.json ./
RUN npm install

COPY . .

EXPOSE 80

ENV CAT_API_KEY=${CAT_API_KEY}
ENV PORT=80
ENV S3_BUCKET_NAME="gif-app-data"
ENV AWS_ACCESS_KEY_ID=${AWS_ACCESS_KEY_ID}
ENV AWS_SECRET_ACCESS_KEY=${AWS_SECRET_ACCESS_KEY}
ENV AWS_REGION=${AWS_REGION}

CMD ["npm", "start"]
