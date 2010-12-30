// ========================================================================
// SC.typeOf Tests
// ========================================================================

require('core-test/qunit');
require('sproutcore-runtime/core');
require('sproutcore-runtime/system/object');
require('sproutcore-runtime/system/error');

module("SproutCore Type Checking");

test("SC.typeOf", function() {
	var a = null,
	    arr = [1,2,3],
	    obj = {},
      object = SC.Object.create({ method: function() {} });

  equals(SC.T_UNDEFINED,  SC.typeOf(undefined),         "item of type undefined");
  equals(SC.T_NULL,       SC.typeOf(a),                 "item of type null");
	equals(SC.T_ARRAY,      SC.typeOf(arr),               "item of type array");
	equals(SC.T_HASH,       SC.typeOf(obj),               "item of type hash");
	equals(SC.T_OBJECT,     SC.typeOf(object),            "item of type object");
	equals(SC.T_FUNCTION,   SC.typeOf(object.method),     "item of type function") ;
	equals(SC.T_CLASS,      SC.typeOf(SC.Object),         "item of type class");
  equals(SC.T_ERROR,      SC.typeOf(SC.Error.create()), "item of type error");
});

test("SC.none", function() {
  var string = "string", fn = function() {};

	equals(true,  SC.none(null),      "for null");
	equals(true,  SC.none(undefined), "for undefined");
  equals(false, SC.none(""),        "for an empty String");
  equals(false, SC.none(true),      "for true");
  equals(false, SC.none(false),     "for false");
  equals(false, SC.none(string),    "for a String");
  equals(false, SC.none(fn),        "for a Function");
  equals(false, SC.none(0),         "for 0");
  equals(false, SC.none([]),        "for an empty Array");
  equals(false, SC.none({}),        "for an empty Object");
});

test("SC.empty", function() {
  var string = "string", fn = function() {};

	equals(true,  SC.empty(null),      "for null");
	equals(true,  SC.empty(undefined), "for undefined");
  equals(true,  SC.empty(""),        "for an empty String");
  equals(false, SC.empty(true),      "for true");
  equals(false, SC.empty(false),     "for false");
  equals(false, SC.empty(string),    "for a String");
  equals(false, SC.empty(fn),        "for a Function");
  equals(false, SC.empty(0),         "for 0");
  equals(false, SC.empty([]),        "for an empty Array");
  equals(false, SC.empty({}),        "for an empty Object");
});

test("SC.isArray" ,function(){
	var numarray      = [1,2,3],
	    number        = 23,
	    strarray      = ["Hello", "Hi"],
    	string        = "Hello",
	    object   	    = {},
      length        = {length: 12},
      fn            = function() {},
      nodelist;

	equals( SC.isArray(numarray), true,  "[1,2,3]" );
	equals( SC.isArray(number),   false, "23" );
	equals( SC.isArray(strarray), true,  '["Hello", "Hi"]' );
	equals( SC.isArray(string),   false, '"Hello"' );
	equals( SC.isArray(object),   false, "{}" );
  equals( SC.isArray(length),   true,  "{length: 12}" );
  equals( SC.isArray(fn),       false, "function() {}" );
  
  // only test if we are in the browser
  equals( SC.isArray(window),   false, "window" );
  
  if ('undefined' !== typeof document) {
    nodelist = document.getElementsByTagName("body");
    equals( SC.isArray(nodelist), true, "NodeList" );
  }
  
});
