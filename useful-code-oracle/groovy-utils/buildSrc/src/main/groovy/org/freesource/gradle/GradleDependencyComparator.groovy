package org.freesource.gradle

class GradleDependencyComparator {
    def missingInA = []
    def missingInB = []

    public GradleDependencyComparator(GradleDependencyParser a, GradleDependencyParser b) {
        b.depMap.keySet().each { keyInB ->
            if (!a.depMap.containsKey(keyInB)) {
                missingInA.add(keyInB)
            }
        }
        a.depMap.keySet().each { keyInA ->
            if (!b.depMap.containsKey(keyInA)) {
                missingInB.add(keyInA)
            }
        }
    }

    public void printReport() {
        missingInB.each {
            println '- ' + it
        }
        missingInA.each {
            println '+ ' + it
        }
    }
}

