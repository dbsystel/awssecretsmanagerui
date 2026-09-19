FROM golang:1.27@sha256:3680233e3204827fbdc66088528ae6d4b3d034f51d03a99d454f6de034888244 as gobuilder
WORKDIR /app
COPY ./server .
RUN CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -o ./aws-secrets-manager-ui .;

FROM alpine:latest@sha256:294b683cb724975bec92580e1e685676bd4b50bda910ddb8c51d4cabeaec77e6
RUN apk --no-cache add ca-certificates
WORKDIR /root/
COPY --from=gobuilder /app/aws-secrets-manager-ui .
EXPOSE 3000
ENV HOST 0.0.0.0
CMD ["./aws-secrets-manager-ui"]
