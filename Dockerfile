FROM golang:1.27@sha256:f44f6e88636cfb311f9ebace870ded69d943f227bb3cb27d32ffd84ea18c43ea as gobuilder
WORKDIR /app
COPY ./server .
RUN CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -o ./aws-secrets-manager-ui .;

FROM alpine:latest@sha256:5b02b42e375f7426f8d65c3af331ca05d9878f9989230354504e0b9dfd431f60
RUN apk --no-cache add ca-certificates
WORKDIR /root/
COPY --from=gobuilder /app/aws-secrets-manager-ui .
EXPOSE 3000
ENV HOST 0.0.0.0
CMD ["./aws-secrets-manager-ui"]
