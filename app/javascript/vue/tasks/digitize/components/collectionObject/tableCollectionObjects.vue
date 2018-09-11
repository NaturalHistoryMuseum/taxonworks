<template>
  <table>
    <tbody>
      <tr v-for="item in collectionObjects">
        <td>{{ item.total }}</td>
        <td>{{ showBiocurations(item) }}</td>
        <td>
          <radial-annotator :global-id="item.global_id"/>
        </td>
        <td>
          <button
            type="button"
            class="button circle-button btn-edit"
            @click="setCO(item)">Select</button>
        </td>
        <td>
          <pin-component
            type="CollectionObject"
            :object-id="item.id"/>
        </td>
        <td>
          <button
            type="button"
            class="button circle-button btn-delete"
            @click="removeCO(item.id)"/>
        </td>
      </tr>
    </tbody>
  </table>
</template>

<script>

import { GetterNames } from '../../store/getters/getters.js'
import { MutationNames } from '../../store/mutations/mutations.js'
import { ActionNames } from '../../store/actions/actions.js'
import RadialAnnotator from '../../../../components/annotator/annotator.vue'
import PinComponent from '../../../../components/pin'

export default {
  components: {
    RadialAnnotator,
    PinComponent
  },
  computed: {
    collectionObjects() {
      return this.$store.getters[GetterNames.GetCollectionObjects]
    },
    biocurations() {
      return this.$store.getters[GetterNames.GetBiocurations]
    }
  },
  methods: {
    setCO(value) {
      this.$store.commit(MutationNames.SetCollectionObject, value)
    },
    showBiocurations(co) {
      let list = this.biocurations.filter(item => item.biological_collection_object_id == co.id).map(item => { return item.object_tag })
      return (list.length ? list.join(', ') : 'Specimen')
    },
    removeCO(id) {
      this.$store.dispatch(ActionNames.RemoveCollectionObject, id)
    }
  }
}
</script>