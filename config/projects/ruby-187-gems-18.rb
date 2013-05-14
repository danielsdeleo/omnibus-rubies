
name "ruby-187-gems-18"
maintainer "Opscode"
homepage "opscode.com"

replaces        "ruby-187-gems-18"
install_path    "/opt/ruby-187-gems-18"
build_version   Omnibus::BuildVersion.new.semver
build_iteration 1

# creates required build directories
dependency "preparation"

dependency "ruby-187"
dependency "rubygems-18"

# version manifest file
dependency "version-manifest"

exclude "\.git*"
exclude "bundler\/git"
