# Fetch stage #################################################################
FROM mcerolini/eo4africa AS fetchstage

# Setup fetch deps
RUN set -ex && \
 apk update && \
 apk add --no-cache --virtual .fetch-deps git

# Fetch source code
RUN set -x && \
  mkdir -p ctbtemp && cd ctbtemp && \
  git clone https://github.com/AliaSpaceSystems/cesium-terrain-builder.git && \
  cd cesium-terrain-builder && \
  git checkout ci-test

# Cleanup
RUN  set -x && \
  apk del .fetch-deps

# Build stage #################################################################
FROM mcerolini/eo4africa AS buildstage
COPY --from=fetchstage /ctbtemp /ctbtemp

# Setup build deps
RUN set -ex && \
  apk update && \
  apk add --no-cache --virtual .build-deps \
    make cmake libxml2-dev g++

# Build & install cesium terrain builder
RUN set -x && \
  cd /ctbtemp/cesium-terrain-builder && \
  mkdir build && cd build && cmake .. && make install .

# Cleanup
RUN  set -x && \
  apk del .build-deps && \
  rm -rf /tmp/* && \
  rm -rf /ctbtemp

# Runtime stage #########################################################################
FROM mcerolini/eo4africa AS runtimestage
COPY --from=buildstage /usr/local/include/ctb /usr/local/include/ctb
COPY --from=buildstage /usr/local/lib/libctb.so /usr/local/lib/libctb.so
COPY --from=buildstage /usr/local/bin/ctb-* /usr/local/bin/

WORKDIR /data


CMD ["bash"]

# Labels ######################################################################
#LABEL maintainer="Bruno Willenborg"
#LABEL maintainer.email="b.willenborg(at)tum.de"
#LABEL maintainer.organization="Chair of Geoinformatics, Technical University of Munich (TUM)"
#LABEL source.repo="https://github.com/tum-gis/cesium-terrain-builder-docker"
LABEL docker.image="mcerolini/ctb-quantized-mesh"
LABEL docker.image.tag "alpine"
