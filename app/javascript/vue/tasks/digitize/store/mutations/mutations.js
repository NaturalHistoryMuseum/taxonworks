import setCollectionObject from './CollectionObject/setCollectionObject'
import setCollectionObjectBufferedCollectionEvent from './CollectionObject/setCollectionObjectBufferedCollectionEvent'
import setCollectionObjectBufferedDeterminations from './CollectionObject/setCollectionObjectBufferedDeterminations'
import setCollectionObjectBufferedOtherLabel from './CollectionObject/setCollectionObjectBufferedOtherLabel'
import setCollectionObjectCollectionEventAttributes from './CollectionObject/setCollectionObjectCollectionEventAttributes'
import setCollectionObjectConteiner from './CollectionObject/setCollectionObjectConteiner'
import setCollectionObjectDeaccessionedAt from './CollectionObject/setCollectionObjectDeaccessionedAt'
import setCollectionObjectDeaccessionReason from './CollectionObject/setCollectionObjectDeaccessionReason'
import setCollectionObjectEventId from './CollectionObject/setCollectionObjectEventId'
import setCollectionObjectPreparationId from './CollectionObject/setCollectionObjectPreparationId'
import setCollectionObjectRangeLotId from './CollectionObject/setCollectionObjectRangeLotId'
import setCollectionObjectRepositoryId from './CollectionObject/setCollectionObjectRepositoryId'
import setCollectionObjectTotal from './CollectionObject/setCollectionObjectTotal'

import setCollectionEventLabel from './setCollectionEventLabel'
import setCollectionEventCollectors from './setCollectionEventCollectors'
import setCollectionEventDate from './setCollectionEventDate'
import setCollectionEventDatum from './setCollectionEventDatum'
import setCollectionEventElevation from './setCollectionEventElevation'
import setCollectionEventGeolocation from './setCollectionEventGeolocation'
import setCollectionEventHabitat from './setCollectionEventHabitat'
import setCollectionEventLatitude from './setCollectionEventLatitude'
import setCollectionEventLocality from './setCollectionEventLocality'
import setCollectionEventLongitude from './setCollectionEventLongitude'
import setCollectionEventMethod from './setCollectionEventMethod'
import setCollectionEventTripIdentifier from './setCollectionEventTripIdentifier'
import setCollectionEventElevationPrecision from './setCollectionEventElevationPrecision'
import setCollectionEventMaximumElevation from './setCollectionEventMaximumElevation'
import setCollectionEventMinimumElevation from './setCollectionEventMinimumElevation'

const MutationNames = {
  SetCollectionEventLabel: 'setCollectionEventLabel',
  SetCollectionEventCollectors: 'setCollectionEventCollectors',
  SetCollectionEventDate: 'setCollectionEventDate',
  SetCollectionEventDatum: 'setCollectionEventDatum',
  SetCollectionEventElevation: 'setCollectionEventElevation',
  SetCollectionEventGeolocation: 'setCollectionEventGeolocation',
  SetCollectionEventHabitat: 'setCollectionEventHabitat',
  SetCollectionEventLatitude: 'setCollectionEventLatitude',
  SetCollectionEventLocality: 'setCollectionEventLocality',
  SetCollectionEventLongitude: 'setCollectionEventLongitude',
  SetCollectionEventMethod: 'setCollectionEventMethod',
  SetCollectionEventTripIdentifier: 'setCollectionEventTripIdentifier',
  SetCollectionEventElevationPrecision: 'setCollectionEventElevationPrecision',
  SetCollectionEventMaximumElevation: 'setCollectionEventMaximumElevation',
  SetCollectionEventMinimumElevation: 'setCollectionEventMinimumElevation',

  SetCollectionObject: 'setCollectionObject',
  SetCollectionObjectBufferedCollectionEvent: 'setCollectionObjectBufferedCollectionEvent',
  SetCollectionObjectBufferedDeterminations: 'setCollectionObjectBufferedDeterminations',
  SetCollectionObjectBufferedOtherLabel: 'setCollectionObjectBufferedOtherLabel',
  SetCollectionObjectCollectionEventAttributes: 'setCollectionObjectCollectionEventAttributes',
  SetCollectionObjectConteiner: 'setCollectionObjectConteiner',
  SetCollectionObjectDeaccessionedAt: 'setCollectionObjectDeaccessionedAt',
  SetCollectionObjectDeaccessionReason: 'setCollectionObjectDeaccessionReason',
  SetCollectionObjectEventId: 'setCollectionObjectEventId',
  SetCollectionObjectPreparationId: 'setCollectionObjectPreparationId',
  SetCollectionObjectRangeLotId: 'setCollectionObjectRangeLotId',
  SetCollectionObjectRepositoryId: 'setCollectionObjectRepositoryId',
  SetCollectionObjectTotal: 'setCollectionObjectTotal'  
}

const MutationFunctions = {
  [MutationNames.SetCollectionObject]: setCollectionObject,
  [MutationNames.SetCollectionObjectBufferedCollectionEvent]: setCollectionObjectBufferedCollectionEvent,
  [MutationNames.SetCollectionEventLabel]: setCollectionEventLabel,
  [MutationNames.SetCollectionEventCollectors]: setCollectionEventCollectors,
  [MutationNames.SetCollectionEventDate]: setCollectionEventDate,
  [MutationNames.SetCollectionEventDatum]: setCollectionEventDatum,
  [MutationNames.SetCollectionEventElevation]: setCollectionEventElevation,
  [MutationNames.SetCollectionEventGeolocation]: setCollectionEventGeolocation,
  [MutationNames.SetCollectionEventHabitat]: setCollectionEventHabitat,
  [MutationNames.SetCollectionEventLatitude]: setCollectionEventLatitude,
  [MutationNames.SetCollectionEventLocality]: setCollectionEventLocality,
  [MutationNames.SetCollectionEventLongitude]: setCollectionEventLongitude,
  [MutationNames.SetCollectionEventMethod]: setCollectionEventMethod,
  [MutationNames.SetCollectionEventTripIdentifier]: setCollectionEventTripIdentifier,
  [MutationNames.SetCollectionEventElevationPrecision]: setCollectionEventElevationPrecision,
  [MutationNames.SetCollectionEventMaximumElevation]: setCollectionEventMaximumElevation,
  [MutationNames.SetCollectionEventMinimumElevation]: setCollectionEventMinimumElevation,
  [MutationNames.SetCollectionObjectBufferedDeterminations]: setCollectionObjectBufferedDeterminations,
  [MutationNames.SetCollectionObjectBufferedOtherLabel]: setCollectionObjectBufferedOtherLabel,
  [MutationNames.SetCollectionObjectCollectionEventAttributes]: setCollectionObjectCollectionEventAttributes,
  [MutationNames.SetCollectionObjectConteiner]: setCollectionObjectConteiner,
  [MutationNames.SetCollectionObjectDeaccessionedAt]: setCollectionObjectDeaccessionedAt,
  [MutationNames.SetCollectionObjectDeaccessionReason]: setCollectionObjectDeaccessionReason,
  [MutationNames.SetCollectionObjectEventId]: setCollectionObjectEventId,
  [MutationNames.SetCollectionObjectPreparationId]: setCollectionObjectPreparationId,
  [MutationNames.SetCollectionObjectRangeLotId]: setCollectionObjectRangeLotId,
  [MutationNames.SetCollectionObjectRepositoryId]: setCollectionObjectRepositoryId,
  [MutationNames.SetCollectionObjectTotal]: setCollectionObjectTotal
}

export {
  MutationNames,
  MutationFunctions
}
