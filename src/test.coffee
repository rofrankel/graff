{ok} = require 'assert'
_ = require 'underscore'
graff = require './graff'

# from http://en.wikipedia.org/wiki/File:Dijksta_Anim.gif
wikipedia_edges = [
    ['A', 'C', 14],
    ['A', 'D', 9],
    ['A', 'E', 7],
    ['C', 'D', 2],
    ['D', 'E', 10],
    ['D', 'F', 11],
    ['E', 'F', 15],
    ['C', 'B', 9],
    ['F', 'B', 6]
]

print_path = (p) ->
    if p then console.log('dist=' + p[1] + ', path=' + p[0].join(', '))

get_test_graph = (opts={}) ->
    opts.edges ?= wikipedia_edges
    return new graff.Graph(opts)

get_path = (start, end, opts) ->
    g = get_test_graph(opts)
    p = g.get_path(start, end, true)
    print_path(p)
    return p

_.extend(exports, {
    get_test_graph
    get_path
})