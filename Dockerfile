FROM alpine

WORKDIR /dist

COPY obj/go-say-hello .

# Export necessary port
EXPOSE 8080

# Command to run when starting the container
CMD ["/dist/go-say-hello"]
