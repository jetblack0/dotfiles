ARG TARGETARCH
FROM archlinux:latest AS base-amd64
FROM menci/archlinuxarm:latest AS base-arm64

FROM base-${TARGETARCH}

# pacman >= 7 sandboxes downloads with Landlock, which cannot be applied
# inside a container, so every sync would fail. Real machines are unaffected.
RUN sed -i '/^\[options\]/a DisableSandbox' /etc/pacman.conf \
 && pacman -Syu --noconfirm ansible \
 && pacman -Scc --noconfirm

CMD ["sleep", "infinity"]
