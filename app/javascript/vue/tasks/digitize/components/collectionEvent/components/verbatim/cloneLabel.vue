<template>
  <div>
    <spinner-component
      v-if="searching"
      :show-legend="false"
      :logo-size="{ 
        width: '14px', 
        height: '14px' 
    }"/>
    <button
      type="button"
      class="button normal-input button-default"
      @click="cloneLabel"
      :disabled="!bufferedCollectingEvent">Clone from specimen
    </button>
    <modal-component
      v-if="showModal"
      @close="closeModal">
      <h3 slot="header">Existing collecting events</h3>
      <div slot="body">
        <ul class="no_bullets">
          <li
            v-for="ce in list"
            :key="ce.id"
            class="separate-bottom">
            <label
              @click="selectedCE = ce">
              <input
                type="radio"
                name="modal-ce">
              {{ ce.object_tag }}
            </label>
          </li>
          <button
            type="button"
            :disabled="!selectedCE"
            @click="setCE(selectedCE)"
            class="button normal-input button-default">
            Set collecting event
          </button>
        </ul>
      </div>
    </modal-component>
  </div>
</template>

<script>

import { GetterNames } from '../../../../store/getters/getters'
import { MutationNames } from '../../../../store/mutations/mutations'
import { FilterCollectingEvent, ParseVerbatim } from '../../../../request/resources.js'
import ModalComponent from 'components/modal'
import SpinnerComponent from 'components/spinner'

export default {
  components: {
    ModalComponent,
    SpinnerComponent
  },
  computed: {
    label: {
      get() {
        return this.$store.getters[GetterNames.GetCollectionEvent].verbatim_label
      },
      set(value) {
        this.$store.commit(MutationNames.SetCollectionEventLabel, value)
      }
    },
    bufferedCollectingEvent() {
      return this.$store.getters[GetterNames.GetCollectionObject].buffered_collecting_event
    },
    collectingEvent: {
      get () {
        return this.$store.getters[GetterNames.GetCollectionEvent]
      },
      set (value) {
        this.$store.commit(MutationNames.SetCollectionEvent, value)
      }
    }
  },
  data() {
    return {
      selectedCE: undefined,
      showModal: false,
      searching: false,
      list: []
    }
  },
  watch: {
    list(newVal) {
      if(newVal.length > 0) {
        this.showModal = true
      }
      else {
        this.$store.commit(MutationNames.SetCollectionEventLabel, this.bufferedCollectingEvent)
      }
    }
  },
  methods: {
    cloneLabel() {
      this.searching = true
      FilterCollectingEvent({ verbatim_label: this.bufferedCollectingEvent }).then(response => {
        this.list = response.body
        this.searching = false
        ParseVerbatim(this.bufferedCollectingEvent).then(response => {
          const parsed = response.body
          this.collectingEvent = Object.assign(this.collectingEvent, parsed.date, parsed.geo.verbatim, parsed.elevation, parsed.collecting_method)
        })
      })
    },
    setCE(ce) {
      this.$store.commit(MutationNames.SetCollectionEvent, ce)
      this.closeModal()
    },
    closeModal() {
      this.showModal = false
      this.selectedCE = false
    }
  }
}
</script>