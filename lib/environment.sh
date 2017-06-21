create_default_env() {
  export NPM_CONFIG_PRODUCTION=${NPM_CONFIG_PRODUCTION:-true}
  export NPM_CONFIG_LOGLEVEL=${NPM_CONFIG_LOGLEVEL:-error}
  export NODE_MODULES_CACHE=${NODE_MODULES_CACHE:-true}
  export NODE_ENV=${NODE_ENV:-production}
  export NODE_VERBOSE=${NODE_VERBOSE:-false}
}

add_oracle_env(){
    echo "----Add Oracle env variables----"
    local build_dir="$1"
    export LD_LIBRARY_PATH=$build_dir/oracle/instantclient:${LD_LIBRARY_PATH:-}
    export OCI_LIB_DIR=$build_dir/oracle/instantclient
    export OCI_INC_DIR=$build_dir/oracle/instantclient/sdk/include
    echo "----/Add Oracle env variables----"
  }
  
list_node_config() {
  echo ""
  printenv | grep ^NPM_CONFIG_ || true
  printenv | grep ^YARN_ || true
  printenv | grep ^NODE_ || true

  if [ "$NPM_CONFIG_PRODUCTION" = "true" ] && [ "$NODE_ENV" != "production" ]; then
    echo ""
    echo "npm scripts will see NODE_ENV=production (not '${NODE_ENV}')"
    echo "https://docs.npmjs.com/misc/config#production"
  fi
}

