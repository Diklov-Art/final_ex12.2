FROM golang:1.21-alpine AS builder

WORKDIR /app

COPY go.mod go.sum ./
RUN go mod download

COPY *.go ./
COPY tracker.db ./

RUN CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -o parcel-service .

FROM alpine:latest

RUN apk --no-cache add ca-certificates

WORKDIR /app

COPY --from=builder /app/parcel-service .
COPY --from=builder /app/tracker.db .

CMD ["./parcel-service"]