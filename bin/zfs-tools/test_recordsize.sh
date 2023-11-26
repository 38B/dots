#! /bin/sh
# https://klarasystems.com/articles/choosing-the-right-zfs-pool-layout

file=test.tmp
rm $file 2> /dev/null
ST=`sysctl -n vfs.zfs.txg.timeout` 
ST=`expr $ST + 1`
for size in 1 2 3 4 5 6 7 8 9 11 12 13 15 16 17 23 24 25 31 32 33 63 \
        64 65 127 128 129 254 255 256 257; do
    dd if=/dev/random bs=1k count=$size of=$file 2> /dev/null
    sleep $ST
    alloc=`du -k $file | awk '{print $1}'`
    rm $file
    echo "$size K size -> $alloc K alloc"
done 
