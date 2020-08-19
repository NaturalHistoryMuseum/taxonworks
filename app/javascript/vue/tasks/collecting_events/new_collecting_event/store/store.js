import Vue from 'vue'
import Vuex from 'vuex'

import { GetterFunctions } from './getters/getters'
import { MutationFunctions } from './mutations/mutations'
import { ActionFunctions } from './actions/actions'

Vue.use(Vuex)

function makeInitialState () {
  return {
    collectingEvent: {
      id: undefined,
      global_id: undefined,
      print_label: undefined,
      print_label_number_to_print: undefined,
      document_label: undefined,
      verbatim_label: undefined,
      verbatim_locality: undefined,
      verbatim_date: undefined,
      verbatim_longitude: undefined,
      verbatim_latitude: undefined,
      verbatim_geolocation_uncertainty: undefined,
      verbatim_trip_identifier: undefined,
      verbatim_collectors: undefined,
      verbatim_method: undefined,
      verbatim_habitat: undefined,
      verbatim_datum: undefined,
      verbatim_elevation: undefined,
      geographic_area_id: undefined,
      minimum_elevation: undefined,
      maximum_elevation: undefined,
      elevation_precision: undefined,
      time_start_hour: undefined,
      time_start_minute: undefined,
      time_start_second: undefined,
      time_end_hour: undefined,
      time_end_minute: undefined,
      time_end_second: undefined,
      start_date_day: undefined,
      start_date_month: undefined,
      start_date_year: undefined,
      end_date_day: undefined,
      end_date_month: undefined,
      end_date_year: undefined,
      group: undefined,
      member: undefined,
      formation: undefined,
      lithology: undefined,
      max_ma: undefined,
      min_ma: undefined,
      field_notes: undefined,
      roles_attributes: [],
      identifiers_attributes: [],
      georeferences: [],
      queueGeoreferences: []
    },
    tripCode: {
      id: undefined,
      namespace_id: undefined,
      type: 'Identifier::Local::TripCode',
      identifier: undefined
    }
  }
}

function newStore () {
  return new Vuex.Store({
    state: makeInitialState(),
    getters: GetterFunctions,
    mutations: MutationFunctions,
    actions: ActionFunctions
  })
}

export {
  newStore,
  makeInitialState
}
