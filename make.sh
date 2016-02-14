atdgen -t telegram.atd &&\
atdgen -j -j-std telegram.atd &&\
corebuild server.byte -pkg async,atdgen,cohttp.async,core,yojson
