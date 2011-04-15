_ = require 'underscore'

class Vertex
    constructor: (@label) ->
        @label ?= _.uniqueId('vertex_')


class Edge
    constructor: (v1, v2, @label=_.uniqueId('edge_'), @weight=1) ->
        @vertices = [v1, v2]


class Graph
    constructor: (opts={}) ->
        @vertices = []
        @edges = []
        @directed = opts.directed ? false
        @uniform = opts.uniform ? true
    
    connect: (v1, v2, label) ->
        if not (@get_edge(v1, v2))
            @edges.push(new Edge(v1, v2))
    
    disconnect: (v1, v2) ->
        if edge = @get_edge(v1, v2)
            @edges = _.without(@edges, [edge])
    
    get_edge: (v1, v2) ->
        edges = _.select(@edges, (e) -> v1 in e and v2 in e)
        
        if @directed
            edges = _.select(edges, (e) -> _.indexOf(e, v1) < _.indexOf(e, v2))
        
        if v1 is v2
            edges = _.select(edges, (e) -> _.select(e, (v) -> v is v1).length > 1)
        
        return if edges.length then edges[0] else null
    
    get_children: (v) ->
        children = (edge[1] for edge in _.select(@edges, (e) -> e[0] is v))
        
        if not @directed
            children = _.uniq(children.concat((edge[0] for edge in _.select(@edges, (e) -> e[1] is v))))
        
        return children
    
    get_path: (start, goal) ->
        if @get_edge(start, goal)
            return [start, goal]
        
        if @uniform
        # breadth-first search
            q = ([child, [start]] for child in @get_children(start))
            x = 0
            while q.length
                [cur_v, cur_path] = _.head(q)
                q = _.tail(q)
                new_path = cur_path.slice()
                new_path.push(cur_v)
                
                if cur_v is goal
                    return new_path
                
                for child in @get_children(cur_v)
                    q.push([child, new_path])
            
            return null
        else
        # Dijkstra's algorithm




_.extend(exports, {
    Vertex
    Edge
    Graph
})