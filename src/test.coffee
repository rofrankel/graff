_ = require 'underscore'
graff = require './graff'

get_test_graph = () ->
    g = new graff.Graph()
    for v in ['A', 'B', 'C', 'D', 'E', 'F', 'G', 'H']
        g.add_vertex(v)
    
    g.connect('A', 'B', 2)
    g.connect('A', 'C', 1)
    g.connect('C', 'D', 4)
    g.connect('B', 'E', 10)
    g.connect('D', 'F', 1)
    g.connect('F', 'E', 3)
    g.connect('G', 'H', 2)
    
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