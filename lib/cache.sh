source $BP_DIR/lib/binaries.sh

create_signature() {
  echo "$(node --version); $(npm --version) 2>/dev/null || true)"
}

save_signature() {
  echo "$(create_signature)" > $CACHE_DIR/node/signature
}

load_signature() {
  if test -f $CACHE_DIR/node/signature; then
    cat $CACHE_DIR/node/signature
  else
    echo ""
  fi
}

get_cache_status() {
  if ! ${NODE_MODULES_CACHE:-true}; then
    echo "disabled by config"
  elif [ "$(create_signature)" != "$(load_signature)" ]; then
    echo "new runtime signature"
  else
    echo "valid"
  fi
}

get_cache_directories() {
  local dirs1=$(jq -r ".cacheDirectories // [] | .[]" < "$BUILD_DIR/package.json")
  local dirs2=$(jq -r ".cache_directories // [] | .[]" < "$BUILD_DIR/package.json")

  if [ -n "$dirs1" ]; then
    echo "$dirs1"
  else
    echo "$dirs2"
  fi
}

restore_cache_directories() {
  local build_dir=${1:-}
  local cache_dir=${2:-}

  for cachepath in ${@:3}; do
    if [ -e "$build_dir/$cachepath" ]; then
      echo "- $cachepath (exists - skipping)"
    else
      if [ -e "$cache_dir/node/$cachepath" ]; then
        echo "- $cachepath"
        mkdir -p $(dirname "$build_dir/$cachepath")
        mv "$cache_dir/node/$cachepath" "$build_dir/$cachepath"
      else
        echo "- $cachepath (not cached - skipping)"
      fi
    fi
  done
}

remove_caches_from_slug() {
  local build_dir=${1:-}
  rm -rf "$build_dir/.npm"
}

clear_cache() {
  rm -rf $CACHE_DIR/node
  mkdir -p $CACHE_DIR/node
}

save_cache_directories() {
  local build_dir=${1:-}
  local cache_dir=${2:-}

  for cachepath in ${@:3}; do
    if [ -e "$build_dir/$cachepath" ]; then
      echo "- $cachepath"
      mkdir -p "$cache_dir/node/$cachepath"
      cp -a "$build_dir/$cachepath" $(dirname "$cache_dir/node/$cachepath")
    else
      echo "- $cachepath (nothing to cache)"
    fi
  done
}
