# --- Stage 1: build ---
FROM ghcr.io/cirruslabs/flutter:stable AS build

WORKDIR /app
COPY pubspec.* ./
RUN flutter pub get

COPY . .
RUN flutter build linux --release

# --- Stage 2: runtime ---
FROM debian:bookworm-slim
RUN apt-get update && apt-get install -y \
    libsecret-1-0 \
    libjsoncpp25 \
    && rm -rf /var/lib/apt/lists/*

COPY --from=build /app/build/linux/x64/release/bundle /app/bundle

EXPOSE 8080
CMD ["/app/bundle/dart_backend"]