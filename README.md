[![build status](https://secure.travis-ci.org/rofrankel/graff.png)](http://travis-ci.org/rofrankel/graff)
Graff is a Node.JS graph theory library. At some point, persistence backends may
be added, but for the time being it just runs in memory.

Not much is supported right now. You can add vertices, connect them, disconnect
them, and find the shortest path between two nodes (if it exists). Dijkstra's
algorithm is used unless Graph.uniform is true (false by default), in which case
a more efficient breadth-first search implementation is used. Edges created with
Graph.connect while Graph.directed is set to false (true by default) will be
created in both directions; edges destroyed with Graph.disconnect while
Graph.directed is false will be destroyed in both directions.

See src/test.coffee for brief examples. This file isn't a real test suite, just
a useful file that sped up some testing during development.

**Installation**: `npm install graff`

**Development**: Fork this, add or edit .coffee files in ./src, run `cake
build`.