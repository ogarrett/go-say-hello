FROM alpine

WORKDIR /dist

COPY bin/hello .

# Export necessary port
EXPOSE 8080

# Command to run when starting the container
CMD ["/dist/hello"]