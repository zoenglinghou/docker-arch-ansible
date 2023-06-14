FROM archlinux:base
LABEL maintainer="Linghao Zhang"
ENV container=docker

ENV pip_packages ""

RUN pacman -Syu --noconfirm

# Enable systemd.
RUN pacman -S --noconfirm install systemd && pacman -Scc --confirm && \
  (cd /lib/systemd/system/sysinit.target.wants/; for i in *; do [ $i == systemd-tmpfiles-setup.service ] || rm -f $i; done); \
  rm -f /lib/systemd/system/multi-user.target.wants/*;\
  rm -f /etc/systemd/system/*.wants/*;\
  rm -f /lib/systemd/system/local-fs.target.wants/*; \
  rm -f /lib/systemd/system/sockets.target.wants/*udev*; \
  rm -f /lib/systemd/system/sockets.target.wants/*initctl*; \
  rm -f /lib/systemd/system/basic.target.wants/*;

# Install pip and other requirements.
RUN pacman -S --noconfirm \
  python-pip \
  ansible

# Install Ansible via Pip.
# RUN pip3 install $pip_packages

# Install Ansible inventory file.
RUN mkdir -p /etc/ansible
RUN echo -e '[local]\nlocalhost ansible_connection=local' > /etc/ansible/hosts

VOLUME ["/sys/fs/cgroup", "/tmp", "/run"]
CMD ["/usr/sbin/init"]
