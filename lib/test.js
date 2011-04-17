(function() {
  var get_path, get_test_graph, graff, _;
  _ = require('underscore');
  graff = require('./graff');
  get_test_graph = function() {
    var g, v, _i, _len, _ref;
    g = new graff.Graph();
    _ref = ['A', 'B', 'C', 'D', 'E', 'F', 'G', 'H'];
    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
      v = _ref[_i];
      g.add_vertex(v);
    }
    g.connect('A', 'B', 2);
    g.connect('A', 'C', 1);
    g.connect('C', 'D', 4);
    g.connect('B', 'E', 10);
    g.connect('D', 'F', 1);
    g.connect('F', 'E', 3);
    g.connect('G', 'H', 2);
    return g;
  };
  get_path = function(start, end, uniform) {
    var g, p, print_path, v;
    if (uniform == null) {
      uniform = false;
    }
    g = get_test_graph();
    v = g.vertices;
    g.uniform = uniform;
    print_path = function(p) {
      var v;
      if (p) {
        return console.log('dist=' + p[1] + ', path=' + ((function() {
          var _i, _len, _ref, _results;
          _ref = p[0];
          _results = [];
          for (_i = 0, _len = _ref.length; _i < _len; _i++) {
            v = _ref[_i];
            _results.push(v.label);
          }
          return _results;
        })()).join(', '));
      }
    };
    p = g.get_path(v[start], v[end], true);
    print_path(p);
    return p;
  };
  _.extend(exports, {
    get_test_graph: get_test_graph,
    get_path: get_path
  });
}).call(this);
