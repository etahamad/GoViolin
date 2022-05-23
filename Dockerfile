FROM golang:1.18.2-alpine3.15 as build-stage

WORKDIR /goviolin

COPY . .
RUN go mod init 
ENV GO111MODULE=on
RUN export CGO_ENABLED=0 
RUN go build -o goviolin .


FROM alpine
COPY --from=build-stage /goviolin /goviolin
WORKDIR /goviolin
EXPOSE 8080

CMD ["./goviolin"]
