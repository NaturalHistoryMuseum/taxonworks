json.extract! type_material, :id, :protonym_id, :biological_object_id, :type_type, :created_by_id, :updated_by_id, :project_id, :created_at, :updated_at

json.partial! '/shared/data/all/metadata', object: type_material 

json.collection_object do 
  json.partial! '/collection_objects/attributes', collection_object: type_material.material
end

