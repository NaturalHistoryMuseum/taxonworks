class SF::GenusName < SpeciesFileRecord
  self.table_name = 'tblGenusNames'

  belongs_to :species_file, class_name: 'SF::SpeciesFile', foreign_key: 'FileID'

  belongs_to :creator, class_name: 'SF::FileUser', foreign_key: 'CreatedBy'
  belongs_to :updater, class_name: 'SF::FileUser', foreign_key: 'ModifiedBy'
end
