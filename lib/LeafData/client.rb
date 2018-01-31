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

    def get_users
      self.response = self.class.get('/users',  headers: auth_headers)
    end

    def get_inventory
      self.response = self.class.get('/inventories',  headers: auth_headers)
    end

    def signed_in?
    end

    private

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
