<template>
  <div>
    <h2>In relationship</h2>
    <div class="separate-bottom">
      <ul class="no_bullets">
        <li
          v-for="(item) in biologicalRelationships"
          :key="item.id">
          <label>
            <input
              :value="item.id"
              v-model="inRelationships"
              type="checkbox">
            {{ item.inverted_name ? `${item.name} / ${item.inverted_name}` : item.name }}
          </label>
        </li>
      </ul>
    </div>
  </div>
</template>

<script>

import { GetBiologicalRelationships } from '../../../request/resources.js'
import { URLParamsToJSON } from 'helpers/url/parse.js'

export default {
  props: {
    value: {
      type: Array,
      required: true
    }
  },
  computed: {
    inRelationships: {
      get () {
        return this.value
      },
      set (value) {
        this.$emit('input', value)
      }
    }
  },
  data () {
    return {
      biologicalRelationships: [],
      relationshipSelected: []
    }
  },
  mounted () {
    GetBiologicalRelationships().then(response => {
      this.biologicalRelationships = response.body
    })
    const urlParams = URLParamsToJSON(location.href)
    this.inRelationships = urlParams.biological_relationship_ids ? urlParams.biological_relationship_ids : []
  }
}
</script>