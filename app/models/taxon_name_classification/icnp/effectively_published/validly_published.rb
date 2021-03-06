class TaxonNameClassification::Icnp::EffectivelyPublished::ValidlyPublished < TaxonNameClassification::Icnp::EffectivelyPublished

  NOMEN_URI='http://purl.obolibrary.org/obo/NOMEN_0000084'.freeze

  def self.disjoint_taxon_name_classes
    self.parent.disjoint_taxon_name_classes +
        [TaxonNameClassification::Icnp::EffectivelyPublished.to_s] +
        self.collect_descendants_and_itself_to_s(TaxonNameClassification::Icnp::EffectivelyPublished::InvalidlyPublished)
  end

  def sv_not_specific_classes
    soft_validations.add(:type, 'Please specify if the name is Legitimate or Illegitimate')
  end
end