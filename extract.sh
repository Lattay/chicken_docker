#!/bin/sh

cd /

if [ -d "$PREFIX_RT" ]
then
    tar -czf /out/chicken.tgz $PREFIX $PREFIX_RT
else
    tar -czf /out/chicken.tgz $PREFIX
fi
