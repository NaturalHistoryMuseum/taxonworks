<template>
  <div>
    <h2>Layout</h2>
    <div class="field">
      <label class="label-layout-size">Columns</label>
      <input
        v-model="columns"
        type="number">
    </div>
    <div class="field">
      <label class="label-layout-size">Lines per column</label>
      <input
        v-model="rows"
        type="number">
    </div>
    <div class="field">
      <label class="label-layout-size">Separator</label>
      <input
        v-model="separator"
        type="text">
      <button
        type="button"
        class="button normal-input button-default"
        @click="onClear">
        Clear
      </button>
    </div>
    <label>
      <input 
        type="checkbox"
        v-model="divisor">
      Blank lines around the separator
    </label>
  </div>
</template>
<script>
export default {
  data() {
    return {
      rows: 151,
      columns: 9,
      divisor: false,
      separator: ''
    }
  },
  watch: {
    rows(newVal) {
      this.$emit('onRowsChange', newVal)
    },
    columns(newVal) {
      this.$emit('onColumnsChange', newVal)
    },
    divisor(newVal) {
      this.$emit('onDivisorChange', newVal)
    },
    separator(newVal) {
      this.$emit('onSeparatorChange', newVal)
    },
  },
  methods: {
    onClear() {
      this.separator = ''
    }
  }
}
</script>

<style lang="scss" scoped>
  .label-layout-size {
    display: inline-block;
    min-width: 110px;
  }
</style>

