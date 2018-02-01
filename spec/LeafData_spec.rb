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

    expect { LeafData::Client.new }
      .to(raise_error(LeafData::Errors::MissingConfiguration))
  end

  it 'initializes with credentials' do

    expect { LeafData::Client.new }
      .not_to raise_error
  end

  it 'communicates with the API to get users' do
    client = LeafData::Client.new
    client.get_users

    expect(client.response['error']).to be_nil
    expect(client.response['data'].first['email']).to eq($spec_credentials['email'])
  end

  it 'communicates with the API to get inventory' do
    client = LeafData::Client.new
    client.get_inventory

    expect(client.response['error']).to be_nil
  end

  it 'communicates with the API to post results, delete results' do
    client = LeafData::Client.new
    random_external_id = Random.rand(10000)
    random_thc = Random.rand(15.0).round(2)
    create = {
      "lab_result" => [{
      	"external_id" => "#{random_external_id}",
      	"tested_at" => "01/31/2018",
      	"testing_status" => "completed",
      	"notes" => "This a Random #{random_external_id}",
      	"cannabinoid_status" => "completed",
      	"cannabinoid_d9_thc_percent" => random_thc,
      	"cannabinoid_d9_thc_mg_g" => (random_thc * 10).round(2),
        "global_for_mme_id" => "WASTATE1.MM23S",
        "global_inventory_id" => "WALPHARM1.INMFD",
      	"global_for_inventory_id" => "WALPHARM1.INMFD",
        "global_batch_id" => "WALPHARM1.BAHCA"
    }]}
    client.post_results(create.to_json)

    expect(client.response.parsed_response.first['external_id']).to eq("#{random_external_id}")

    global_id = client.response.parsed_response.first['global_id']

    # update = {
    #   "lab_result" => {
    #     "notes" => "This the UPDATED #{random_external_id}",
    #     "global_id" => "#{global_id}",
    #     "global_for_mme_id" => "WASTATE1.MM23S",
    #     "global_inventory_id" => "WALPHARM1.INMFD",
    #   	"global_for_inventory_id" => "WALPHARM1.INMFD",
    #     "global_batch_id" => "WALPHARM1.BAHCA"
    #   }
    # }
    # client.update_results(update.to_json)
    # expect(client.response.parsed_response['notes']).to eq("This the UPDATED #{random_external_id}")

    client.delete_results(global_id)

    expect(client.response.parsed_response).to eq([])
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
