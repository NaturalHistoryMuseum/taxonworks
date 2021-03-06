<template>
  <div class="nomen-source">
    <h2>Cite taxon name</h2>
    <smart-selector
      :options="tabs"
      name="citation"
      :add-option="moreOptions"
      v-model="view"/>
    <template v-if="sourceID">
      <div
        v-if="view === 'Search'"
        class="horizontal-left-content">
        <autocomplete
            class="separate-bottom"
            url="/taxon_names/autocomplete"
            min="2"
            ref="autocomplete"
            param="term"
            placeholder="Search for a taxon"
            label="label_html"
            @getItem="createTaxonCite($event)"
            :autofocus="true" />
        <span
          class="warning separate-left"
          v-if="sourceAlreadyTaken">The source has already been taken</span>
      </div>
      <template v-else>
        <button
          v-for="item in showList[view]"
          v-if="!isCreated(item)"
          :key="item.id"
          type="button"
          class="button normal-input button-submit biocuration-toggle-button"
          @click="createTaxonCite(item)"
          v-html="item.name"/>
      </template>
    </template>
  </div>
</template>
<script>

  import SmartSelector from 'components/switch.vue'
  import Autocomplete from 'components/autocomplete.vue'
  import AjaxCall from 'helpers/ajaxCall'

  export default {
    components: {
      SmartSelector,
      Autocomplete
    },
    props: {
      sourceID: {
        type: String,
        default: undefined
      },
      citeTaxonList: {
        type: Array,
        required: true
      }
    },
    data() {
      return {
        list: {},
        tabs: [],
        moreOptions: ['Search'],
        view: undefined,
        selectedList: {},
        newCitation: {},
        sourceAlreadyTaken: false
      }
    },
    methods: {
      createTaxonCite(taxon) {
        let params = {
          citation: {
            source_id: this.sourceID,
            citation_object_type: 'TaxonName',
            citation_object_id: taxon.id
          }
        };
        this.sourceAlreadyTaken = false
        AjaxCall('post', `/citations.json`, params).then(response => {
          this.$emit('foundTaxon', response.body);
          this.$refs.autocomplete.cleanInput()
        })
        .catch(error => {
          this.sourceAlreadyTaken = true
        })
      },
      isCreated(taxon) {
        return this.citeTaxonList.find((item) => {
          return item.citation_object.global_id == taxon.global_id
        })
      }
    },
    computed: {
      showList() {
        return this.list
      }
    },
    mounted: function() {
      AjaxCall('get', '/taxon_names/select_options').then(response => {
        this.tabs = Object.keys(response.body);
        this.list = response.body;
        if(this.tabs.length) {
          this.view = this.tabs[0]
        }
      })
    }
  }

</script>
