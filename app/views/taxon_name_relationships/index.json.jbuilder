json.array!(@taxon_name_relationships) do |taxon_name_relationship|
  json.partial! '/taxon_name_relationships/attributes', taxon_name_relationship: taxon_name_relationship
end

