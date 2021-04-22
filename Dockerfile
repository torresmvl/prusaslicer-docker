FROM ghcr.io/torresmvl/virtualgl:v0.2.0 as base

ENV DEBIAN_FRONTEND noninteractive

RUN apt update && apt install -y -qq --no-install-recommends \
  freeglut3 \
  libwxgtk3.0-gtk3-0v5 \
  libgtk-3-bin \
  libgtk-3-0 \
  libwx-perl \
  xdg-utils \
  lynx \
  dbus-x11 \
  locales \
  curl \
  ca-certificates \
  jq \
  unzip \
  && rm -rf /var/lib/apt/lists/* \
  && apt autoremove -y \
  && apt autoclean

RUN sed -i \
  -e 's/^# \(en_US\.UTF-8.*\)/\1/' \
  -e 's/^# \(fr_FR\.UTF-8.*\)/\1/' \
  -e 's/^# \(it_IT\.UTF-8.*\)/\1/' \
  -e 's/^# \(de_DE\.UTF-8.*\)/\1/' \
  -e 's/^# \(es_ES\.UTF-8.*\)/\1/' \
  -e 's/^# \(cs_CZ\.UTF-8.*\)/\1/' \
  -e 's/^# \(pl_PL\.UTF-8.*\)/\1/' \
  -e 's/^# \(uk_UA\.UTF-8.*\)/\1/' \
  -e 's/^# \(ko_KR\.UTF-8.*\)/\1/' \
  -e 's/^# \(zh_CN\.UTF-8.*\)/\1/' \
  -e 's/^# \(pt_BR\.UTF-8.*\)/\1/' \
  /etc/locale.gen \
  && locale-gen 

WORKDIR /tmp

RUN curl -LO \
  'https://github.com/prusa3d/PrusaSlicer/releases/download/version_2.3.1/PrusaSlicer-2.3.1+linux-x64-GTK3-202104161351.tar.bz2' \
  && mkdir -p /tmp/Prusa3D/slicer \
  && tar -xjf PrusaSlicer-2.3.1+linux-x64-GTK3-202104161351.tar.bz2 -C /tmp/Prusa3D/slicer --strip-components 1 \
  && mv ./Prusa3D /usr/local/lib/Prusa3D \
  && rm -rf /tmp/* \
  && apt purge -y --auto-remove curl jq unzip bzip2 \
  && rm -rf /var/lib/apt/lists/* \
  && apt autoremove -y \
  && apt autoclean

COPY supervisord.conf /etc/

ENV NVIDIA_DRIVER_CAPABILITIES=graphics,utility,compute,display
ENV NVIDIA_VISIBLE_DEVICES=all
ENV DISPLAY=:0
# ENV PATH=/opt/VirtualGL/bin:/usr/local/lib/Prusa3D/slicer/bin:$PATH
# ENV LANG=$LANG
WORKDIR /usr/local/lib/Prusa3D/slicer
ENTRYPOINT ["/usr/bin/dumb-init", "--"]
CMD ["/usr/bin/supervisord", "-n"]