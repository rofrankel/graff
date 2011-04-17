(function() {
  var get_path, get_test_graph, graff, print_path, wikipedia_edges, _;
  _ = require('underscore');
  graff = require('./graff');
  wikipedia_edges = [['A', 'C', 14], ['A', 'D', 9], ['A', 'E', 7], ['C', 'D', 2], ['D', 'E', 10], ['D', 'F', 11], ['E', 'F', 15], ['C', 'B', 9], ['F', 'B', 6]];
  print_path = function(p) {
    if (p) {
      return console.log('dist=' + p[1] + ', path=' + p[0].join(', '));
    }
  };
  get_test_graph = function(opts) {
    var _ref;
    if (opts == null) {
      opts = {};
    }
    (_ref = opts.edges) != null ? _ref : opts.edges = wikipedia_edges;
    return new graff.Graph(opts);
  };
  get_path = function(start, end, opts) {
    var g, p;
    g = get_test_graph(opts);
    p = g.get_path(start, end, true);
    print_path(p);
    return p;
  };
  _.extend(exports, {
    get_test_graph: get_test_graph,
    get_path: get_path
  });
}).call(this);
