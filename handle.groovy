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

println("CURRENT BUILD ==> " + currentBuild + " , number : ==> " + currentBuild.getNumber() + " AND Duration ===> " + currentBuild.getDuration() + " UPSTREAM Builds ==> " + currentBuild.getUpstreamBuilds())
println("PR Target branch ==> " + env.CHANGE_TARGET)

currentBuild.result = 'ABORTED'
error('Stopping early…')
return


println 'print items ============='
Jenkins.instance.queue.items.each { 
 println("===========================")
 println("task name: " + it.task.name)
//  println("task id: " + it.task.getId())
 println("task full display name: " + it.task.getFullDisplayName())
 println("task subTasks: " + it.task.getSubTasks())
 println("task url: " + it.task.getUrl())
 println("item api: " + it.getApi())
 println("item cause of blockage: " + it.getCauseOfBlockage())
 println("item display name: " + it.getDisplayName())
 println("item future: " + it.getFuture())
 println("item id: "+ it.getId())
 println("item url: " + it.getUrl())
 println("item toString: " + it.toString())
 println("===========================")
}

def q = Jenkins.instance.queue
//Find items in queue that match <project name>
def queue = q.items//.findAll { it.task.name.startsWith('Test') }
//get all jobs id to list
def queue_list = []
queue.each { 
 println 'print ids ======'
 println(it.getId())
 queue_list.add(it.getId())
}
def sorted = queue_list.sort()
println 'queue list ============'
println(sorted)
//sort id's, remove last one - in order to keep the newest job, cancel the rest
println 'last task =========='
sorted.take(queue_list.size() - 1).each { 
 println(it)
 // q.doCancelItem(it) 
}

//piplineJob1, Test2, TestThree, Test4, TestPR
// TestThree, Test4, TestPR, TestFirst, piplineJob1
























