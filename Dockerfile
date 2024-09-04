#
# 멀티 스테이지 빌드를 이용하여 빌드를 수행하고, 빌드 결과물을 Nginx 컨테이너에 복사하여 실행하는 Dockerfile
#

# Build stage
FROM node:16 AS build

WORKDIR /app

COPY . .

RUN npm install

RUN npm run build

# Production stage
FROM nginx

WORKDIR /app

COPY --from=build /app/build /app/build

RUN rm /etc/nginx/conf.d/default.conf

COPY ./nginx.conf /etc/nginx/conf.d

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]