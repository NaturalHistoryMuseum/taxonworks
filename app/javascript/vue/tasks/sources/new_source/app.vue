<template>
  <div>
    <div class="flex-separate middle">
      <h1>New source</h1>
      <ul class="context-menu">
        <li>
          <label>
            <input
              type="checkbox"
              v-model="settings.sortable">
            Sortable fields
          </label>
        </li>
        <li>
          <a href="/tasks/sources/hub">Back to source hub</a>
        </li>
      </ul>
    </div>
    <nav-bar> 
      <div class="flex-separate full_width">
        <div class="middle">
          <span
            v-if="source.id"
            v-html="source.cached"/>
          <span v-else>New record</span>
          <template v-if="source.id">
            <pin-component
              :object-id="source.id"
              type="Source"/>
            <radial-annotator :global-id="source.global_id"/>
            <radial-object :global-id="source.global_id"/>
            <add-source
              :project_source_id="source.project_source_id"
              :id="source.id"/>
          </template>
        </div>
        <div class="horizontal-right-content">
          <button
            v-shortkey="[getMacKey(), 's']"
            @shortkey="saveSource"
            @click="saveSource"
            :disabled="source.type === 'Source::Bibtex' && !source.bibtex_type"
            class="button normal-input button-submit button-size separate-right separate-left"
            type="button">
            Save
          </button>
          <button
            :disabled="!source.id"
            v-shortkey="[getMacKey(), 'c']"
            @shortkey="cloneSource"
            @click="cloneSource"
            class="button normal-input button-submit button-size"
            type="button">
            Clone
          </button>
          <button
            class="button normal-input button-default button-size separate-left"
            type="button"
            @click="showModal = true">
            CrossRef
          </button>
          <button
            class="button normal-input button-default button-size separate-left"
            type="button"
            @click="showBibtex = true">
            BibTeX
          </button>
          <button
            @click="showRecent = true"
            class="button normal-input button-default button-size separate-left"
            type="button">
            Recent
          </button>
          <button
            v-shortkey="[getMacKey(), 'n']"
            @shortkey="reset"
            @click="reset"
            class="button normal-input button-default button-size separate-left"
            type="button">
            New
          </button>
        </div>
      </div>
    </nav-bar>
    <source-type/>
    <recent-component
      v-if="showRecent"
      @close="showRecent = false"/>
    <div class="horizontal-left-content align-start">
      <component class="full_width" :is="section"/>
      <right-section class="separate-left"/>
    </div>
    <cross-ref
      v-if="showModal"
      @close="showModal = false"/>
    <bibtex-button
      v-if="showBibtex"
      @close="showBibtex = false"/>
  </div>
</template>

<script>

import SourceType from './components/sourceType'
import RecentComponent from './components/recent'

import CrossRef from './components/crossRef'
import BibtexButton from './components/bibtex'
import Verbatim from './components/verbatim/main'
import Bibtex from './components/bibtex/main'
import Human from './components/person/main'
import RadialAnnotator from 'components/annotator/annotator'
import RadialObject from 'components/radial_object/radialObject'
import GetMacKey from 'helpers/getMacKey'
import AddSource from 'components/addToProjectSource'

import PinComponent from 'components/pin'

import { GetUserPreferences } from './request/resources'

import { GetterNames } from './store/getters/getters'
import { ActionNames } from './store/actions/actions'
import { MutationNames } from './store/mutations/mutations'

import RightSection from './components/rightSection'
import NavBar from 'components/navBar'

export default {
  components: {
    RadialAnnotator,
    RadialObject,
    PinComponent,
    SourceType,
    Verbatim,
    Bibtex,
    Human,
    CrossRef,
    RightSection,
    BibtexButton,
    AddSource,
    NavBar,
    RecentComponent
  },
  computed: {
    section () {
      const type = this.$store.getters[GetterNames.GetType]
      return type ? type.split('::')[1] : undefined
    },
    source () {
      return this.$store.getters[GetterNames.GetSource]
    },
    settings: {
      get () {
        return this.$store.getters[GetterNames.GetSettings]
      },
      set (value) {
        this.$store.commit(MutationNames.SetSettings, value)
      }
    }
  },
  data () {
    return {
      showModal: false,
      showBibtex: false,
      showRecent: false
    }
  },
  mounted () {
    TW.workbench.keyboard.createLegend(`${this.getMacKey()}+s`, 'Save', 'New source')
    TW.workbench.keyboard.createLegend(`${this.getMacKey()}+n`, 'New', 'New source')
    TW.workbench.keyboard.createLegend(`${this.getMacKey()}+c`, 'Clone source', 'New source')

    const urlParams = new URLSearchParams(window.location.search)
    const sourceId = urlParams.get('source_id')

    if (/^\d+$/.test(sourceId)) {
      this.$store.dispatch(ActionNames.LoadSource, sourceId)
    }

    GetUserPreferences().then(response => {
      this.$store.commit(MutationNames.SetPreferences, response.body)
    })
  },
  methods: {
    reset () {
      this.$store.dispatch(ActionNames.ResetSource)
    },
    saveSource () {
      if (this.source.type === 'Source::Bibtex' && !this.source.bibtex_type) return
      this.$store.dispatch(ActionNames.SaveSource)
    },
    cloneSource () {
      this.$store.dispatch(ActionNames.CloneSource)
    },
    getMacKey: GetMacKey
  }
}
</script>
<style scoped>
  .button-size {
    width: 100px;
  }
</style>