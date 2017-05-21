'use strict';

angular.module('APIM.version', [
  'APIM.version.interpolate-filter',
  'APIM.version.version-directive'
])

.value('version', 'v1.0');
