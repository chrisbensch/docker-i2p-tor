#!/bin/ash
#

set -e

# overwrite resolv.conf - using specific DNS servers only to initially access reseed servers
cat </home/i2pd/data/network/resolv.conf >/etc/resolv.conf

# see configs: /conf/i2pd.conf
#su - i2pd
su -c "/home/i2pd/bin/i2pd --datadir=/home/i2pd/data --conf=/home/i2pd/data/conf/i2pd.conf" i2pd
#su -c "/home/i2pd/bin/i2pd --datadir=/home/i2pd/data/ --conf=/home/i2pd/data/conf/i2pd.conf --reseed.floodfill=/home/i2pd/router.info" i2pd
#/home/i2pd/bin/i2pd --datadir=/home/i2pd/data --conf=/home/i2pd/conf/i2pd.conf --tunconf=/home/i2pd/conf/tunnels.conf
