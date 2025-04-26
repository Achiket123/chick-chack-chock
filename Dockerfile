# Stage 1: Build the Flutter app
FROM ghcr.io/cirruslabs/flutter:stable AS flutter-builder
WORKDIR /app
COPY tic_tac_toe/ ./tic_tac_toe/
RUN flutter pub get && flutter build web --release

# Stage 2: Build the Go server
FROM golang:1.24.2-alpine3.21 AS go-builder
WORKDIR /app
COPY go-server/ ./go-server/
RUN go mod tidy && go build -o server ./go-server/

# Stage 3: Create the final image
FROM nginx:1.27.5-alpin
WORKDIR /app

# Copy Flutter build output
COPY --from=flutter-builder /app/flutter-app/build/web /usr/share/nginx/html

# Copy Go server binary
COPY --from=go-builder /app/server /app/server

ENV SERVER_HOST=0.0.0.0
# Expose ports
EXPOSE 8081 80

# Start both the Go server and Nginx
CMD ["sh", "-c", "/app/server & nginx -g 'daemon off;'"]
# Ensure the Go server listens on all network interfaces