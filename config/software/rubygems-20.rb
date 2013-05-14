#
# Copyright:: Copyright (c) 2012 Opscode, Inc.
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

name "rubygems-20"
version "2.0.3"

# Do not specify dependency on ruby, since we don't know what ruby version
# we're getting installed under

source :url => "http://production.cf.rubygems.org/rubygems/rubygems-#{version}.tgz",
       :md5 => "854691f145cea98b4100e5b0831b73ed"

relative_path "rubygems-#{version}"

build do
  # Set LC_ALL to UTF-8 so that Ruby 1.9 will have a default_external encoding
  # of UTF-8. This is required to workaround a bug in rubygems 2.0.3. See this
  # commit fixing the issue (but unreleased of this writing):
  # https://github.com/rubygems/rubygems/commit/9fb90c0ed091346e148c925df2d15713ab51fda1
  ruby "setup.rb --no-rdoc --no-ri --backtrace --debug", :env => {"LC_ALL" => "en_US.UTF-8"}
end
