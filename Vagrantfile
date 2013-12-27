# -*- mode: ruby -*-
# vi: set ft=ruby :

require "vagrant"
require "pathname"

if Vagrant::VERSION < "1.2.1"
  raise "The Omnibus Build Lab is only compatible with Vagrant 1.2.1+"
end

host_project_path = File.expand_path("..", __FILE__)
guest_project_path = "/home/vagrant/#{File.basename(host_project_path)}"
project_name = 'rubies'

project_builds = Dir.glob("config/projects/*.rb").map do |f|
  Pathname(f).basename(".rb").to_s
end

host_name = "#{project_name}-omnibus-build-lab}"

Vagrant.configure("2") do |config|

  %w{
    centos-5.10
    centos-6.5
    ubuntu-10.04
    ubuntu-11.04
    ubuntu-12.04
  }.each_with_index do |platform, index|
    config.vm.define platform do |c|
      c.vm.box = "opscode-#{platform}"
      c.vm.box_url = "http://opscode-vm-bento.s3.amazonaws.com/vagrant/virtualbox/opscode_#{platform}_chef-provisionerless.box"

      c.vm.provider :virtualbox do |vb|
        vb.customize [
          'modifyvm', :id,
          '--memory', '1536',
          '--cpus', '2'
        ]
      end

      config.omnibus.chef_version = :latest
      config.berkshelf.enabled = true
      config.berkshelf.berksfile_path = "./Berksfile"
      config.ssh.forward_agent = true
      config.vm.synced_folder host_project_path, guest_project_path

      project_builds.each do |proj|
        config.vm.provision :chef_solo do |chef|
          chef.json = {
            "omnibus" => {
              "build_user" => "vagrant",
              "build_dir" => guest_project_path,
              "install_dir" => "/opt/#{proj}"
            }
          }

          chef.run_list = [
            "recipe[omnibus::default]"
          ]
        end

        config.vm.provision :shell, :inline => <<-OMNIBUS_BUILD
        export PATH=/usr/local/bin:$PATH
        cd #{guest_project_path}
        su vagrant -c "bundle install --binstubs"
        su vagrant -c "bin/omnibus build project #{proj}"
      OMNIBUS_BUILD
      end
    end
  end
end
