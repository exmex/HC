@echo off
for /r %%f in (*.bin) do echo Decoding %%f && protoc --decode=up.up_msg up.proto < %%f > %%f.prototxt