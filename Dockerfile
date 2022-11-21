FROM golang:1.19-alpine AS builder

WORKDIR /build

COPY go.mod go.sum ./
RUN go mod download

COPY ./main.go .

ENV CGO_ENABLED=0 GOOS=linux GOARCH=amd64
RUN go build -ldflags="-s -w" -o producer .

FROM alpine
RUN apk update && apk add curl

COPY --from=builder ["/build/producer", "/"]

ENTRYPOINT ["/producer"]