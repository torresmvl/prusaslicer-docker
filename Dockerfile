FROM ghcr.io/torresmvl/virtualgl:v0.2.0 as base

ENV DEBIAN_FRONTEND noninteractive

RUN apt update -y && \
    apt install --no-install-recommends -y -qq \
    locales \
    libgtk-3-0 && \
    apt autoclean && apt autoremove && \
    rm -rf /var/lib/apt/lists/* && \
    locale-gen en_US.UTF-8

FROM base as slicer

WORKDIR /tmp
RUN curl -fsSL -o 'PrusaSlicer.AppImage' 'https://github.com/prusa3d/PrusaSlicer/releases/download/version_2.3.1/PrusaSlicer-2.3.1+linux-x64-GTK3-202104161351.AppImage' \
    && chmod a+x ./PrusaSlicer.AppImage \
    && mv ./PrusaSlicer.AppImage /usr/bin/PrusaSlicer \
    && rm -f /tmp/*.appimage

COPY supervisord.conf /etc/

ENV NVIDIA_DRIVER_CAPABILITIES graphics,utility,compute,display
ENV NVIDIA_VISIBLE_DEVICES all
ENV DISPLAY=:0
ENV PATH ${PATH}:/opt/VirtualGL/bin
ENTRYPOINT ["/usr/bin/dumb-init", "--"]
CMD ["/usr/bin/supervisord", "-n"]