FROM golang:1.11-alpine as build-env
RUN apk add git gcc
RUN mkdir /app
WORKDIR /app
COPY . .
RUN go mod download
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -a -installsuffix cgo -o app

//Build production image
FROM alpine:3.8
COPY --from=build-env /app/app .
USER 1001
EXPOSE 8080
ENTRYPOINT ["./app"]
