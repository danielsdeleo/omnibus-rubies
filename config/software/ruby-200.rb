#
# Copyright:: Copyright (c) 2012-2013 Chef Software, Inc.
# License:: Apache License, Version 2.0
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

name "ruby-200"
version "2.0.0-p353"

dependency "zlib"
dependency "ncurses"
dependency "libedit"
dependency "openssl"
dependency "libyaml"
dependency "libiconv"
dependency "gdbm" if (platform == "mac_os_x" or platform == "freebsd")
dependency "libgcc" if (platform == "solaris2")

source :url => "http://ftp.ruby-lang.org/pub/ruby/2.0/ruby-#{version}.tar.gz",
       :md5 => '78282433fb697dd3613613ff55d734c1'

relative_path "ruby-#{version}"

env =
  case platform
  when "mac_os_x"
    {
      "CFLAGS" => "-arch x86_64 -m64 -L#{install_dir}/embedded/lib -I#{install_dir}/embedded/include -I#{install_dir}/embedded/include/ncurses -O3 -g -pipe",
      "LDFLAGS" => "-arch x86_64 -R#{install_dir}/embedded/lib -L#{install_dir}/embedded/lib -I#{install_dir}/embedded/include -I#{install_dir}/embedded/include/ncurses"
    }
  when "solaris2"
    if Omnibus.config.solaris_compiler == "studio"
    {
      "CFLAGS" => "-L#{install_dir}/embedded/lib -I#{install_dir}/embedded/include",
      "LDFLAGS" => "-R#{install_dir}/embedded/lib -L#{install_dir}/embedded/lib -I#{install_dir}/embedded/include"
    }
    elsif Omnibus.config.solaris_compiler == "gcc"
    {
      "CFLAGS" => "-L#{install_dir}/embedded/lib -I#{install_dir}/embedded/include -O3 -g -pipe",
      "LDFLAGS" => "-R#{install_dir}/embedded/lib -L#{install_dir}/embedded/lib -I#{install_dir}/embedded/include -static-libgcc",
      "LD_OPTIONS" => "-R#{install_dir}/embedded/lib"
    }
    else
      raise "Sorry, #{Omnibus.config.solaris_compiler} is not a valid compiler selection."
    end
  else
    {
      "CFLAGS" => "-I#{install_dir}/embedded/include -O3 -g -pipe",
      "LDFLAGS" => "-Wl,-rpath,#{install_dir}/embedded/lib -L#{install_dir}/embedded/lib"
    }
  end

build do
  configure_command = ["./configure",
                       "--prefix=#{install_dir}/embedded",
                       "--with-opt-dir=#{install_dir}/embedded",
                       "--with-out-ext=fiddle",
                       "--enable-shared",
                       "--enable-libedit",
                       "--with-ext=psych",
                       "--disable-install-doc"]

  if platform == "freebsd"
    configure_command << "--without-execinfo"
  elsif platform == "smartos"
    ##
    # Patches against Ruby 1.9.3 may not work correctly.
    #
    # We should try building without the patches; if they're still necessary,
    # see upstreams for updated versions.
    ##
    #
    ## # Opscode patch - someara@opscode.com
    ## # GCC 4.7.0 chokes on mismatched function types between OpenSSL 1.0.1c and Ruby 1.9.3-p286
    ## patch :source => "ruby-openssl-1.0.1c.patch", :plevel => 1

    ## # Patches taken from RVM.
    ## # http://bugs.ruby-lang.org/issues/5384
    ## # https://www.illumos.org/issues/1587
    ## # https://github.com/wayneeseguin/rvm/issues/719
    ## patch :source => "rvm-cflags.patch", :plevel => 1

    ## # From RVM forum
    ## # https://github.com/wayneeseguin/rvm/commit/86766534fcc26f4582f23842a4d3789707ce6b96
    ## configure_command << "ac_cv_func_dl_iterate_phdr=no"
  end

  command configure_command.join(" "), :env => env
  command "make -j #{max_build_jobs}", :env => env
  command "make install", :env => env
end
