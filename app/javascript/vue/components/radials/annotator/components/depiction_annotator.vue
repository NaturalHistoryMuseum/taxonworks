<template>
  <div class="depiction_annotator">
    <div class="field" v-if="depiction">
      <div class="separate-bottom">
        <img
          :src="depiction.image.alternatives.medium.image_file_url"
          :style="{
            width: `${depiction.image.alternatives.medium.width}px`,
            height: `${depiction.image.alternatives.medium.height}px`
          }"
        >
      </div>
      <div class="field">
        <input class="normal-input" type="text" v-model="depiction.figure_label" placeholder="Label">
      </div>
      <textarea class="normal-input separate-bottom" type="text" v-model="depiction.caption" placeholder="Caption"/>
      <label>
        <input
          type="checkbox"
          v-model="depiction.is_metadata_depiction">
          Is data depiction
      </label>
      <div class="separate-top separate-bottom">
        <p>
          <h4>Move to</h4>
        </p>
        <ul class="no_bullets">
          <li
            v-for="type in objectTypes"
            :key="type.value">
            <label>
              <input
                type="radio"
                name="depiction-type"
                v-model="selectedType"
                :value="type">
              {{ type.label }}
            </label>
          </li>
        </ul>
        <div
          v-if="selectedType && !selectedObject"
          class="separate-top">
          <autocomplete
            v-if="selectedType.value != 'Otu'"
            :disabled="!selectedType"
            :url="selectedType.url"
            label="label_html"
            :placeholder="`Select a ${selectedType.label.toLowerCase()}`"
            :clear-after="true"
            @getItem="selectedObject = $event"
            param="term"/>
          <otu-picker
            v-else
            :clear-after="true"
            @getItem="selectedObject = $event"/>
        </div>
        <div
          v-if="selectedObject"
          class="horizontal-left-content">
          <span v-html="selectedObject.label_html"/>
          <span
            class="circle-button button-default btn-undo"
            @click="selectedObject = undefined"/>
        </div>
      </div>

      <div>
        <button type="button" class="normal-input button button-submit" @click="updateFigure()">Update</button>
        <button type="button" class="normal-input button button-default" @click="depiction = undefined">Back</button>
      </div>
    </div>
    <div v-else>
      <dropzone class="dropzone-card separate-bottom" @vdropzone-sending="sending" @vdropzone-success="success" ref="figure" id="figure" url="/depictions" :use-custom-dropzone-options="true" :dropzone-options="dropzone"/>
      <label>
        <input
          type="checkbox"
          v-model="isDataDepiction">
        Is data depiction
      </label>
      <table-list
        :attributes="['object_tag','is_metadata_depiction']"
        :header="['Image', 'Is data', '']"
        :list="list"
        :edit="true"
        :destroy="true"
        @edit="depiction = $event"
        @delete="removeItem"
        class="list"/>
    </div>
  </div>
</template>
<script>

import CRUD from '../request/crud.js'
import TableList from 'components/table_list'
import dropzone from 'components/dropzone.vue'
import annotatorExtend from '../components/annotatorExtend.js'
import Autocomplete from 'components/autocomplete'
import OtuPicker from 'components/otu/otu_picker/otu_picker'

export default {
  mixins: [CRUD, annotatorExtend],
  components: {
    dropzone,
    TableList,
    Autocomplete,
    OtuPicker
  },
  computed: {
    updateObjectType() {
      return (this.selectedObject && this.selectedType)
    }
  },
  data: function () {
    return {
      depiction: undefined,
      dropzone: {
        paramName: 'depiction[image_attributes][image_file]',
        url: '/depictions',
        headers: {
          'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').getAttribute('content')
        },
        dictDefaultMessage: 'Drop images here to add figures',
        acceptedFiles: 'image/*'
      },
      objectTypes: [
        {
          value: 'Otu',
          label: 'Otu',
          url: '/otus/autocomplete'
        },
        {
          value: 'CollectingEvent',
          label: 'Collecting event',
          url: '/collecting_events/autocomplete'
        },
        {
          value: 'CollectionObject',
          label: 'Collection object',
          url: '/collection_objects/autocomplete'
        },
        {
          value: 'TaxonName',
          label: 'Taxon name',
          url: '/taxon_names/autocomplete'
        }
      ],
      isDataDepiction: false,
      selectedType: undefined,
      selectedObject: undefined
    }
  },
  methods: {
    'success': function (file, response) {
      this.list.push(response)
      this.$refs.figure.removeFile(file)
    },
    'sending': function (file, xhr, formData) {
      formData.append('depiction[annotated_global_entity]', decodeURIComponent(this.globalId))
      formData.append('depiction[is_metadata_depiction]', this.isDataDepiction)
    },
    updateFigure () {
      if(this.updateObjectType) {
        this.depiction.depiction_object_type = this.selectedType.value
        this.depiction.depiction_object_id = this.selectedObject.id
      }
      this.update(`/depictions/${this.depiction.id}`, { depiction: this.depiction }).then(response => {
        if(this.updateObjectType) {
          this.$delete(this.list, this.list.findIndex(element => this.depiction.id == element.id), response.body)
        }
        else {
          this.$set(this.list, this.list.findIndex(element => this.depiction.id == element.id), response.body)
        }
        this.depiction = undefined
      })
    }
  }
}
</script>

<style lang="scss">
.radial-annotator {
	.depiction_annotator {
		button {
			min-width: 100px;
		}
		textarea {
			padding-top: 14px;
			padding-bottom: 14px;
			width: 100%;
			height: 100px;
		}
    /deep/ .vue-autocomplete-input {
      width: 400px;
    }
	}
}
</style>