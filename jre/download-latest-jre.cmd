@echo off
set http_proxy=
setlocal EnableDelayedExpansion
set path=%path%;%~dp0

del "%~dp0*i586.exe" /Q /F
del "%~dp0*x64.exe" /Q /F

for /f "tokens=*" %%l in ('^
wget --no-cookies --no-check-certificate http://www.java.com/en/download/manual.jsp -qO- ^|
grep BundleId ^|
sed "s/\d034/\n/g" ^|
grep "^http" ^|
gnusort ^|
uniq') do (
echo looking for exe installer under %%l
wget %%l -S --spider -o "%~dp0jretmp.log"
sed "s/http/\nhttp/g;s/exe/exe\n/g" "%~dp0jretmp.log" |^
grep "^http.*x64.exe$\|^http.*i586.exe$" |^
gnusort | uniq | grep "^http.*x64.exe$\|^http.*i586.exe$"
if !errorlevel!==0 (
for /f "tokens=*" %%f in ('^
sed "s/http/\nhttp/g;s/exe/exe\n/g" "%~dp0jretmp.log" ^|
grep "^http.*x64.exe$\|^http.*i586.exe$" ^|
gnusort ^|
uniq ^|
sed "s/^.*\///g"') do (
wget --no-cookies --no-check-certificate %%l -O "%~dp0%%f"
)
)
)

endlocal