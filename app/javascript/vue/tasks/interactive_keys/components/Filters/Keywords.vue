<template>
  <div>
    <label class="display-block">Descriptor filter</label>
    <button
      class="button normal-input button-default"
      @click="setModalView(true)">
      Keywords
    </button>
    <modal-component
      v-if="showModal"
      @close="setModalView(false)">
      <h3 slot="header">Keywords</h3>
      <div slot="body">
        <ul class="no_bullets">
          <li
            v-for="keyword in observationMatrix.descriptor_available_keywords"
            :key="keyword.id">
            <label>
              <input
                v-model="filters.keyword_ids"
                :value="keyword.id"
                type="checkbox">
              {{ keyword.name }}
            </label>
          </li>
        </ul>
      </div>
      <div slot="footer">
        <button
          type="button"
          class="button normal-input button-default"
          @click="applyChanges">
          Apply
        </button>
      </div>
    </modal-component>
  </div>
</template>

<script>

import ModalComponent from 'components/modal'
import { GetterNames } from '../../store/getters/getters'
import { MutationNames } from '../../store/mutations/mutations'
import { ActionNames } from '../../store/actions/actions'

export default {
  components: {
    ModalComponent
  },
  computed: {
    observationMatrix () {
      return this.$store.getters[GetterNames.GetObservationMatrix]
    },
    filters: {
      get () {
        return this.$store.getters[GetterNames.GetParamsFilter]
      },
      set (value) {
        this.$store.commit(MutationNames.SetParamsFilter, value)
      }
    }
  },
  data () {
    return {
      showModal: false
    }
  },
  methods: {
    setModalView (value) {
      this.showModal = value
    },
    applyChanges () {
      this.$store.dispatch(ActionNames.LoadObservationMatrix, this.observationMatrix.observation_matrix_id).then(() => {
        this.setModalView(false)
      })
      document.querySelector('.descriptors-view div').scrollIntoView(0)
    }
  }
}
</script>

<style>

</style>