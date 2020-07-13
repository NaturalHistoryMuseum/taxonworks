import Collectors from '../components/verbatim/Collectors.vue'
import DateComponent from '../components/verbatim/Date.vue'
import Geolocation from '../components/verbatim/Geolocation.vue'
import Habitat from '../components/verbatim/Habitat.vue'
import Label from '../components/verbatim/Label.vue'
import Latitude from '../components/verbatim/Latitude.vue'
import Locality from '../components/verbatim/Locality.vue'
import Longitude from '../components/verbatim/Longitude.vue'
import Method from '../components/verbatim/Method.vue'
import TripIdentifier from '../components/verbatim/TripIdentifier.vue'
import Dates from '../components/parsed/Dates.vue'
import Elevation from '../components/parsed/Elevation.vue'
import GeographicArea from '../components/parsed/GeographicArea.vue'
import Group from '../components/parsed/Group.vue'
import Time from '../components/parsed/Time.vue'
import TripCode from '../components/parsed/TripCode.vue'
import Predicates from '../components/parsed/Predicates.vue'

import MapComponent from '../components/map/Map.vue'
import Depictions from '../components/map/Depictions.vue'

const ComponentVerbatim = {
  Collectors: 'Collectors',
  DateComponent: 'DateComponent',
  Geolocation: 'Geolocation',
  Habitat: 'Habitat',
  Label: 'Label',
  Latitude: 'Latitude',
  Locality: 'Locality',
  Longitude: 'Longitude',
  Method: 'Method',
  TripIdentifier: 'TripIdentifier'
}

const ComponentParse = {
  GeographicArea: 'GeographicArea',
  Dates: 'Dates',
  Elevation: 'Elevation',
  Time: 'Time',
  TripCode: 'TripCode',
  Group: 'Group',
  Predicates: 'Predicates'
}

const ComponentMap = {
  Map: 'Map',
  Depictions: 'Depictions'
}

const VueComponents = {
  [ComponentVerbatim.Collectors]: Collectors,
  [ComponentVerbatim.DateComponent]: DateComponent,
  [ComponentVerbatim.Geolocation]: Geolocation,
  [ComponentVerbatim.Collectors]: Collectors,
  [ComponentVerbatim.Habitat]: Habitat,
  [ComponentVerbatim.Label]: Label,
  [ComponentVerbatim.Latitude]: Latitude,
  [ComponentVerbatim.Locality]: Locality,
  [ComponentVerbatim.Longitude]: Longitude,
  [ComponentVerbatim.Method]: Method,
  [ComponentVerbatim.TripIdentifier]: TripIdentifier,
  [ComponentParse.Dates]: Dates,
  [ComponentParse.Elevation]: Elevation,
  [ComponentParse.GeographicArea]: GeographicArea,
  [ComponentParse.Group]: Group,
  [ComponentParse.Time]: Time,
  [ComponentParse.TripCode]: TripCode,
  [ComponentParse.Predicates]: Predicates,
  [ComponentMap.Map]: MapComponent,
  [ComponentMap.Depictions]: Depictions
}

export {
  ComponentVerbatim,
  ComponentParse,
  ComponentMap,
  VueComponents
}