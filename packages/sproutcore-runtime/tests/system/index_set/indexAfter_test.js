// ==========================================================================
// Project:   SproutCore Costello - Property Observing Library
// Copyright: ©2006-2010 Sprout Systems, Inc. and contributors.
//            Portions ©2008-2010 Apple Inc. All rights reserved.
// License:   Licensed under MIT license (see license.js)
// ==========================================================================

require('core-test/qunit');
require('sproutcore-runtime/system/index_set');


var set ;

module("SC.IndexSet.indexAfter", {
  setup: function() {
    set = SC.IndexSet.create(5).add(10,5).add(100);
  }
});

test("no earlier index in set", function(){ 
  equals(set.indexAfter(3), 5, 'set.indexAfter(3) in %@ should start of first index range'.fmt(set));
});

test("with index after end of set", function() {
  equals(set.indexAfter(1000), -1, 'set.indexAfter(1000) in %@ should return -1'.fmt(set));
});

test("inside of multi-index range", function() {
  equals(set.indexAfter(12), 13, 'set.indexAfter(12) in %@ should return next index'.fmt(set));
});

test("end of multi-index range", function() {
  equals(set.indexAfter(14), 100, 'set.indexAfter(14) in %@ should start of next range'.fmt(set));
});


test("single index range", function() {
  equals(set.indexAfter(5), 10, 'set.indexAfter(5) in %@ should start of next range multi-index range'.fmt(set));
});


