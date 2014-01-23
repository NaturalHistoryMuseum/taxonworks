class TaxonNameRelationship::Icn::Accepting < TaxonNameRelationship::Icn


  def self.disjoint_taxon_name_relationships
    self.parent.disjoint_taxon_name_relationships +
        self.collect_descendants_and_itself_to_s(TaxonNameRelationship::Icn::Unaccepting)
  end

  def self.disjoint_subject_classes
    self.parent.disjoint_subject_classes +
        self.collect_descendants_to_s(TaxonNameClassification::Icn::NotEffectivelyPublished,
        TaxonNameClassification::Icn::EffectivelyPublished::InvalidlyPublished,
        TaxonNameClassification::Icn::EffectivelyPublished::ValidlyPublished::Illegitimate)
  end

end