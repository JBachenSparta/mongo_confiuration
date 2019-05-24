#
# Cookbook:: chefProxy
# Spec:: default
#
# Copyright:: 2019, The Authors, All Rights Reserved.

require 'spec_helper'

describe 'chefProxy::default' do
  context 'When all attributes are default, on Ubuntu 18.04' do
    let(:chef_run) do
      # for a complete list of available platforms and versions see:
      # https://github.com/customink/fauxhai/blob/master/PLATFORMS.md
      runner = ChefSpec::SoloRunner.new(platform: 'ubuntu', version: '18.04')
      runner.converge(described_recipe)
    end

    it 'converges successfully' do
      expect { chef_run }.to_not raise_error
    end

    it 'runs apt get update' do
      expect(chef_run).to update_apt_update 'update_sources'
    end

    it 'Should add mongo to the sources list' do
      expect(chef_run).to add_apt_repository('mongodb-org')
    end

    it 'Should install mongo' do
      expect(chef_run).to upgrade_package('mongodb-org')
    end

    it 'should enable the mongodb service' do
      expect(chef_run).to enable_service 'mongodb-org'
    end

    it 'should start the mongodb service' do
      expect(chef_run).to start_service 'mongodb-org'
    end

    # it 'should create a proxy.conf template in /data/configdb' do
    #   expect(chef_run).to create_template("/etc/mongod.conf")
    # end
    #
    # it 'should create a proxy.conf template in /etc' do
    #   expect(chef_run).to create_template("/etc/mongod/sites-available/mongod.conf").with_variables(proxy_port: 27017)
    # end


    it 'should create a mongod_proxy.conf template in /etc/mongod/sites-available' do
      expect(chef_run).to create_template("/etc/mongod.conf").with_variables(proxy_port: 27017)
    end


    it 'should create a mongod.service template in /etc' do
      expect(chef_run).to create_template("/lib/systemd/system/mongod.service")
    end



    # it 'should create a symlink of mongod.conf from /etc/mongod.conf to sites-enabled' do
    #   expect(chef_run).to create_link("/etc/nginx/sites-enabled/proxy.conf").with_link_type(:symbolic)
    # end
    #
    # it 'should delete the symlink from the default config in sites-enabled' do
    #   expect(chef_run).to delete_link "/etc/nginx/sites-enabled/default"
    # end

    # it "should install nodejs from a recipe" do
    #   expect(chef_run).to include_recipe("nodejs")
    # end
    #
    # it 'should install pm2 via npm' do
    #   expect(chef_run).to install_nodejs_npm('pm2')
    # end

  end
end
