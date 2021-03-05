FROM gitpod/workspace-full-vnc

# From https://community.gitpod.io/t/is-there-an-easy-way-to-debug-a-vscode-extension-inside-gitpod/596/63

ARG DEBIAN_FRONTEND=noninteractive

RUN wget -q https://packages.microsoft.com/keys/microsoft.asc -O- | sudo apt-key add -; \
    add-apt-repository "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main" \
    && apt-get update \
    && apt-get install -y code