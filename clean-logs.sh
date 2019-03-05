#!/bin/bash

find /var/log/log-storage -name '*.log' -type f -exec /bin/bash -c 'cat > "{}" < /dev/null' \;
find /var/log/log-storage -name '*.xz' -type -f -exec /bin/bash -c 'rm "{}"' \;
