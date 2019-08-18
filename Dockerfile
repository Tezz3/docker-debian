FROM debian:9

RUN apt-get update -y && \
    apt-get install -y supervisor openssh-server git build-essential wget python-setuptools tzdata vim&& \
    apt-get autoclean && apt-get autoremove && \
    ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && \
    echo "Asia/Shanghai" > /etc/timezone

COPY supervisord.conf /etc/supervisor/supervisord.conf

RUN mkdir /var/run/sshd
RUN mkdir /root/.ssh
RUN sed -ri 's/^#?PermitRootLogin\s+.*/PermitRootLogin yes/' /etc/ssh/sshd_config
RUN sed -ri 's/^#?PasswordAuthentication\s+.*/PasswordAuthentication no/' /etc/ssh/sshd_config
RUN sed -ri 's/^#?RSAAuthentication\s+.*/RSAAuthentication yes/' /etc/ssh/sshd_config
RUN sed -ri 's/^#?PubkeyAuthentication\s+.*/PubkeyAuthentication yes/' /etc/ssh/sshd_config
RUN sed -ri 's/UsePAM yes/#UsePAM yes/g' /etc/ssh/sshd_config
RUN sed -ri 's/^#?Port 22/Port 9992/g' /etc/ssh/sshd_config
RUN echo "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC5XLap0p7P2vBJXP5Rfrp7LfHjT56txU7tURraktTEc0b30+4+mwpzsBHhAXaBskR/XN/FGrtUvboC/f1eC9w6PGUA1p81b4K5I0uSo1YKSY3hWyqUmzrlj9sUZg1LiyV3VnuXcfyHQ5UJD+F/z9utDNABLRO971M+3Bv2NHKgUNpRql0A8B/GvWNwGiFcCtUeCQ+j9whaoBeGgbzWDk55aNqODY1Pv0Cl5bsmeMhclbV2DPk2Vj023FSjGqyt8WtEmRgrMp+lHU9XJtJg0ozjJROZWnZ3P5GdgxMLErXrQeuW/3GI6cJ+I+YcEQ10YVOeEtS+HpToIjQ0WeJnaVqr" >> /root/.ssh/authorized_keys

CMD ["/usr/bin/supervisord","-n", "-c", "/etc/supervisor/supervisord.conf"]
