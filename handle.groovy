 import jenkins.*
import jenkins.model.*
import hudson.model.*

// Jenkins.instance.getItem("Test2")

// class helloWorld {
// 	static void main(args) {

    println("Hellllooooo salma")
    Jenkins.instance.queue.items.each { println(it.task.name)}

// def q = Jenkins.instance.queue
// q.items.findAll { it.task.name.startsWith('Test') }.each { println(q)}
// // 	}
// // }