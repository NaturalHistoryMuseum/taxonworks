import { GetCollectionEvent } from '../../request/resources'
import { MutationNames } from '../mutations/mutations'

export default function ({ commit, state }, id) {
  return new Promise((resolve, reject) => {
    GetCollectionEvent(id).then(response => {
      response.roles_attributes = (response.hasOwnProperty('roles') ? response.roles : [])
      commit(MutationNames.SetCollectionEvent, response)
      resolve(response)
    })
  })
}