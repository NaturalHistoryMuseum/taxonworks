import { UpdateSledImage } from '../../request/resource'

export default ({ state, commit }) => {
  let co = state.collection_object
  const identifier = state.identifier

  if(identifier.namespace_id && identifier.identifier) {
    co.identifiers_attributes = [identifier]
  }
  
  const data = {
    sled_image: state.sled_image,
    collection_object: co
  }
  UpdateSledImage(state.image.sled_image_id, data).then(response => {
    console.log(response)
  })
}