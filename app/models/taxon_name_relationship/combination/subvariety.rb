class TaxonNameRelationship::Combination::Subvariety < TaxonNameRelationship::Combination

  # left_side
  def self.valid_subject_ranks
    SPECIES_RANKS_NAMES_ICN
  end

  # right_side
  def self.valid_object_ranks
    SPECIES_RANKS_NAMES_ICN
  end

  def self.assignable
    true
  end

end
