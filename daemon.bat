@echo off
set MOJO_MODE=production
start perl script/portablebbs daemon --listen=http://*:10000
exit
