FROM rockylinux:9.0

# Execution user name after container startup
ARG USER_NAME

# Repository Update
RUN dnf update -y

# Install sudo
RUN dnf install sudo -y

# Install dnf-plugins-core
RUN dnf install dnf-plugins-core -y

# Add HashiCorp Repository
RUN dnf config-manager --add-repo https://rpm.releases.hashicorp.com/RHEL/hashicorp.repo

# Install terraform
RUN dnf install terraform -y

# Add GoogleCloud Repository
RUN { \
    echo '[google-cloud-cli]'; \
    echo 'name=Google Cloud CLI'; \
    echo 'baseurl=https://packages.cloud.google.com/yum/repos/cloud-sdk-el9-x86_64'; \
    echo 'enabled=1'; \
    echo 'gpgcheck=1'; \
    echo 'repo_gpgcheck=0'; \
    echo 'gpgkey=https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg'; \
} > /etc/yum.repos.d/google-cloud-sdk.repo

# Install google-cloud-cli
RUN dnf install google-cloud-cli -y

# Add User
RUN adduser ${USER_NAME} --badnames

# Setup to use sudo without password
RUN echo "${USER_NAME} ALL=NOPASSWD: ALL" | tee /etc/sudoers

ENTRYPOINT tail -f /dev/null