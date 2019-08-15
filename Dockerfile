FROM debian:9

RUN apt-get update -y && \
    apt-get install -y supervisor openssh-server tzdata vim&& \
    apt-get autoclean && apt-get autoremove && \
    ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && \
    echo "Asia/Shanghai" > /etc/timezone
    
RUN mkdir /var/run/sshd
RUN mkdir /root/.ssh
RUN sed -ri 's/^#?PermitRootLogin\s+.*/PermitRootLogin yes/' /etc/ssh/sshd_config
RUN sed -ri 's/^#?PasswordAuthentication\s+.*/PasswordAuthentication no/' /etc/ssh/sshd_config
RUN sed -ri 's/^#?RSAAuthentication\s+.*/RSAAuthentication yes/' /etc/ssh/sshd_config
RUN sed -ri 's/^#?PubkeyAuthentication\s+.*/PubkeyAuthentication yes/' /etc/ssh/sshd_config
RUN sed -ri 's/UsePAM yes/#UsePAM yes/g' /etc/ssh/sshd_config
RUN sed -ri 's/^#?Port 22/Port 9992/g' /etc/ssh/sshd_config

ENTRYPOINT /etc/init.d/sshg start && bash
