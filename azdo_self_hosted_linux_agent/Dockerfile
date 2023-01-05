ARG acr
ARG tag

FROM ${acr}/azdodockerbase:${tag}

# Can be 'linux-x64', 'linux-arm64', 'linux-arm', 'rhel.6-x64'.
ENV TARGETARCH=linux-x64

WORKDIR /azp

COPY ./artifacts/start.sh .
RUN chmod +x start.sh

ENTRYPOINT ["./start.sh"]
