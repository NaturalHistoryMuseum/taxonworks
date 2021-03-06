<template>
  <div class="panel content">
    <h2>Taxon determination</h2>
    <fieldset>
      <legend>Otu</legend>
      <smart-selector
        class="margin-medium-bottom"
        model="otus"
        pin-section="Otus"
        pin-type="Otu"
        target="TaxonDetermination"
        @selected="setOtu"
      />
      <p
        v-if="selectedOtu"
        class="middle">
        <span
          class="margin-small-right"
          v-html="selectedOtu.object_tag"/>
        <span
          class="button-circle button-default btn-undo"
          @click="selectedOtu = undefined"/>
      </p>
    </fieldset>
    <fieldset>
      <legend>Determiner</legend>
      <smart-selector
        model="people"
        target="Determiner"
        :autocomplete="false"
        @selected="addRole">
        <role-picker
          class="margin-medium-top"
          roleType="Determiner"
          v-model="taxon_determination.roles_attributes"/>
      </smart-selector>
    </fieldset>
    <div class="horizontal-left-content date-fields separate-bottom separate-top">
      <div class="separate-right">
        <label>Year</label>
        <input
          type="text"
          v-model="taxon_determination.year_made">
      </div>
      <div class="separate-right separate-left">
        <label>Month</label>
        <input
          type="text"
          v-model="taxon_determination.month_made">
      </div>
      <div class="separate-left">
        <label>Day</label>
        <input
          type="text"
          v-model="taxon_determination.day_made">
      </div>
      <div>
        <label>&nbsp</label>
        <div class="align-start">
          <button
            type="button"
            class="button normal-input button-default separate-left separate-right"
            @click="setActualDate">
            Now
          </button>
        </div>
      </div>
    </div>
    <div class="flex-separate">
      <button
        type="button"
        id="determination-add-button"
        :disabled="!selectedOtu"
        class="button normal-input button-submit separate-top"
        @click="addDetermination">Add</button>
      <button
        type="button"
        :disabled="!validateCreation"
        class="button normal-input button-submit"
        @click="createTaxonDeterminations()">
        Create
      </button>
    </div>
    <list-component
      :list="taxon_determinations"
      @deleteIndex="removeTaxonDetermination"
      set-key="otu_id"
      label="object_tag"/>
  </div>
</template>

<script>

import SmartSelector from 'components/smartSelector'
import RolePicker from 'components/role_picker'
import { CreateDetermination } from '../../request/resources'
import { CreatePerson } from 'helpers/persons/createPerson'

import ListComponent from 'components/displayList'


export default {
  components: {
    ListComponent,
    SmartSelector,
    RolePicker
  },
  props: {
    ids: {
      type: Array,
      required: true
    }
  },
  computed: {
    validateCreation () {
      return this.ids.length && this.taxon_determinations.length
    }
  },
  data () {
    return {
      taxon_determinations: [],
      taxon_determination: undefined,
      selectedOtu: undefined,
      isSaving: false
    }
  },
  created () {
    this.resetDetermination()
  },
  methods: {
    setActualDate() {
      let today = new Date()
      this.taxon_determination.day_made = today.getDate()
      this.taxon_determination.month_made = today.getMonth() + 1
      this.taxon_determination.year_made = today.getFullYear()
    },
    roleExist(id) {
      return (this.taxon_determination.roles_attributes.find((role) => {
        return !role.hasOwnProperty('_destroy') && role.hasOwnProperty('person_id') && role.person_id == id
      }) ? true : false)
    },
    addRole(role) {
      if(!this.roleExist(role.id)) {
        this.taxon_determination.roles_attributes.push(CreatePerson(role, 'Determiner'))
      }
    },
    addDetermination() {
      if(this.taxon_determinations.find((determination) => { return determination.otu_id == this.taxon_determination.otu_id })) { return }
      this.taxon_determination.object_tag = this.selectedOtu.object_tag
      this.taxon_determinations.push(this.taxon_determination)
      this.selectedOtu = undefined
      
      this.resetDetermination()
    },
    resetDetermination () {
      this.taxon_determination = {
        otu_id: undefined,
        year_made: undefined,
        month_made: undefined,
        day_made: undefined,
        roles_attributes: [],
      }
    },
    setOtu (otu) {
      this.taxon_determination.otu_id = otu.id
      this.selectedOtu = otu
    },
    createTaxonDeterminations (position = 0) {
      let promises = []
      if(position < this.ids.length) {
        this.taxon_determinations.forEach(determination => {
          determination.biological_collection_object_id = this.ids[position]
          promises.push(new Promise((resolve, reject) => {
            CreateDetermination(determination).then(response => {
              resolve()
            }, () => {
              resolve()
            })
          }))
        })
        position++
      }
      Promise.all(promises).then(response => {
        if(position < this.ids.length)
          this.createTaxonDeterminations(position)
        else {
          this.isSaving = false
          TW.workbench.alert.create('Taxon determinations was successfully created.', 'notice')
        }
      })
    },
    removeTaxonDetermination(index) {
      this.taxon_determinations.splice(index, 1)
    }
  }
}
</script>
<style lang="scss" scoped>
  .date-fields {
    input {
      width:60px;
    }
    label {
      display: block;
    }
  }
</style>