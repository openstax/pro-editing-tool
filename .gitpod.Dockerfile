FROM gitpod/workspace-full-vnc:commit-c90b4a5ce44b8956cfd278f67422c739e07ff80e

# From https://community.gitpod.io/t/is-there-an-easy-way-to-debug-a-vscode-extension-inside-gitpod/596/63

ARG DEBIAN_FRONTEND=noninteractive

# Install vscode and cypress dependencies
# https://github.com/microsoft/vscode-test/blob/b4fa3ac57377c28d65b73552fc8a091fa361a556/.travis.yml
# https://docs.cypress.io/guides/continuous-integration/introduction.html#Dependencies
RUN wget -q https://packages.microsoft.com/keys/microsoft.asc -O- | sudo apt-key add -; \
    sudo add-apt-repository "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main" \
    && sudo apt-get update \
    && sudo apt-get install --no-install-recommends -y libx11-xcb1 libasound2 x11-apps libice6 libsm6 libxaw7 libxft2 libxmu6 libxpm4 libxt6 x11-apps xbitmaps \
    && sudo apt-get install --no-install-recommends -y \
        libgtk2.0-0 \
        libgtk-3-0 \
        libnotify-dev \
        libgconf-2-4 \
        libgbm-dev \
        libnss3 \
        libxss1 \
        libasound2 \
        libxtst6 \
        xauth \
        xvfb \
    && sudo apt-get install -y code

RUN sudo apt-get update && \
  sudo apt-get install --no-install-recommends -y \
  libgtk2.0-0 \
  libgtk-3-0 \
  libnotify-dev \
  libgconf-2-4 \
  libgbm-dev \
  libnss3 \
  libxss1 \
  libasound2 \
  libxtst6 \
  xauth \
  xvfb \
  # install Chinese fonts
  # this list was copied from https://github.com/jim3ma/docker-leanote
  fonts-arphic-bkai00mp \
  fonts-arphic-bsmi00lp \
  fonts-arphic-gbsn00lp \
  fonts-arphic-gkai00mp \
  fonts-arphic-ukai \
  fonts-arphic-uming \
  ttf-wqy-zenhei \
  ttf-wqy-microhei \
  xfonts-wqy \
  # clean up
  && rm -rf /var/lib/apt/lists/*

RUN npm install -g npm@latest
RUN npm --version

RUN npm install -g yarn@latest --force
RUN yarn --version

# a few environment variables to make NPM installs easier
# good colors for most applications
ENV TERM xterm
# avoid million NPM install messages
ENV npm_config_loglevel warn
# allow installing when the main user is root
ENV npm_config_unsafe_perm true

# Node libraries
RUN node -p process.versions

# versions of local tools
RUN echo  " node version:    $(node -v) \n" \
  "npm version:     $(npm -v) \n" \
  "yarn version:    $(yarn -v) \n" \
  "debian version:  $(cat /etc/debian_version) \n" \
  "user:            $(whoami) \n"