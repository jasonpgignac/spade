// ========================================================================
// SC.keys Tests
// ========================================================================
/*globals module test */

require('core-test/qunit');
require('sproutcore-runtime/core');

module("Fetch Keys ");

test("should get a key array for a specified object ",function(){
	var object1 = {};

	object1.names = "Rahul";
	object1.age = "23";
	object1.place = "Mangalore";

	var object2 = [];
	object2 = SC.keys(object1);
	same(object2,['names','age','place']);
});


