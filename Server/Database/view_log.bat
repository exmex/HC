@ECHO off 
cls 
color 0A
@ECHO Opening Log file: data\%USERDOMAIN%.txt
tail -100f data\%USERDOMAIN%.err