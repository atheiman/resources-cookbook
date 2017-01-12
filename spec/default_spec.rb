require 'spec_helper'

describe 'resources::default' do
  context 'When all attributes are default, on an unspecified platform' do
    let(resources) do
      {
        'cat /tmp/file_a' => {'resource_type' => 'execute'},
        '/tmp/file_a' => {'resource_type' => }
      }
    end

    cached(:chef_run) do
      ChefSpec::ServerRunner.new do |node, server|
        node.set['resources'] = resources
      end.converge(described_recipe)
    end

    it 'converges successfully' do
      expect { chef_run }.to_not raise_error
    end
  end
end
