<template>
  <section-panel
    :status="status"
    :title="title"
    :spinner="loadState.biologicalAssociations"
    menu
    @menu="setModalView(true)">
    <table class="full_width">
      <thead>
        <tr>
          <th>Subject</th>
          <th>Relationship</th>
          <th>Object</th>
          <th>Citations</th>
        </tr>
      </thead>
      <tbody>
        <tr
          v-for="biologicalAssociation in filteredList"
          :key="biologicalAssociation.id">
          <td v-html="biologicalAssociation.subject.object_tag"/>
          <td v-html="biologicalAssociation.biological_relationship.object_tag"/>
          <td v-html="biologicalAssociation.object.object_tag"/>
          <td v-html="biologicalAssociation.citations.map(citation => (`${citation.source.author_year}` + (citation.pages ? `:${citation.pages}` : ''))).sort().join('; ')"/>
        </tr>
      </tbody>
    </table>
    <modal-component
      v-if="showModal"
      @close="setModalView(false)"
      :containerStyle="{ width: '900px' }">
      <h3 slot="header">Filter</h3>
      <div slot="body">
        <div class="horizontal-left-content align-start">
          <div class="full_width margin-small-right">
            <h4>Year</h4>
            <year-picker
              :years="citationYears"
              v-model="yearFilter"/>
          </div>
          <div class="full_width margin-left-margin">
            <h4>Relations</h4>
            <filter-list
              class="overflow-y-scroll"
              :list="relationList"
              v-model="relationsFilter"/>
          </div>
          <div class="full_width margin-left-margin">
            <h4>Otus</h4>
            <filter-list
              class="overflow-y-scroll"
              :type="sourcesList.length > radioBelow ? 'checkbox' : 'radio'"
              :list="otusList"
              v-model="otusFilter"/>
          </div>
        </div>
        <div class="full_width margin-left-margin">
          <h4>Sources</h4>
          <filter-list
            class="overflow-y-scroll"
            :type="sourcesList.length > radioBelow ? 'checkbox' : 'radio'"
            :list="sourcesList"
            v-model="sourcesFilter"/>
        </div>
      </div>
    </modal-component>
  </section-panel>
</template>

<script>

import SectionPanel from './shared/sectionPanel'
import extendSection from './shared/extendSections'
import ModalComponent from 'components/modal'
import { GetterNames } from '../store/getters/getters'
import YearPicker from './nomenclature/yearsPick'
import FilterList from './biologicalAssociations/filterList'
import { getUnique } from 'helpers/arrays.js'

export default {
  mixins: [extendSection],
  components: {
    SectionPanel,
    ModalComponent,
    YearPicker,
    FilterList
  },
  computed: {
    biologicalAssociations () {
      return this.$store.getters[GetterNames.GetBiologicalAssociations]
    },
    citationYears () {
      const years = [].concat(...this.biologicalAssociations.map(biological => biological.citations.map(citation => citation.source.year)))
      return years.reduce((prev, cur) => Object.assign(prev, { [cur]: (prev[cur] | 0) + 1 }), {})
    },
    filteredList () {
      return this.biologicalAssociations.filter(biological =>
        ((this.yearFilter ? biological.citations.find(citation => citation.source.year === this.yearFilter) : true) &&
        (this.checkExist(this.otusFilter, biological.object, 'id') || this.checkExist(this.otusFilter, biological.subject, 'id')) &&
        this.checkExist(this.relationsFilter, biological.biological_relationship, 'id') &&
        this.checkExist(this.sourcesFilter, biological.citations, 'source_id')
        ))
    },
    relationList () {
      return getUnique(this.biologicalAssociations.map(item => item.biological_relationship), 'id')
    },
    otusList () {
      return getUnique([].concat(...this.biologicalAssociations.map(item => [item.subject, item.object])), 'id').sort((a, b) => {
        if (a.object_label < b.object_label) {
          return -1
        }
        if (a.object_label > b.object_label) {
          return 1
        } else {
          return 0
        }
      })
    },
    sourcesList () {
      return getUnique([].concat(...this.biologicalAssociations.map(biological => biological.citations.map(citation => citation.source))), 'id').sort((a, b) => {
        if (a.cached < b.cached) {
          return -1
        }
        if (a.cached > b.cached) {
          return 1
        } else {
          return 0
        }
      })
    }
  },
  data () {
    return {
      showModal: false,
      yearFilter: undefined,
      otusFilter: [],
      relationsFilter: [],
      sourcesFilter: [],
      radioBelow: 7
    }
  },
  methods: {
    setModalView (value) {
      this.showModal = value
    },
    checkExist (filterList, item, property) {
      if (Array.isArray(filterList)) {
        return filterList.length ? Array.isArray(item) ? item.find(obj => filterList.includes(obj[property])) : filterList.includes(item[property]) : true
      } else {
        return Array.isArray(item) ? item.find(obj => filterList === obj[property]) : filterList === item[property]
      }
    }
  }
}
</script>
