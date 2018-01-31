require 'spec_helper'

describe LeafData do

  it 'has a version number' do
    expect(LeafData::VERSION).not_to be nil
  end

  it 'accepts a configuration' do
    LeafData.configure do |config|
      config.api_key  = $spec_credentials['api_key']
      config.mme_code = $spec_credentials['mme_code']
    end
    expect(LeafData.configuration.api_key).to eq($spec_credentials['api_key'])
    expect(LeafData.configuration.mme_code).to eq($spec_credentials['mme_code'])
    expect(LeafData.configuration.incomplete?).to be_truthy
  end

  it 'does not initialize without credentials' do
    expect { LeafData::Client.new() }
      .to(raise_error(LeafData::Errors::MissingConfiguration))
  end

  it 'initializes with credentials' do
    LeafData.configure do |config|
      config.api_key  = $spec_credentials['api_key']
      config.mme_code = $spec_credentials['mme_code']
      config.base_uri = $spec_credentials['base_uri']
      config.state    = $spec_credentials['state']
    end
    expect { LeafData::Client.new() }
      .not_to raise_error
  end

  it 'communicates with the API' do
    LeafData.configure do |config|
      config.api_key  = $spec_credentials['api_key']
      config.mme_code = $spec_credentials['mme_code']
      config.base_uri = $spec_credentials['base_uri']
      config.state    = $spec_credentials['state']
    end
    client = LeafData::Client.new()
    client.get_users
    expect(client.response.key('error')).to be_falsey
    expect(client.response['data'].first['email']).to eq($spec_credentials['email'])
  end

end
