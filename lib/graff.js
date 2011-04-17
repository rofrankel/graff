(function() {
  var Edge, Graph, Vertex, heap, _;
  var __indexOf = Array.prototype.indexOf || function(item) {
    for (var i = 0, l = this.length; i < l; i++) {
      if (this[i] === item) return i;
    }
    return -1;
  };
  _ = require('underscore');
  heap = require('../vendor/heap.js');
  Vertex = (function() {
    function Vertex(label) {
      var _ref;
      this.label = label;
      (_ref = this.label) != null ? _ref : this.label = _.uniqueId('vertex_');
    }
    return Vertex;
  })();
  Edge = (function() {
    function Edge(v1, v2, weight, label) {
      this.weight = weight != null ? weight : 1;
      this.label = label != null ? label : _.uniqueId('edge_');
      this.vertices = [v1, v2];
    }
    return Edge;
  })();
  Graph = (function() {
    function Graph(opts) {
      var _ref, _ref2;
      if (opts == null) {
        opts = {};
      }
      this.vertices = {};
      this.edges = [];
      this.directed = (_ref = opts.directed) != null ? _ref : true;
      this.uniform = (_ref2 = opts.uniform) != null ? _ref2 : false;
    }
    Graph.prototype.add_vertex = function(label) {
      if (!(label in this.vertices)) {
        return this.vertices[label] = new Vertex(label);
      }
    };
    Graph.prototype.maybe_string_to_vertex = function(v) {
      if (typeof v === 'string' && v in this.vertices) {
        return this.vertices[v];
      } else {
        return v;
      }
    };
    Graph.prototype.connect = function(v1, v2, weight, label) {
      v1 = this.maybe_string_to_vertex(v1);
      v2 = this.maybe_string_to_vertex(v2);
      if (v1.label in this.vertices && v2.label in this.vertices && !(this.get_edge(v1, v2))) {
        return this.edges.push(new Edge(v1, v2, weight, label));
      }
    };
    Graph.prototype.disconnect = function(v1, v2) {
      var edge;
      v1 = this.maybe_string_to_vertex(v1);
      v2 = this.maybe_string_to_vertex(v2);
      if (edge = this.get_edge(v1, v2)) {
        return this.edges = _.without(this.edges, [edge]);
      }
    };
    Graph.prototype.get_edge = function(v1, v2) {
      var edges;
      v1 = this.maybe_string_to_vertex(v1);
      v2 = this.maybe_string_to_vertex(v2);
      edges = _.select(this.edges, function(e) {
        return __indexOf.call(e.vertices, v1) >= 0 && __indexOf.call(e.vertices, v2) >= 0;
      });
      if (this.directed) {
        edges = _.select(edges, function(e) {
          return _.indexOf(e.vertices, v1) < _.indexOf(e.vertices, v2);
        });
      }
      if (v1 === v2) {
        edges = _.select(edges, function(e) {
          return _.select(e.vertices, function(v) {
            return v === v1;
          }).length > 1;
        });
      }
      if (edges.length) {
        return edges[0];
      } else {
        return null;
      }
    };
    Graph.prototype.get_children = function(v, with_edge_weight) {
      var child, children, edge;
      if (with_edge_weight == null) {
        with_edge_weight = false;
      }
      v = this.maybe_string_to_vertex(v);
      children = (function() {
        var _i, _len, _ref, _results;
        _ref = _.select(this.edges, function(e) {
          return e.vertices[0] === v;
        });
        _results = [];
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          edge = _ref[_i];
          _results.push([edge.vertices[1], edge.weight]);
        }
        return _results;
      }).call(this);
      if (!this.directed) {
        children = _.uniq(children.concat((function() {
          var _i, _len, _ref, _results;
          _ref = _.select(this.edges, function(e) {
            return e.vertices[1] === v;
          });
          _results = [];
          for (_i = 0, _len = _ref.length; _i < _len; _i++) {
            edge = _ref[_i];
            _results.push([edge.vertices[0], edge.weight]);
          }
          return _results;
        }).call(this)));
      }
      if (!with_edge_weight) {
        children = (function() {
          var _i, _len, _results;
          _results = [];
          for (_i = 0, _len = children.length; _i < _len; _i++) {
            child = children[_i];
            _results.push(child[0]);
          }
          return _results;
        })();
      }
      return children;
    };
    Graph.prototype.get_path = function(start, goal, with_dist) {
      var child, child_dist, cur_dist, cur_path, cur_v, h, new_dist, new_path, q, seen, visited, x, _i, _j, _k, _len, _len2, _len3, _ref, _ref2, _ref3, _ref4, _ref5, _ref6, _ref7;
      if (with_dist == null) {
        with_dist = false;
      }
      start = this.maybe_string_to_vertex(start);
      goal = this.maybe_string_to_vertex(goal);
      if (this.get_edge(start, goal)) {
        return [start, goal];
      }
      if (this.uniform) {
        seen = {};
        q = (function() {
          var _i, _len, _ref, _results;
          _ref = this.get_children(start);
          _results = [];
          for (_i = 0, _len = _ref.length; _i < _len; _i++) {
            child = _ref[_i];
            _results.push([child, [start]]);
          }
          return _results;
        }).call(this);
        x = 0;
        while (q.length) {
          _ref = _.head(q), cur_v = _ref[0], cur_path = _ref[1];
          q = _.tail(q);
          new_path = cur_path.slice();
          new_path.push(cur_v);
          if (cur_v === goal) {
            if (with_dist) {
              return [new_path, new_path.length];
            } else {
              return new_path;
            }
          }
          _ref2 = this.get_children(cur_v);
          for (_i = 0, _len = _ref2.length; _i < _len; _i++) {
            child = _ref2[_i];
            if (!(child.label in seen)) {
              q.push([child, new_path]);
              seen[child.label] = 1;
            }
          }
        }
        return null;
      } else {
        seen = {};
        visited = {};
        visited[start.label] = 1;
        h = new heap.BinaryHeap(function(e) {
          return e[1];
        });
        _ref3 = this.get_children(start, true);
        for (_j = 0, _len2 = _ref3.length; _j < _len2; _j++) {
          _ref4 = _ref3[_j], child = _ref4[0], child_dist = _ref4[1];
          h.push([child, child_dist, [start]]);
        }
        while (h.size()) {
          _ref5 = h.pop(), cur_v = _ref5[0], cur_dist = _ref5[1], cur_path = _ref5[2];
          visited[cur_v.label] = 1;
          new_path = cur_path.slice();
          new_path.push(cur_v);
          if (cur_v === goal) {
            if (with_dist) {
              return [new_path, cur_dist];
            } else {
              return new_path;
            }
          }
          _ref6 = this.get_children(cur_v, true);
          for (_k = 0, _len3 = _ref6.length; _k < _len3; _k++) {
            _ref7 = _ref6[_k], child = _ref7[0], child_dist = _ref7[1];
            if (!(child.label in visited)) {
              new_dist = cur_dist + child_dist;
              if (child in seen) {
                if (new_dist < seen[child][1]) {
                  seen[child][1] = new_dist;
                  h.bubbleUp(seen[child]);
                }
              } else {
                h.push([child, new_dist, new_path]);
              }
            }
          }
        }
        return null;
      }
    };
    return Graph;
  })();
  _.extend(exports, {
    Graph: Graph
  });
}).call(this);
