require 'spec_helper'

# note - this set of specs is tied to the developer's API test account...
# not a good idea, but... 'IT WORKS ON MY MACHINE' :)

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
    expect(client.response['data'].first['email'])
      .to eq($spec_credentials['email'])
  end

  it 'communicates with the API to get inventory' do
    client = LeafData::Client.new
    client.get_inventory

    expect(client.response['error']).to be_nil
  end

  it 'communicates with the API to get filtered inventory, zero results' do
    client = LeafData::Client.new
    client.get_inventory(f_batch_id: 'NON.EXISTING')

    expect(client.response['error']).to be_nil
    expect(client.response['total']).to eq(0)
  end

  it 'communicates with the API to get filtered inventory, one result' do
    client = LeafData::Client.new
    client.get_inventory(f_batch_id: 'WALPHARM1.BAHCA')

    expect(client.response['error']).to be_nil
    expect(client.response['total']).to eq(1)
  end

  it 'communicates with the API to find if lab results by batch_id exist (true)' do
    client = LeafData::Client.new

    expect(client.has_results?(batch_id: 'WALPHARM1.BAHCA')).to be_truthy
  end

  it 'communicates with the API to find if lab results by inventory_id exist (true)' do
    client = LeafData::Client.new

    expect(client.has_results?(inventory_id: 'WALPHARM1.INMFD')).to be_truthy
  end

  it 'communicates with the API to find if lab results by batch_id exist (false)' do
    client = LeafData::Client.new

    expect(client.has_results?(batch_id: 'WALPHARM1.BA128P')).to be_falsey
    expect(client.response.parsed_response['data'].first['global_id']).to eq('WALPHARM1.INN70')
    expect(client.response.parsed_response['data'].first['global_batch_id']).to eq('WALPHARM1.BA128P')
  end

  it 'communicates with the API to find if lab results by inventory_id exist (false)' do
    client = LeafData::Client.new

    expect(client.has_results?(inventory_id: 'WALPHARM1.INN70')).to be_falsey
  end

  it 'communicates with the API to find if lab results exist by batch (404)' do
    client = LeafData::Client.new

    expect{ client.has_results?(batch_id: 'NON.EXISTING') }
      .to raise_error(LeafData::Errors::NotFound)
  end

  it 'communicates with the API to find if lab results exist by inventory (404)' do
    client = LeafData::Client.new

    expect{ client.has_results?(inventory_id: 'NON.EXISTING') }
      .to raise_error(LeafData::Errors::NotFound)
  end

  it 'communicates with the API to post results, delete results' do
    client = LeafData::Client.new
    random_external_id = Random.rand(10000)
    random_thc = Random.rand(15.0).round(2)
    create = {
      "lab_result" => [{
        "external_id" => "LABFLOW #{random_external_id}",
      	"tested_at" => "04/18/2018 12:34pm",
      	"testing_status" => "completed",
      	"notes" => "test notes",
      	"received_at" => "01/23/2018 4:56pm",
      	"type" => "harvest_materials",
      	"intermediate_type" => "flower_lots",
      	"moisture_content_percent" => "1",
      	"moisture_content_water_activity_rate" => ".635",
      	"cannabinoid_editor" => "WAWA1.US4",
      	"cannabinoid_status" => "completed",
      	"cannabinoid_d9_thca_percent" => "13.57",
      	"cannabinoid_d9_thca_mg_g" => nil,
      	"cannabinoid_d9_thc_percent" => "24.68",
      	"cannabinoid_d9_thc_mg_g" => nil,
      	"cannabinoid_cbd_percent" => "3.21",
      	"cannabinoid_cbd_mg_g" => nil,
      	"cannabinoid_cbda_percent" => "1.23",
      	"cannabinoid_cbda_mg_g" => nil,
      	"microbial_editor" => " WAWA1.US4",
      	"microbial_status" => "completed",
      	"microbial_bile_tolerant_cfu_g" => "0.00",
      	"microbial_pathogenic_e_coli_cfu_g" => "0.00",
      	"microbial_salmonella_cfu_g" => "0.00",
      	"mycotoxin_editor" => " WAWA1.US4",
      	"mycotoxin_status" => "completed",
      	"mycotoxin_aflatoxins_ppb" => "19.99",
      	"mycotoxin_ochratoxin_ppb" => "19.99",
      	"metal_editor" => "",
      	"metal_status" => "not_started",
      	"metal_arsenic_ppm" => nil,
      	"metal_cadmium_ppm" => nil,
      	"metal_lead_ppm" => nil,
      	"metal_mercury_ppm" => nil,
      	"pesticide_editor" => "",
      	"pesticide_status" => "not_started",
      	"pesticide_abamectin_ppm" => nil,
      	"pesticide_acephate_ppm" => nil,
      	"pesticide_acequinocyl_ppm" => nil,
      	"pesticide_acetamiprid_ppm" => nil,
      	"pesticide_aldicarb_ppm" => nil,
      	"pesticide_azoxystrobin_ppm" => nil,
      	"pesticide_bifenazate_ppm" => nil,
      	"pesticide_bifenthrin_ppm" => nil,
      	"pesticide_boscalid_ppm" => nil,
      	"pesticide_carbaryl_ppm" => nil,
      	"pesticide_carbofuran_ppm" => nil,
      	"pesticide_chlorantraniliprole_ppm" => nil,
      	"pesticide_chlorfenapyr_ppm" => nil,
      	"pesticide_chlorpyrifos_ppm" => nil,
      	"pesticide_clofentezine_ppm" => nil,
      	"pesticide_cyfluthrin_ppm" => nil,
      	"pesticide_cypermethrin_ppm" => nil,
      	"pesticide_daminozide_ppm" => nil,
      	"pesticide_ddvp_dichlorvos_ppm" => nil,
      	"pesticide_diazinon_ppm" => nil,
      	"pesticide_dimethoate_ppm" => nil,
      	"pesticide_ethoprophos_ppm" => nil,
      	"pesticide_etofenprox_ppm" => nil,
      	"pesticide_etoxazole_ppm" => nil,
      	"pesticide_fenoxycarb_ppm" => nil,
      	"pesticide_fenpyroximate_ppm" => nil,
      	"pesticide_fipronil_ppm" => nil,
      	"pesticide_flonicamid_ppm" => nil,
      	"pesticide_fludioxonil_ppm" => nil,
      	"pesticide_hexythiazox_ppm" => nil,
      	"pesticide_imazalil_ppm" => nil,
      	"pesticide_imidacloprid_ppm" => nil,
      	"pesticide_kresoxim_methyl_ppm" => nil,
      	"pesticide_malathion_ppm" => nil,
      	"pesticide_metalaxyl_ppm" => nil,
      	"pesticide_methiocarb_ppm" => nil,
      	"pesticide_methomyl_ppm" => nil,
      	"pesticide_methyl_parathion_ppm" => nil,
      	"pesticide_mgk_264_ppm" => nil,
      	"pesticide_myclobutanil_ppm" => nil,
      	"pesticide_naled_ppm" => nil,
      	"pesticide_oxamyl_ppm" => nil,
      	"pesticide_paclobutrazol_ppm" => nil,
      	"pesticide_permethrinsa_ppm" => nil,
      	"pesticide_phosmet_ppm" => nil,
      	"pesticide_piperonyl_butoxide_b_ppm" => nil,
      	"pesticide_prallethrin_ppm" => nil,
      	"pesticide_propiconazole_ppm" => nil,
      	"pesticide_propoxur_ppm" => nil,
      	"pesticide_pyrethrinsbc_ppm" => nil,
      	"pesticide_pyridaben_ppm" => nil,
      	"pesticide_spinosad_ppm" => nil,
      	"pesticide_spiromesifen_ppm" => nil,
      	"pesticide_spirotetramat_ppm" => nil,
      	"pesticide_spiroxamine_ppm" => nil,
      	"pesticide_tebuconazole_ppm" => nil,
      	"pesticide_thiacloprid_ppm" => nil,
      	"pesticide_thiamethoxam_ppm" => nil,
      	"pesticide_trifloxystrobin_ppm" => nil,
      	"solvent_editor" => "",
      	"solvent_status" => "not_started",
      	"solvent_acetone_ppm" => nil,
      	"solvent_benzene_ppm" => nil,
      	"solvent_butanes_ppm" => nil,
      	"solvent_cyclohexane_ppm" => nil,
      	"solvent_chloroform_ppm" => nil,
      	"solvent_dichloromethane_ppm" => nil,
      	"solvent_ethyl_acetate_ppm" => nil,
      	"solvent_heptanes_ppm" => nil,
      	"solvent_hexanes_ppm" => nil,
      	"solvent_isopropanol_ppm" => nil,
      	"solvent_methanol_ppm" => nil,
      	"solvent_pentanes_ppm" => nil,
      	"solvent_propane_ppm" => nil,
      	"solvent_toluene_ppm" => nil,
      	"solvent_xylene_ppm" => nil,
      	"foreign_matter_stems" => "1",
      	"foreign_matter_seeds" => "0",
      	"test_for_terpenes" => "0",
        "global_for_mme_id" => "WASTATE1.MM23S",
        "global_inventory_id" => "WALPHARM1.INMFD",
      	"global_for_inventory_id" => "WALPHARM1.INMFD",
        "global_batch_id" => "WALPHARM1.BAHCA"
      }]}
    client.post_results(create.to_json)

    puts client.response.parsed_response

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
