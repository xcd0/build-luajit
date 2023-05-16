: <<EOF_BAT
call "%~dp0busybox64.exe" bash -x "%~f0"
exit /b %ERRORLEVEL%
EOF_BAT

script_dir=$(cd $(dirname $0); pwd)
date '+%Y.%m.%d.%H.%M.%S'

cd ${script_dir}
pwd
${script_dir}
git submodule init
git submodule update --init --recursive
cd ${script_dir}/luajit2
git reset --hard @
git clean -d -f -x

cd ${script_dir}/luajit2/src
sed -i -e 's;/MD;/MT;g' ./msvcbuild.bat

cd ${script_dir}
cat <<EOF > build.bat
cd %~dp0\luajit2\src
call "C:\Program Files\Microsoft Visual Studio\2022\Professional\Common7\Tools\VsDevCmd.bat"
call msvcbuild.bat
EOF

cd ${script_dir}
cmd.exe /c build.bat

cd ${script_dir}
rm -rf ${script_dir}/Build
mkdir -p ${script_dir}/Build
cd ${script_dir}/luajit2/src
cp lua51.dll luajit.exe lua51.lib luajit.lib lua.hpp lua.h lauxlib.h lualib.h luajit.h ${script_dir}/Build
cd ${script_dir}/luajit2
mkdir -p ${script_dir}/Build/others
git clean -d -f -x -n | awk '{print $3}' | xargs -I{} cp {} ${script_dir}/Build/others
cd ${script_dir}