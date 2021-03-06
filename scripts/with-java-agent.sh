#!/usr/bin/env bash

# 4, because that's the number of JVMs we test on
counter=$((${GO_PIPELINE_COUNTER}+1))
mod="$((${counter} % 3))"

function use_jdk() {
  if [ ! -f "${HOME}/.jabba/jabba.sh" ]; then
    curl -sL https://github.com/shyiko/jabba/raw/master/install.sh | bash
  fi
  source "${HOME}/.jabba/jabba.sh"
  jabba install "$1=$2"
  jabba use "$1"
}

if [ "$mod" = "0" ]; then
  # use the system jvm
  true
elif [ "$mod" = "1" ]; then
  use_jdk "openjdk@1.10.0-2" "tgz+https://nexus.gocd.io/repository/s3-mirrors/local/jdk/openjdk-10.0.2_linux-x64_bin.tar.gz"
elif [ "$mod" = "2" ]; then
  use_jdk "openjdk@1.11.0-28" "tgz+https://nexus.gocd.io/repository/s3-mirrors/local/jdk/openjdk-11-28_linux-x64_bin.tar.gz"
fi

echo "JAVA_HOME set for agent to : $JAVA_HOME"

exec "$@"
