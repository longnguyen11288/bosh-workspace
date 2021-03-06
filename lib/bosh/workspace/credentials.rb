module Bosh::Workspace
  class Credentials
    include Bosh::Cli::Validation

    def initialize(file)
      @raw_credentials = YAML.load_file file
    end

    def perform_validation(options = {})
      Schemas::Credentials.new.validate @raw_credentials
    rescue Membrane::SchemaValidationError => e
      errors << e.message
    end

    def find_by_url(url)
      credentials[url]
    end

    private

    def credentials
      @credentials ||= begin
        Hash[@raw_credentials.map do |c|
          [c.delete('url'),
          c.each_with_object({}) { |(k, v), h| h[k.to_sym] = v }]
        end]
      end
    end
  end
end
