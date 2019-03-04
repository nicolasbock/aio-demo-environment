#!/bin/bash

for l in $(find /var/log/log-storage -name '*.log'); do
  cat > "${l}" < /dev/null
done
for l in $(find /var/log/log-storage -name '*.xz'); do
  rm ${l}
done
