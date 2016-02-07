atdgen -t telegram.atd &&\
atdgen -j telegram.atd &&\
corebuild server.byte -pkg async,atdgen,cohttp.async,core,yojson
