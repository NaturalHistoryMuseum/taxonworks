import setParamsId from '../../helpers/setParamsId'

export default function (state, material) {
  setParamsId('type_material_id', material.id)
  state.type_material.origin_citation = undefined
  state.type_material.origin_citation_attributes = {
    source_id: undefined,
    pages: undefined
  }

  //material.collection_object_attributes = material.collection_object
  //delete material.collection_object
  state.type_material = Object.assign({}, state.type_material, material)
};
