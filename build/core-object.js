
/*!
 * core-object 1.1.0 | https://github.com/yivo/core-object | MIT License
 */

(function() {
  (function(factory) {
    var __root__;
    __root__ = typeof self === 'object' && self !== null && self.self === self ? self : typeof global === 'object' && global !== null && global.global === global ? global : Function('return this')();
    if (typeof define === 'function' && typeof define.amd === 'object' && define.amd !== null) {
      define(['initializable', 'finalizable', 'publisher-subscriber', 'pub-sub-callback-api', 'property-accessors-node', 'coffee-concerns'], function(Initializable, Finalizable, PublisherSubscriber, Callbacks, PropertyAccessors) {
        return __root__.CoreObject = factory(__root__, Initializable, Finalizable, PublisherSubscriber, Callbacks, PropertyAccessors);
      });
    } else if (typeof module === 'object' && module !== null && typeof module.exports === 'object' && module.exports !== null) {
      module.exports = factory(__root__, require('initializable'), require('finalizable'), require('publisher-subscriber'), require('pub-sub-callback-api'), require('property-accessors-node'), require('coffee-concerns'));
    } else {
      __root__.CoreObject = factory(__root__, Initializable, Finalizable, PublisherSubscriber, Callbacks, PropertyAccessors);
    }
  })(function(__root__, Initializable, Finalizable, PublisherSubscriber, Callbacks, PropertyAccessors) {
    var CoreObject;
    return CoreObject = (function() {
      var generateID, ref, ref1;

      CoreObject.include(Initializable);

      CoreObject.include(Finalizable);

      CoreObject.include(PropertyAccessors);

      CoreObject.include(PublisherSubscriber);

      CoreObject.include(Callbacks);

      generateID = (ref = (ref1 = __root__._) != null ? ref1.generateID : void 0) != null ? ref : (function() {
        var n;
        n = 0;
        return function() {
          return ++n;
        };
      })();

      function CoreObject() {
        this.oid = generateID();
        this.initialize.apply(this, arguments);
      }

      CoreObject.prototype.result = function(property) {
        var value;
        value = this[property];
        if (typeof value === 'function') {
          return value.apply(this, arguments);
        } else {
          return value;
        }
      };

      CoreObject.finalizer(function() {
        this.notify('finalize', this);
        this.stopListening();
        this.off();
        return this;
      });

      return CoreObject;

    })();
  });

}).call(this);
