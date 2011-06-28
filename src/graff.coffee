_ = require 'underscore'
heap = require '../vendor/heap.js'

class Graph
    constructor: (opts={}) ->
        @vertices = {}
        @directed = opts.directed ? true
        @uniform = opts.uniform ? false
        if opts.edges then @load(opts.edges)
    
    add_vertex: (label) ->
        if label not of @vertices
            @vertices[label] = {}
    
    connect: (v1, v2, weight=1, label=_.uniqueId('edge_')) ->
        if v1 of @vertices and v2 of @vertices
            edge = {weight, label}
            if v2 not in @vertices[v1] then @vertices[v1][v2] = edge
            if not @directed and v1 not in @vertices[v2] then @vertices[v2][v1] = edge
    
    disconnect: (v1, v2) ->
        delete @vertices[v1][v2]
        if not @directed then delete @vertices[v2][v1]
    
    # edges is an array of arrays of the form [v1, v2, weight, label]
    load: (edges, clean=true) ->
        if clean then @vertices = {}
        
        for [v1, v2, weight, label] in edges
            if v1 not of @vertices then @add_vertex(v1)
            if v2 not of @vertices then @add_vertex(v2)
            @connect(v1, v2, weight, label)
        
        return this
    
    get_path: (start, goal, with_dist=false) ->
        if @uniform
        # breadth-first search
            seen = {}
            q = ([child, [start]] for child of @vertices[start])
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
                
                for child of @vertices[cur_v] when child not of seen
                    q.push([child, new_path])
                    seen[child] = 1
            
            return null
        else
        # Dijkstra's algorithm
            seen = {}
            visited = {}
            visited[start] = 1
            h = new heap.BinaryHeap((e) -> e[1])
            
            children = @vertices[start]
            for child of children
                h.push([child, children[child].weight, [start]])
            
            while h.size()
                [cur_v, cur_dist, cur_path] = h.pop()
                visited[cur_v] = 1
                
                new_path = cur_path.slice()
                new_path.push(cur_v)
                
                if cur_v is goal
                    if with_dist
                        return [new_path, cur_dist]
                    else
                        return new_path
                
                children = @vertices[cur_v]
                for child of children when child not of visited
                    new_dist = cur_dist + children[child].weight
                    if child of seen
                        if new_dist < seen[child][1]
                            seen[child][1] = new_dist
                            h.bubbleUp(seen[child])
                    else
                        h.push([child, new_dist, new_path])
            
            return null
    
    # pre is executed, if existent, on nodes upon first visit
    # post is executed, if existent, on nodes upon completion
    dfs: (pre, post) ->
        visited = {}
        
        for vertex of @vertices when vertex not of visited
            @_dfs_visit(vertex, visited, pre, post)
    
    _dfs_visit: (vertex, visited, pre, post) ->
        queue = []
        queue.push(vertex)
        while queue.length
            current = queue.shift()
            visited[current] = 1
            
            pre?(current)
            for child of @vertices[vertex] when child not of visited
                @_dfs_visit(child, visited, pre, post)
            post?(current)
    
    
    tsort: ->
        sorted = []
        
        @dfs(
            null,
            (vertex) ->
                sorted.unshift(vertex)
        )
        
        return sorted


exports.Graph = Graph
