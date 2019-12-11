FROM node:alpine AS node

FROM jenkins/jenkins

LABEL maintainer="george komen <gkkomensi@gmail.com>"

# Switch to root user
USER root

# copy node and npm files
COPY --from=node /usr/local/bin/node /usr/local/bin/
COPY --from=node /usr/local/include/node/ /usr/local/include/node/
COPY --from=node /usr/local/lib/node_modules/ /usr/local/lib/node_modules/
COPY --from=node /usr/local/share/doc/node/ /usr/local/share/doc/node/
COPY --from=node /usr/local/share/man/man1/node.1 /usr/local/share/man/man1/
COPY --from=node /usr/local/share/systemtap/tapset/node.stp /usr/local/share/systemtap/tapset/
COPY --from=node /opt/yarn-* /opt/yarn/

RUN set -ex \
    apk add --no-cache libstdc++ \
    && cd /usr/local/bin \
    && ln -s ../lib/node_modules/npm/bin/npm-cli.js npm \
    && ln -s ../lib/node_modules/npm/bin/npx-cli.js npx \
    && ln -s /opt/yarn/bin/yarn /usr/local/bin/yarn \
    && ln -s /opt/yarn/bin/yarnpkg /usr/local/bin/yarnpkg \
    && cd /

# Distributed Builds plugins
RUN /usr/local/bin/install-plugins.sh ssh-slaves
# install Notifications and Publishing plugins
RUN /usr/local/bin/install-plugins.sh email-ext
RUN /usr/local/bin/install-plugins.sh mailer
RUN /usr/local/bin/install-plugins.sh slack
# Artifacts
RUN /usr/local/bin/install-plugins.sh htmlpublisher
# UI
RUN /usr/local/bin/install-plugins.sh greenballs
RUN /usr/local/bin/install-plugins.sh simple-theme-plugin
# Scaling
RUN /usr/local/bin/install-plugins.sh kubernetes
# install Maven
RUN apt-get update && apt-get install -y maven

USER jenkins