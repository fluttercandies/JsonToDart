script_path=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)

cd $script_path/..

root_path=$(pwd)

cd ${root_path}/Flutter/json_to_dart

FLUTTER_PROJECT_PATH=$(pwd)

flutter build macos --release

app_path="${FLUTTER_PROJECT_PATH}/build/macos/Build/Products/Release/json_to_dart.app"
dmg_path="${FLUTTER_PROJECT_PATH}/build/macos/Build/Products/Release/json_to_dart.dmg"

hdiutil create "$dmg_path" -srcfolder "$app_path"

if [ ! -f "$dmg_path" ]; then
    echo "打包失败，未找到生成的 dmg 文件"
    exit 1
fi

mv "$dmg_path" "$root_path/"

exit 0
    