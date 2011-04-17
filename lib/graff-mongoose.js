(function() {
  var Edge, EdgeSchema, GraphSchema, ObjectId, Schema, Vertex, VertexSchema, connect, mongoose, _;
  mongoose = require('mongoose');
  _ = require('underscore');
  Schema = mongoose.Schema;
  ObjectId = Schema.ObjectId;
  VertexSchema = new Schema({
    label: String,
    graph: ObjectId
  });
  mongoose.model('Vertex', VertexSchema);
  Vertex = mongoose.model('Vertex');
  EdgeSchema = new Schema({
    vertices: Array,
    label: String
  });
  mongoose.model('Edge', EdgeSchema);
  Edge = mongoose.model('Edge');
  GraphSchema = new Schema({
    name: String
  });
  GraphSchema.methods.vertices = function(callback, filters) {
    if (filters == null) {
      filters = {};
    }
    return Vertex.find(_.extend({
      graph: this._id
    }, filters), callback);
  };
  GraphSchema.methods.edges = function(callback, filters) {
    if (filters == null) {
      filters = {};
    }
    return Edge.find(_.extend({
      graph: this._id
    }, filters), callback);
  };
  mongoose.model('Graph', Graph);
  connect = function(db, host) {
    if (db == null) {
      db = 'test';
    }
    if (host == null) {
      host = '127.0.0.1';
    }
    return mongoose.connect("http://" + host + "/" + db);
  };
  _.extend(exports, {
    Vertex: Vertex,
    Edge: Edge,
    Graph: Graph,
    connect: connect
  });
}).call(this);
