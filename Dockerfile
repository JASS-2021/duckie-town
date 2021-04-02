FROM th089/swift:5.3.3

# Dependency: libsqlite3
RUN apt-get update && apt-get install -y --no-install-recommends libsqlite3-dev

# Resolve the SPM dependencies
COPY Package.* ./
RUN swift package resolve

# The usual copying over
COPY Tests ./Tests
COPY Sources ./Sources

# Build the application
RUN swift build --configuration debug

# Exposes ports for Docker container
EXPOSE 8080

# Start the application (Preventing rebuilds)
CMD swift run --skip-build --skip-update --configuration debug
