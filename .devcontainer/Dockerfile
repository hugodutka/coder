FROM mcr.microsoft.com/vscode/devcontainers/go:1.23-bookworm

USER root

RUN apt update && apt install -y \
    tmux \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg

USER vscode

RUN go install gotest.tools/gotestsum@latest
RUN \
    curl https://baltocdn.com/helm/signing.asc | gpg --dearmor | sudo tee /usr/share/keyrings/helm.gpg > /dev/null \
    sudo apt-get install apt-transport-https --yes \
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/helm.gpg] https://baltocdn.com/helm/stable/debian/ all main" | sudo tee /etc/apt/sources.list.d/helm-stable-debian.list \
    sudo apt-get update \
    sudo apt-get install helm
