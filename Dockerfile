FROM th089/swift:5.3.3
ARG ARCH
ARG TOKEN

# Dependency: libsqlite3
RUN apt-get update && apt-get install -y --no-install-recommends libsqlite3-dev curl

# Resolve the SPM dependencies
COPY Package.* ./

# Download cache
RUN curl -O https://cache.meetis.eu/cache/${TOKEN}/${ARCH}.tar
# Extract cache
RUN tar -xvf ${ARCH}.tar
# Remove archive
RUN rm ${ARCH}.tar

# Resolve the SPM dependencies
RUN swift package resolve

# The usual copying over
COPY Tests ./Tests
COPY Sources ./Sources

# Build the application
RUN swift build --configuration debug

# Compress .build folder
RUN tar -cvf ${ARCH}.tar .build/
# Upload .build archive to cache server
RUN curl -F "archive=@./${ARCH}.tar" https://cache.meetis.eu/upload/${TOKEN}/${ARCH}

# Clean-up
RUN rm ${ARCH}.tar

# Exposes ports for Docker container
EXPOSE 8080

# Start the application (Preventing rebuilds)
CMD swift run --skip-build --skip-update --configuration debug
