_ = require 'underscore'
heap = require '../vendor/heap.js'

class Vertex
    constructor: (@label) ->
        @label ?= _.uniqueId('vertex_')


class Edge
    constructor: (v1, v2, @weight=1, @label=_.uniqueId('edge_')) ->
        @vertices = [v1, v2]


class Graph
    constructor: (opts={}) ->
        @vertices = {}
        @edges = []
        @directed = opts.directed ? true
        @uniform = opts.uniform ? false
    
    add_vertex: (label) ->
        if label not of @vertices
            @vertices[label] = new Vertex(label)
    
    maybe_string_to_vertex: (v) ->
        if typeof v is 'string' and v of @vertices
            return @vertices[v]
        else
            return v
    
    connect: (v1, v2, weight, label) ->
        v1 = @maybe_string_to_vertex(v1)
        v2 = @maybe_string_to_vertex(v2)
        
        if v1.label of @vertices and v2.label of @vertices and not (@get_edge(v1, v2))
            @edges.push(new Edge(v1, v2, weight, label))
    
    disconnect: (v1, v2) ->
        v1 = @maybe_string_to_vertex(v1)
        v2 = @maybe_string_to_vertex(v2)
        
        if edge = @get_edge(v1, v2)
            @edges = _.without(@edges, [edge])
    
    get_edge: (v1, v2) ->
        v1 = @maybe_string_to_vertex(v1)
        v2 = @maybe_string_to_vertex(v2)
        edges = _.select(@edges, (e) -> v1 in e.vertices and v2 in e.vertices)
        
        if @directed
            edges = _.select(edges, (e) -> _.indexOf(e.vertices, v1) < _.indexOf(e.vertices, v2))
        
        if v1 is v2
            edges = _.select(edges, (e) -> _.select(e.vertices, (v) -> v is v1).length > 1)
        
        return if edges.length then edges[0] else null
    
    get_children: (v, with_edge_weight=false) ->
        v = @maybe_string_to_vertex(v)
        
        children = ([edge.vertices[1], edge.weight] for edge in _.select(@edges, (e) -> e.vertices[0] is v))
        
        if not @directed
            children = _.uniq(children.concat(([edge.vertices[0], edge.weight] for edge in _.select(@edges, (e) -> e.vertices[1] is v))))
        
        unless with_edge_weight
            children = (child[0] for child in children)
        
        return children
    
    get_path: (start, goal, with_dist=false) ->
        start = @maybe_string_to_vertex(start)
        goal = @maybe_string_to_vertex(goal)
        
        if @get_edge(start, goal)
            return [start, goal]
        
        if @uniform
        # breadth-first search
            seen = {}
            q = ([child, [start]] for child in @get_children(start))
            x = 0
            while q.length
                [cur_v, cur_path] = _.head(q)
                q = _.tail(q)
                new_path = cur_path.slice()
                new_path.push(cur_v)
                
                if cur_v is goal
                    if with_dist
                        return [new_path, new_path.length]
                    else
                        return new_path
                
                for child in @get_children(cur_v) when child.label not of seen
                    q.push([child, new_path])
                    seen[child.label] = 1
            
            return null
        else
        # Dijkstra's algorithm
            seen = {}
            visited = {}
            visited[start.label] = 1
            h = new heap.BinaryHeap((e) -> e[1])
            for [child, child_dist] in @get_children(start, true)
                h.push([child, child_dist, [start]])
            
            while h.size()
                [cur_v, cur_dist, cur_path] = h.pop()
                visited[cur_v.label] = 1
                
                new_path = cur_path.slice()
                new_path.push(cur_v)
                
                if cur_v is goal
                    if with_dist
                        return [new_path, cur_dist]
                    else
                        return new_path
                
                for [child, child_dist] in @get_children(cur_v, true) when child.label not of visited
                    new_dist = cur_dist + child_dist
                    if child of seen
                        if new_dist < seen[child][1]
                            seen[child][1] = new_dist
                            h.bubbleUp(seen[child])
                    else
                        h.push([child, new_dist, new_path])
            
            return null
    
    

_.extend(exports, {
    Graph
})