_ = require 'underscore'
graff = require './graff'

get_test_graph = () ->
    g = new graff.Graph()
    for v in ['A', 'B', 'C', 'D', 'E', 'F', 'G', 'H']
        g.add_vertex(v)
    
    g.directed = false
    
    # from http://en.wikipedia.org/wiki/File:Dijksta_Anim.gif
    g.connect('A', 'C', 14)
    g.connect('A', 'D', 9)
    g.connect('A', 'E', 7)
    g.connect('C', 'D', 2)
    g.connect('D', 'E', 10)
    g.connect('D', 'F', 11)
    g.connect('E', 'F', 15)
    g.connect('C', 'B', 9)
    g.connect('F', 'B', 6)
    
    return g

get_path = (start, end, uniform=false) ->
    g = get_test_graph()
    g.uniform = uniform
    
    print_path = (p) -> if p then console.log('dist=' + p[1] + ', path=' + p[0].join(', '))
    p = g.get_path(start, end, true)
    print_path(p)
    return p

_.extend(exports, {
    get_test_graph
    get_path
})