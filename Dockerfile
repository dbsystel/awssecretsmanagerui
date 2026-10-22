FROM golang:1.27@sha256:f20d83a83e18dbd2a4714b8ffd4b30b287b6243962dd75608e86abcc63ba4efc as gobuilder
WORKDIR /app
COPY ./server .
RUN CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -o ./aws-secrets-manager-ui .;

FROM alpine:latest@sha256:71e9b7bae160ba167fa17414401b94cbcdaf3c32feeab9298bd794a2a0614c35
RUN apk --no-cache add ca-certificates
WORKDIR /root/
COPY --from=gobuilder /app/aws-secrets-manager-ui .
EXPOSE 3000
ENV HOST 0.0.0.0
CMD ["./aws-secrets-manager-ui"]
