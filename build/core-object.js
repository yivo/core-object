(function() {
  (function(factory) {
    var root;
    root = typeof self === 'object' && (typeof self !== "undefined" && self !== null ? self.self : void 0) === self ? self : typeof global === 'object' && (typeof global !== "undefined" && global !== null ? global.global : void 0) === global ? global : void 0;
    if (typeof define === 'function' && define.amd) {
      define(['callbacks', 'publisher-subscriber', 'construct-with', 'property-accessors', 'coffee-concerns', 'exports'], function(Callbacks, PublisherSubscriber, ConstructWith, PropertyAccessors) {
        return root.CoreObject = factory(root, Callbacks, PublisherSubscriber, ConstructWith, PropertyAccessors);
      });
    } else if (typeof module === 'object' && module !== null && (module.exports != null) && typeof module.exports === 'object') {
      module.exports = factory(root, require('callbacks'), require('publisher-subscriber'), require('construct-with'), require('property-accessors'), require('coffee-concerns'));
    } else {
      root.CoreObject = factory(root, root.Callbacks, root.PublisherSubscriber, root.ConstructWith, root.PropertyAccessors);
    }
  })(function(__root__, Callbacks, PublisherSubscriber, ConstructWith, PropertyAccessors) {
    var CoreObject;
    return CoreObject = (function() {
      var generateID, ref, ref1;

      CoreObject.include(Callbacks);

      CoreObject.include(PublisherSubscriber);

      CoreObject.include(ConstructWith);

      CoreObject.include(PropertyAccessors);

      generateID = (ref = (ref1 = __root__._) != null ? ref1.generateID : void 0) != null ? ref : (function() {
        var n;
        n = 0;
        return function() {
          return ++n;
        };
      })();

      function CoreObject(parameters) {
        this.oid = generateID();
        this.destroyed = false;
        this.destroying = false;
        this.initialize(parameters);
      }

      CoreObject.prototype.result = function(property) {
        var value;
        value = this[property];
        if (typeof value === 'function') {
          return this[property]();
        } else {
          return value;
        }
      };

      CoreObject.prototype.toString = function() {
        return (this.constructor.name || '<Class name not available>') + ("#" + this.oid);
      };

      CoreObject.prototype.destroy = function(options) {
        if (!this.destroyed) {
          this.destroying = true;
          if (typeof this.destructor === "function") {
            this.destructor(options);
          }
          this.notify('destroy', this);
          this.stopListening();
          this.off();
          this.options = null;
          this.destroyed = true;
          this.destroying = false;
        }
        return this;
      };

      return CoreObject;

    })();
  });

}).call(this);
