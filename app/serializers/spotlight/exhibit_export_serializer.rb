module Spotlight

  def self.ExportSerializer klass
    return Class.new(ExportSerializer) do
      attributes *(klass.attribute_names.map { |x| x.to_sym })
    end

  end

  class ExportSerializer < ActiveModel::Serializer
    def filter keys
      keys = keys.reject { |k| k.to_s =~ /id$/ }
      keys = keys - [:scope]
    end
  end

  class PageExportSerializer  < Spotlight::ExportSerializer(Spotlight::Page)
    has_many :child_pages, root: 'child_pages_attributes', serializer: PageExportSerializer
  end

  class SolrDocumentSerializer < Spotlight::ExportSerializer(Spotlight::SolrDocumentSidecar)
    def filter keys
      keys = super
      keys += [:solr_document_id]
    end
  end

  class TaggingSerializer < Spotlight::ExportSerializer(ActsAsTaggableOn::Tagging)
    has_one :tag, root: 'tag_attributes', serializer: Spotlight.ExportSerializer(ActsAsTaggableOn::Tag)
    def filter keys
      keys = super
      keys -= [:tagger_type]
      keys -= [:context] # context conflicts with ActiveRecord methods; fortunately, we only have the default context
      keys += [:taggable_id]
    end
  end

  class ExhibitExportSerializer < Spotlight::ExportSerializer(Spotlight::Exhibit)
    self.root = false

    def filter  keys
      keys = super
      keys = keys - [:slug, :name, :default]
    end

    def feature_pages
      object.feature_pages.at_top_level
    end

    has_many :searches, root: 'searches_attributes', serializer: Spotlight.ExportSerializer(Spotlight::Search)
    has_one :home_page, root: 'home_page_attributes', serializer:  Spotlight.ExportSerializer(Spotlight::Page)
    has_many :about_pages, root: 'about_pages_attributes', serializer:  Spotlight.ExportSerializer(Spotlight::Page)
    has_many :feature_pages, root: 'feature_pages_attributes', serializer:  Spotlight::PageExportSerializer
    has_many :custom_fields, root: 'custom_fields_attributes', serializer: Spotlight.ExportSerializer(Spotlight::CustomField)
    has_many :contacts, root: 'contacts_attributes', serializer: Spotlight.ExportSerializer(Spotlight::Contact)
    has_many :contact_emails, root: 'contact_emails_attributes', serializer: Spotlight.ExportSerializer(Spotlight::ContactEmail)
    has_one :blacklight_configuration, root: 'blacklight_configuration_attributes', serializer: Spotlight.ExportSerializer(Spotlight::BlacklightConfiguration)
    
    has_many :solr_document_sidecars, root: 'solr_document_sidecars_attributes', serializer: Spotlight::SolrDocumentSerializer
    has_many :owned_taggings, root: 'owned_taggings_attributes', serializer: Spotlight::TaggingSerializer
    # todo: include attachment binary paylod??
    has_many :attachments, root: 'attachments_attributes', serializer: Spotlight.ExportSerializer(Spotlight::Attachment)

    has_many :resources, root: 'resources_attributes', serializer: Spotlight.ExportSerializer(Spotlight::Resource)
  end

end
