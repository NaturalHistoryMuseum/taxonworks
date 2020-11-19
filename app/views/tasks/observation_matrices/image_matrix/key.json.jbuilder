# Build out the json response as needed

json.observation_matrix_id @key.observation_matrix_id
json.project_id @key.project_id
json.observation_matrix_citation @key.observation_matrix_citation
json.descriptor_available_languages @key.descriptor_available_languages
json.language_id @key.language_id
json.language_to_use @key.language_to_use
json.keyword_ids @key.keyword_ids
json.descriptor_available_keywords @key.descriptor_available_keywords
json.row_filter @key.row_filter
json.row_id_filter_array @key.row_id_filter_array
json.otu_filter @key.otu_filter
json.otu_id_filter_array @key.otu_id_filter_array
json.identified_to_rank @key.identified_to_rank
json.list_of_descriptors@key.list_of_descriptors

json.depiction_matrix (@key.depiction_matrix) do |d, v|
  json.object do
    json.partial! '/shared/data/all/metadata', object: v[:object]
    json.merge! v[:object].attributes
  end
  json.extract! v, :row_id
  json.depictions do
    json.array! v[:depictions] do |arrDepictions|
      json.array! arrDepictions, partial: '/depictions/attributes', as: :depiction
    end
  end
end

json.observation_matrix do
  json.partial! '/shared/data/all/metadata', object: @key.observation_matrix
  json.merge! @key.observation_matrix.attributes
end
