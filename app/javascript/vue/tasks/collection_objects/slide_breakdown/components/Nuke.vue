<template>
  <div>
    <button
      type="button"
      :disabled="disabled"
      class="button normal-input button-delete "
      @click="showModal = true">Nuke
    </button>
    <modal-component
      v-show="showModal"
      @close="showModal = false">
      <h3 slot="header">Destroy collection objects</h3>
      <div slot="body">
        <p>This will destroy all collection objects created. Are you sure you want to proceed? Type "{{ checkWord }}" to proceed.</p>
        <input
          type="text"
          class="full_width"
          v-model="inputValue"
          @keypress.enter.prevent="emitConfirm()"
          ref="inputtext"
          :placeholder="`Write ${checkWord} to continue`">
      </div>
      <div slot="footer">
        <button 
          type="button"
          class="button normal-input button-delete"
          :disabled="checkInput"
          @click="emitConfirm()">
          NUKE
        </button>
      </div>
    </modal-component>
  </div>
</template>

<script>

import ModalComponent from 'components/modal.vue'

export default {
  components: {
    ModalComponent
  },
  props: {
    disabled: {
      type: Boolean,
      default: false
    }
  },
  computed: {
    checkInput () {
      return this.inputValue.toUpperCase() !== this.checkWord
    },
    getMacKey () {
      return (navigator.platform.indexOf('Mac') > -1 ? 'ctrl' : 'alt')
    }
  },
  data () {
    return {
      inputValue: '',
      checkWord: 'NUKE',
      showModal: false
    }
  },
  watch: {
    showModal: {
      handler (newVal) {
        if(newVal) {
          this.$nextTick(() => {
            this.$refs.inputtext.focus()
          })
        }  
      }
    }
  },
  mounted() {
    this.$refs.inputtext.focus()
  },
  methods: {
    emitConfirm () {
      this.$emit('confirm', true)
      this.showModal = false
    }
  }
}
</script>
