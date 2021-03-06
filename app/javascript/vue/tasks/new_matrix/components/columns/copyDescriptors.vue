<template>
  <div>
    <modal-component
      v-if="showModal"
      :container-style="{ width: '500px', 'overflow-y': 'scroll', 'max-height': '60vh' }"
      @close="closeModal">
      <h3 slot="header">Copy descriptors from matrix</h3>
      <div slot="body">
        <spinner-component
          v-if="isLoading"
          legend="Loading..."/>
        <select
          class="full_width margin-medium-bottom"
          v-model="matrixSelected">
          <option :value="undefined">
            Select a observation matrix
          </option>
          <option
            v-for="item in observationMatrices"
            :key="item.id"
            :value="item">
            {{ item.name }}
          </option>
        </select>
        <div
          v-if="matrixSelected"
          class="flex-separate margin-small-bottom">
          <div>
            <button
              @click="addDescriptors"
              :disabled="!descriptorsSelected.length"
              class="button normal-input button-submit">
              Add descriptors
            </button>
          </div>
          <div v-if="matrixSelected">
            <button
              class="button normal-input button-default"
              @click="selectAll">
              Select all
            </button>
            <button
              class="button normal-input button-default"
              @click="unselectAll">
              Unselect all
            </button>
          </div>
        </div>
        <ul
          class="no_bullets">
          <li
            v-for="item in descriptors"
            :key="item.descriptor.id">
            <label>
              <input
                type="checkbox"
                :value="item"
                v-model="descriptorsSelected"
                :disabled="alreadyExist(item)">
              <span
                class="disabled"
                v-if="alreadyExist(item)"> {{ item.descriptor.name }} ({{ item.descriptor.type }}) <span>(Already added)</span></span>
              <span v-else>
                {{ item.descriptor.name }} ({{ item.descriptor.type }})
              </span>
            </label>
          </li>
        </ul>
      </div>
      <div
        slot="footer"
        v-if="matrixSelected"
        class="flex-separate">
        <div>
          <button
            @click="addDescriptors"
            :disabled="!descriptorsSelected.length"
            class="button normal-input button-submit">
            Add descriptors
          </button>
        </div>
        <div>
          <button
            class="button normal-input button-default"
            @click="selectAll">
            Select all
          </button>
          <button
            class="button normal-input button-default"
            @click="unselectAll">
            Unselect all
          </button>
        </div>
      </div>
    </modal-component>
  </div>
</template>

<script>

import ModalComponent from 'components/modal'
import SpinnerComponent from 'components/spinner'

import { ActionNames } from '../../store/actions/actions'
import { GetterNames } from '../../store/getters/getters'
import { GetMatrixObservationColumns, CreateColumnItem, GetObservationMatrices } from '../../request/resources'
import ObservationTypes from '../../const/types.js'

export default {
  components: {
    ModalComponent,
    SpinnerComponent
  },
  props: {
    matrixId: {
      type: [String, Number],
      required: true
    }
  },
  computed: {
    columns () {
      return this.$store.getters[GetterNames.GetMatrixColumns]
    }
  },
  data () {
    return {
      isLoading: false,
      matrixSelected: undefined,
      descriptorsSelected: [],
      descriptors: [],
      showModal: true,
      observationMatrices: []
    }
  },
  watch: {
    showModal: {
      handler (newVal) {
        if (newVal) {
          this.isLoading = true
          GetObservationMatrices().then(response => {
            response.body.splice(response.body.findIndex(item => { return this.matrixId === item.id }), 1)
            this.observationMatrices = response.body
            this.isLoading = false
          })
        }
      },
      immediate: true
    },
    matrixSelected (newVal) {
      if (newVal) {
        this.loadDescriptors(newVal.id)
      } else {
        this.descriptors = []
      }
    }
  },
  methods: {
    loadDescriptors (matrixId) {
      this.isLoading = true
      GetMatrixObservationColumns(matrixId, { per: 500 }).then(response => {
        this.descriptors = response.body
        this.isLoading = false
      })
    },
    addDescriptors () {
      const promises = []
      const index = this.columns.length
      const data = this.descriptorsSelected.map(item => {
        return {
          observation_matrix_id: this.matrixId,
          descriptor_id: item.descriptor_id,
          position: item.position + index,
          type: ObservationTypes.Column.Descriptor
        }
      })

      data.sort((a, b) => { return a - b })
      console.log(data.sort((a, b) => { return a.position - b.position }))

      data.forEach(descriptor => { promises.push(CreateColumnItem({ observation_matrix_column_item: descriptor })) })

      Promise.all(promises).then(() => {
        this.$store.dispatch(ActionNames.GetMatrixObservationColumns, this.matrixId)
        this.descriptorsSelected = []
        TW.workbench.alert.create('Descriptors was successfully added to matrix.', 'notice')
        this.closeModal()
      })
    },
    alreadyExist (item) {
      return this.columns.find(column => {
        return item.descriptor_id === column.descriptor_id
      })
    },
    closeModal () {
      this.showModal = false
      this.$emit('close')
    },
    selectAll () {
      this.descriptorsSelected = this.descriptors.filter(item => { return !this.alreadyExist(item)})
    },
    unselectAll () {
      this.descriptorsSelected = []
    }
  }
}
</script>
