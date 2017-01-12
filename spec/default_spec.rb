require 'spec_helper'

describe 'resources::default' do
  cached(:chef_run) do
    ChefSpec::ServerRunner.new do |node, _server|
      node.set['resources']['remote_file'] = {
        '/tmp/file.txt' => {
          'source' => 'http://host/file.txt',
          'mode' => '755',
          'resource_priority' => 90
        }
      }
      node.set['resources']['execute'] = [
        'ls -alh /tmp/file.txt',
        'cat /tmp/file.txt'
      ]
      node.set['resources']['file'] = {
        '/tmp/file.txt' => {
          'action' => 'delete',
          'resource_priority' => 110
        }
      }
    end.converge(described_recipe)
  end

  it 'creates and applies the correct resources' do
    expect(chef_run).to create_remote_file('/tmp/file.txt').with(
      source: 'http://host/file.txt',
      mode: '755'
    )
    expect(chef_run).to run_execute('ls -alh /tmp/file.txt')
    expect(chef_run).to run_execute('cat /tmp/file.txt')
    expect(chef_run).to delete_file('/tmp/file.txt')
  end
end
