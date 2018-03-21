cd /d %~dp0

for /r ./ %%i in (bin) do (
	rd /s /q %%i
)

for /r ./ %%i in (gen) do (
	rd /s /q %%i
)