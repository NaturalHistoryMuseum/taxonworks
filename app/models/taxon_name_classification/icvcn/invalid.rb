class TaxonNameClassification::Icvcn::Invalid< TaxonNameClassification::Icvcn

  NOMEN_URI='http://purl.obolibrary.org/obo/NOMEN_0000126'.freeze

  def self.disjoint_taxon_name_classes
    self.parent.disjoint_taxon_name_classes +
        self.collect_descendants_and_itself_to_s(TaxonNameClassification::Icvcn::Valid)
  end

  def self.gbif_status
    'negatum'
  end

  def self.assignable
    true
  end

end