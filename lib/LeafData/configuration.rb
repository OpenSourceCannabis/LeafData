module LeafData
  class Configuration
    attr_accessor :api_key,
                  :mme_code,
                  :base_uri,
                  :state,
                  :training,
                  :results

    def incomplete?
      [:api_key, :mme_code, :base_uri, :state].any? { |e| self.send(e).nil? }
    end

  end
end
