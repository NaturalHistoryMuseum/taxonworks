<template>
  <section-panel title="Annotations">
    <a name="annotations"/>
    <list-component
      v-if="dataAttributes.length"
      title="Data attributes"
      :list="dataAttributes"/>
    <list-component
      v-if="identifiers.length"
      title="Identifiers"
      :list="identifiers"/>
    <list-component
      v-if="notes.length"
      title="Notes"
      :list="notes"/>
    <list-component
      v-if="tags.length"
      title="Tags"
      :list="tags"/>
  </section-panel>
</template>

<script>

import SectionPanel from './shared/sectionPanel'
import ListComponent from './shared/list'
import { GetIdentifiers, GetNotes, GetTags, GetDataAttributes } from '../request/resources.js'

export default {
  components: {
    ListComponent,
    SectionPanel
  },
  props: {
    otu: {
      type: Object
    }
  },
  data() {
    return {
      identifiers: [],
      notes: [],
      dataAttributes: [],
      tags: []
    }
  },
  watch: {
    otu: {
      handler(newVal) {
        if(newVal) {
          GetIdentifiers(this.otu.id).then(response => {
            this.identifiers = response.body
          })
          GetTags(this.otu.id).then(response => {
            this.tags = response.body
          })
          GetNotes(this.otu.id).then(response => {
            this.notes = response.body
          })
          GetDataAttributes(this.otu.id).then(response => {
            this.dataAttributes = response.body
          })
        }
      },
      immediate: true
    }
  }
}
</script>