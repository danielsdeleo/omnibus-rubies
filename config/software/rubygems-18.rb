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

name "rubygems-18"
version "1.8.24"

# Do not specify dependency on ruby, since we don't know what ruby version
# we're getting installed under

source :url => "http://production.cf.rubygems.org/rubygems/rubygems-#{version}.tgz",
       :md5 => "3a555b9d579f6a1a1e110628f5110c6b"

relative_path "rubygems-#{version}"

build do
  ruby "setup.rb --no-rdoc --no-ri"
end
