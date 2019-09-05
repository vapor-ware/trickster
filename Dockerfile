FROM vaporio/golang:1.12 as build

ARG GOOS=linux
ARG GOARCH=amd64
ARG CGO_ENABLED=0

RUN git clone https://github.com/Comcast/trickster --branch next --depth=1 /trickster
WORKDIR /trickster

RUN GOOS=${GOOS} GOARCH=${GOARCH} CGO_ENABLED=${CGO_ENABLED} make build

FROM vaporio/foundation:latest
COPY --from=build /trickster/trickster /usr/bin/trickster
COPY --from=build /trickster/cmd/trickster/conf/example.conf /etc/trickster/trickster.conf
RUN chown nobody /usr/bin/trickster

# Metrics port
EXPOSE 8082
# Application Port
EXPOSE 9090

USER nobody
ENTRYPOINT ["trickster"]
