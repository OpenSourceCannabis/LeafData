require 'spec_helper'

describe LeafData do
  before(:each) { configure_client }

  it 'has a version number' do
    expect(LeafData::VERSION).not_to be nil
  end

  it 'accepts a configuration, requires a complete configuration' do
    LeafData.configure do |config|
      config.base_uri = nil
      config.state = nil
    end
    expect(LeafData.configuration.api_key).to eq($spec_credentials['api_key'])
    expect(LeafData.configuration.mme_code).to eq($spec_credentials['mme_code'])
    expect(LeafData.configuration.incomplete?).to be_truthy
  end

  it 'does not initialize without credentials' do
    LeafData.configure do |config|
      config.base_uri = nil
      config.state = nil
    end
    expect { LeafData::Client.new() }
      .to(raise_error(LeafData::Errors::MissingConfiguration))
  end

  it 'initializes with credentials' do
    expect { LeafData::Client.new() }
      .not_to raise_error
  end

  it 'communicates with the API to get users' do
    client = LeafData::Client.new()
    client.get_users
    expect(client.response['error']).to be_nil
    expect(client.response['data'].first['email']).to eq($spec_credentials['email'])
  end

  it 'communicates with the API to get inventory' do
    client = LeafData::Client.new()
    client.get_inventory
    expect(client.response['error']).to be_nil
  end

  private

  def configure_client
    LeafData.configure do |config|
      config.api_key  = $spec_credentials['api_key']
      config.mme_code = $spec_credentials['mme_code']
      config.base_uri = $spec_credentials['base_uri']
      config.state    = $spec_credentials['state']
    end
  end

end
