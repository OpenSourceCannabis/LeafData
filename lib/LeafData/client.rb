module LeafData
  include Constants
  include Errors

  class Client
    include HTTParty

    attr_accessor :debug,
                  :response,
                  :parsed_response

    def initialize(opts = {})
      self.debug = opts[:debug]
      self.class.base_uri configuration.base_uri
      sign_in
    end

    def get_users(filters = {})
      self.response = self.class.get('/users' + parsed(filters), headers: auth_headers)
    end

    def get_inventory(filters = {})
      self.response = self.class.get('/inventories' + parsed(filters), headers: auth_headers)
    end

    def has_results?(batch_id = nil)
      raise LeafData::Errors::MissingParameter.new('You must pass `batch_id` to the `has_results?` method') unless batch_id
      get_inventory(f_batch_id: batch_id)
      raise LeafData::Errors::NotFound.new("Batch #{batch_id} not found") unless response['data'].any?
      !response['data'].first['global_lab_result_id'].nil?
    end

    def post_results(body = {})
      self.response = self.class.post('/lab_results', body: body, headers: auth_headers)
    end

    def update_results(body = {})
      self.response = self.class.post('/lab_results/update', body: body, headers: auth_headers)
    end

    def delete_results(global_id)
      self.response = self.class.delete('/lab_results/' + global_id, headers: auth_headers)
    end

    def signed_in?
      true
    end

    private

    def parsed(filters)
      return '' unless filters.length
      "?" + filters.each_pair.map{ |k,v| "#{k}=#{v}" }.join('&')
    end

    def auth_headers
      {
        'x-mjf-key' => configuration.api_key,
        'x-mjf-mme-code' => configuration.mme_code,
        'Content-Type' => 'application/json'
      }
    end

    def sign_in
      raise Errors::MissingConfiguration if configuration.incomplete?
      true
    end

    def configuration
      LeafData.configuration
    end
  end
end
