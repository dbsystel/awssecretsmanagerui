FROM golang:1.27@sha256:921f61120011c774a7b37fd80bd3c3d259636090d3cd002b6a344322a0328082 as gobuilder
WORKDIR /app
COPY ./server .
RUN CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -o ./aws-secrets-manager-ui .;

FROM alpine:latest@sha256:be2656061b536c1883c4034790e21d0a09c5aaaf51968b89368a3c0371ea2c9a
RUN apk --no-cache add ca-certificates
WORKDIR /root/
COPY --from=gobuilder /app/aws-secrets-manager-ui .
EXPOSE 3000
ENV HOST 0.0.0.0
CMD ["./aws-secrets-manager-ui"]
