
name "ruby-210"
maintainer "Chef"
homepage "getchef.com"

replaces        "ruby-210"
install_path    "/opt/ruby-210"
build_version   Omnibus::BuildVersion.new.semver
build_iteration 1

# creates required build directories
dependency "preparation"

dependency "ruby-210"
# ruby 2.0 comes with rubygems 2.2

# version manifest file
dependency "version-manifest"

exclude "\.git*"
exclude "bundler\/git"
