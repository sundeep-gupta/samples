
def con = new ConfigSlurper().parse(new File('config.properties').toURL())
println con.key1
println con.key2
