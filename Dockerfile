FROM swift:latest

# Dependency: libsqlite3
RUN apt-get update && apt-get install -y --no-install-recommends libsqlite3-dev

# Copy over the generated Package.*, and resolve if changed.
COPY Package.* ./
# The usual copying over
COPY Sources ./Sources
COPY Tests ./Tests
RUN swift package resolve


RUN swift build

# Exposes ports for Docker container
EXPOSE 8080

CMD swift run
