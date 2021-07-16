 import jenkins.*
import jenkins.model.*
import hudson.model.*

// Jenkins.instance.getItem("Test2")

// class helloWorld {
// 	static void main(args) {

//     println("Hellllooooo salma")
// println("==========\n")
//     println(Jenkins.instance.queue.items)
// println("==========\n")
// Jenkins.instance.getItem("Test2")  
// println("Hi agaain4")
// println("Hi agaain5")
// println("Hi agaain6")
// println("Hi agaain8")
//     Jenkins.instance.queue.items.each { println(it.task.name)} // show what exists in queue
//     Jenkins.instance.queue.items.each { println(it.task.name)}
//     // Jenkins.instance.queue.items.each { q.cancel(it.task) }

// // def q = Jenkins.instance.queue
// // q.items.findAll { it.task.name.startsWith('Test') }.each { println(q)}
// // // 	}
// // // }


def q = Jenkins.instance.queue
//Find items in queue that match <project name>
def queue = q.items.findAll { it.task.name.startsWith('Test') }
//get all jobs id to list
def queue_list = []
queue.each { queue_list.add(it.getId()) }
//sort id's, remove last one - in order to keep the newest job, cancel the rest
queue_list.sort().take(queue_list.size() - 1).each { q.doCancelItem(it) }
























