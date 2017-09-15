install_oracle_libraries(){
  echo $HOME
  local build_dir=${1:-}
  echo "Installing oracle libraries"
  mkdir -p $build_dir/oracle
  cd $build_dir/oracle
  mv $BUILDPACK_DIR/zip/instantclient-basiclite-linux.x64-12.2.0.1.0.zip instantclient-basic.zip
  mv $BUILDPACK_DIR/zip/instantclient-sdk-linux.x64-12.2.0.1.0.zip instantclient-sdk.zip
  echo "Zip moved"
  echo "unzipping libraries"
  unzip instantclient-basic.zip
  unzip instantclient-sdk.zip
  mv instantclient_12_2 instantclient
  cd instantclient
  ln -s libclntsh.so.12.2 libclntsh.so
  export LD_LIBRARY_PATH=$build_dir/oracle/instantclient:$LD_LIBRARY_PATH
}

list_dependencies() {
  local build_dir="$1"

  cd "$build_dir"
  (npm ls --depth=0 | tail -n +2 || true) 2>/dev/null
}

run_if_present() {
  local script_name=${1:-}
  local has_script=$(jq -r ".scripts[\"$script_name\"] // \"\"" < "$BUILD_DIR/package.json")
  if [ -n "$has_script" ]; then
    echo "Running $script_name"
    npm run "$script_name" --if-present
  fi
}

npm_move_loopback_oracle_package() {
  local build_dir=${1:-}
  echo "Move loopback-oracle-Linux-x64 package into build directory"
  mv $BUILDPACK_DIR/zip/loopback-oracle-Linux-x64-abi48-2.1.0.tar.gz $build_dir
}

npm_node_modules() {
  local build_dir=${1:-}
  if [ -e $build_dir/package.json ]; then
    cd $build_dir
    if [ -e $build_dir/npm-shrinkwrap.json ]; then
      echo "Installing node modules (package.json + shrinkwrap)"
    else
      echo "Installing node modules (package.json)"
    fi
    npm install --unsafe-perm --userconfig $build_dir/.npmrc --cache $build_dir/.npm 2>&1
  else
    echo "Skipping (no package.json)"
  fi
}

npm_rebuild() {
  local build_dir=${1:-}

  if [ -e $build_dir/package.json ]; then
    cd $build_dir
    echo "Rebuilding any native modules"
    npm rebuild --nodedir=$NODE_HOME 2>&1
    if [ -e $build_dir/npm-shrinkwrap.json ]; then
      echo "Installing any new modules (package.json + shrinkwrap)"
    else
      echo "Installing any new modules (package.json)"
    fi
    npm install --unsafe-perm --userconfig $build_dir/.npmrc 2>&1
  else
    echo "Skipping (no package.json)"
  fi
}
