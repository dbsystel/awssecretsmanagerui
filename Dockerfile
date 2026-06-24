FROM golang:1.26@sha256:32c0e6e5c4f6707717051091b4d0b077464a679eaab563e11474efc5328e2aa5 as gobuilder
WORKDIR /app
COPY ./server .
RUN CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -o ./aws-secrets-manager-ui .;

FROM alpine:latest@sha256:5b10f432ef3da1b8d4c7eb6c487f2f5a8f096bc91145e68878dd4a5019afde11
RUN apk --no-cache add ca-certificates
WORKDIR /root/
COPY --from=gobuilder /app/aws-secrets-manager-ui .
EXPOSE 3000
ENV HOST 0.0.0.0
CMD ["./aws-secrets-manager-ui"]
