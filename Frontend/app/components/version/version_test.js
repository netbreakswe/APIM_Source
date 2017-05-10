'use strict';

describe('APIM.version module', function() {
  beforeEach(module('APIM.version'));

  describe('version service', function() {
    it('should return current version', inject(function(version) {
      expect(version).toEqual('0.1');
    }));
  });
});
