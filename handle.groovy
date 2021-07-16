 import jenkins.*
import jenkins.model.*
import hudson.model.*

// Jenkins.instance.getItem("Test2")

// class helloWorld {
// 	static void main(args) {

    println("Hellllooooo salma")
println("==========\n")
    println(Jenkins.instance.queue.items)
println("==========\n")
Jenkins.instance.getItem("Test2")  
println("Hi agaain4")
println("Hi agaain5")
println("Hi agaain6")

// def q = Jenkins.instance.queue
// q.items.findAll { it.task.name.startsWith('Test') }.each { println(q)}
// // 	}
// // }
