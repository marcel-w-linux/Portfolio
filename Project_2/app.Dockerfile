FROM golang:1.20 AS builder
WORKDIR /app
COPY go.mod ./
COPY main.go ./

RUN CGO_ENABLED=0 go build -o app

FROM scratch
WORKDIR /app
COPY --from=builder /app/app /app/
CMD  ["/app/app"]
