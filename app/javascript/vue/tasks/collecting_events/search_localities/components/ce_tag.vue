<template>
  <div class="find-ce">
    <spinner
      v-if="isLoading"
      :full-screen="true"
      legend="Loading..."
      :logo-size="{ width: '100px', height: '100px'}"/>
    <h3>Find collecting events by tag/keyword</h3>
    <div>
      <table>
        <tr
          v-for="(item, index) in tagList"
          :key="item.id">
          <td>
            <a
              v-html="item.label_html"
              @click="showObject()"
            />
          </td>
          <td>
            <span
              class="remove_area"
              data-icon="trash"
              @click="delistMe(index)"
            />
          </td>
        </tr>
      </table>
    </div>
    <autocomplete
      class="separate-bottom"
      url="/controlled_vocabulary_terms/autocomplete"
      min="2"
      ref="autocomplete"
      :add-params="{'type[]' : 'Keyword'}"
      param="term"
      placeholder="Select a tag"
      label="label"
      @getItem="addTag($event)"
      :autofocus="true"
      :clear-after="true"/>
    <input
      type="button"
      class="button normal-input button-default separate-left"
      @click="getTagData()"
      :disabled="!tagList.length"
      value="Find"
    >
  </div>
</template>
<script>
  import Autocomplete from 'components/autocomplete'
  import Spinner from 'components/spinner'
  import AjaxCall from 'helpers/ajaxCall'

  export default {
    components: {
      Autocomplete,
      Spinner,
    },
    data() {
      return {
        tagList: [],
        collectingEventList: [],
        isLoading:  false,
      }
    },

    methods: {
      getTagData(){
        let tag_ids = [];
        this.tagList.forEach(tag => {
          tag_ids.push(tag.id)
        });
        let params = {
          keyword_ids: tag_ids
        };
        this.isLoading = true;
        AjaxCall('get', '/collecting_events.json', { params: params }).then(response => {
          this.collectingEventList = response.body;
          this.$emit('jsonUrl', response.request.responseURL)
          if(this.collectingEventList) {
            this.$emit('collectingEventList', this.collectingEventList);
          }
          this.isLoading = false;
        });
      },
      addTag(item) {
        this.tagList.push(item);
      },
      delistMe(index) {
        this.$delete(this.tagList, index)
      },
    }
  }
</script>
