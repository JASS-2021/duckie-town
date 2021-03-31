FROM ubuntu:20.04

RUN export DEBIAN_FRONTEND=noninteractive DEBCONF_NONINTERACTIVE_SEEN=true && apt-get -q update && \
    apt-get -q install -y \
    binutils \
    git \
    gnupg2 \
    libc6-dev \
    libcurl4 \
    libedit2 \
    libgcc-9-dev \
    libpython2.7 \
    libsqlite3-0 \
    libstdc++-9-dev \
    libxml2 \
    libz3-dev \
    pkg-config \
    tzdata \
    zlib1g-dev \
    && rm -r /var/lib/apt/lists/*


ARG SWIFT_BIN_URL=https://github.com/futurejones/swift-arm64/releases/download/v5.3.3-RELEASE/swiftlang-5.3.3-ubuntu-20.04-release-aarch64-5-2021-02-01.tar.gz


RUN set -e; \
    # - Grab curl here so we cache better up above
    export DEBIAN_FRONTEND=noninteractive \
    && apt-get -q update && apt-get -q install -y curl && rm -rf /var/lib/apt/lists/* \
    # - Download the Swift toolchain
    && curl -fsSL "$SWIFT_BIN_URL" -o swift.tar.gz \
    # - Unpack the toolchain, set libs permissions, and clean up.
    && tar -xzf swift.tar.gz --directory / \
    && chmod -R o+r /usr/lib/swift \
    && rm -rf swift.tar.gz \
    && apt-get purge --auto-remove -y curl
# Dependency: libsqlite3
RUN apt-get update && apt-get install -y --no-install-recommends libsqlite3-dev

# Copy over the generated Package.*, and resolve if changed.
COPY Package.* ./
RUN swift package resolve

# The usual copying over
COPY Sources ./Sources
COPY Tests ./Tests
RUN swift package resolve


RUN swift build

# Exposes ports for Docker container
EXPOSE 8080

CMD swift run
