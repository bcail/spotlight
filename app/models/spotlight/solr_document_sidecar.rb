module Spotlight
  class SolrDocumentSidecar < ActiveRecord::Base
    belongs_to :exhibit
    belongs_to :solr_document
    serialize :data, Hash

    delegate :has_key?, to: :data

    def to_solr
      { blacklight_config.solr_document_model.unique_key.to_sym => solr_document_id, visibility_field => public? }.merge(data_to_solr)
    end

    def private!
      update public: false
    end

    def public!
      update public: true
    end

    protected

    def visibility_field
      Spotlight::SolrDocument.visibility_field(exhibit)
    end

    def blacklight_config
      exhibit.blacklight_config
    end

    def data_to_solr
      Hash[data.map { |k,v| [k,v] }]
    end
  end
end
