coffee = require 'coffee-script'
{puts} = require 'util'

task 'build', ->
    compile_coffeescript = require('child_process').spawn("coffee", ['-o', 'lib', '-c', 'src'])
    compile_coffeescript.stderr.on('data', (data) -> puts data)
