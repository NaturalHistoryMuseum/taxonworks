<template>
  <div>
    <h2>Type</h2>
    <ul class="no_bullets context-menu">
      <li v-for="(item, key) in types">
        <label class="capitalize">
          <input
            v-model="type"
            :value="item"
            type="radio">
          {{ key }}
        </label>
      </li>
    </ul>
  </div>
</template>

<script>

import { URLParamsToJSON } from 'helpers/url/parse.js'

export default {
  props: {
    value: {
      type: String,
      default: undefined
    }
  },
  computed: {
    type: {
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
      types: {
        Any: undefined,
        Bibtex: 'Source::Bibtex',
        Verbatim: 'Source::Verbatim',
        Person: 'Source::Human'
      }
    }
  },
  mounted () {
    this.type = URLParamsToJSON(location.href).source_type
  }
}
</script>
