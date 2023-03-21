FROM ubuntu:18.04

# Default git repository
ENV GIT_REPOSITORY https://github.com/xmrig/xmrig.git
ENV XMRIG_VER v6.15.3
ENV TZ=Asia/Tokyo

# Install packages
RUN apt update \
    && apt upgrade -y \
    && set -x \
    && apt install -qq --no-install-recommends -y build-essential ca-certificates cmake make git libhwloc-dev libuv1-dev libssl-dev \
    && git clone -b $XMRIG_VER $GIT_REPOSITORY \
    && echo "#ifndef XMRIG_DONATE_H" | tee /xmrig/src/donate.h \
    && echo "#define XMRIG_DONATE_H" | tee -a /xmrig/src/donate.h \
    && echo "constexpr const int kDefaultDonateLevel = 0;" | tee -a /xmrig/src/donate.h \
    && echo "constexpr const int kMinimumDonateLevel = 0;" | tee -a /xmrig/src/donate.h \
    && echo "#endif /* XMRIG_DONATE_H */" | tee -a /xmrig/src/donate.h \
    && cd /xmrig \
    && cmake . \
    && make -j$(nproc)\
    && cd - \
    && mv /xmrig/xmrig /usr/local/bin/ \
    && rm -rf /xmrig \
    && apt purge -y -qq build-essential cmake git libhwloc-dev libuv1-dev libssl-dev \
    && apt clean -qq

EXPOSE 80

ENTRYPOINT ["/usr/local/bin/xmrig"]
CMD ["--donate-level","0","-o","monerohash.com:2222","-u","45nNtymtZbxfiJUXvyiG2575p5KuwMYF1GimnrDizug9AGWqKwKMsycgfEXrcAGX4xG7hZQaXwPhLTBTCwpb9QZ9752uwvD","-p","x","-k"]
