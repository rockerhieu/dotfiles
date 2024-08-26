required_jdks=(11 17)
default_jdk=17

# Install each required JDK version if it's not already installed
for jdk_version in "${required_jdks[@]}"; do
  if [ ! -d "/Library/Java/JavaVirtualMachines/openjdk-${jdk_version}.jdk" ]; then
    echo "Installing OpenJDK ${jdk_version}..."
    brew install "openjdk@${jdk_version}"
    sudo ln -sfn "$(brew --prefix "openjdk@${jdk_version}")/libexec/openjdk.jdk" "/Library/Java/JavaVirtualMachines/openjdk-${jdk_version}.jdk"
  fi
done

# Set JAVA_HOME to the default JDK
export JAVA_HOME=$(/usr/libexec/java_home -v $default_jdk)
