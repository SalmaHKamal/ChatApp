println("Groovy from chatHistory+newSolution branch")
println("Hi agaain")
println("Hi agaain2")
println("Hi agaain3")
println("Hi agaain4")
println("Hi agaain5")
println("Hi agaain6")
println("Hi agaain7")
println("Hi agaain8")
println("Hi agaain9")
println("Hi agaain10")
println("Hi agaain11")
println("Hi agaain12")
println("Hi agaain13")
println("Hi agaain14")
println("Hi agaain15")
println("Hi again16")
println("Hi agaain17")
println("Hi agaain18")
println("Hi agaain19")
println("Hi agaain20")
println("Hi agaain21")
println("Hi agaain22")
println("Hi agaain23")
println("Hi agaain24")
println("Hi agaain25")
println("Hi agaain26")
println("Hi agaain27")

import jenkins.*

println Jenkins.instance.queue

println("Salma")

println("\n ==================== A Way To Check if There is Other task for Same job ====================== \n ")
@NonCPS
def name_from_url(url)
{
    url = url.substring(url.indexOf("/") + 1);
    url = url.substring(0, url.indexOf("/"));
    return url
}

def name = env.JOB_NAME
def queueOne = Jenkins.instance.queue.items
if (queueOne.any{ name_from_url(it.task.getUrl()) == name }) {
  println "Newer " + name + " job(s) in queue, aborting"
  //build.doStop()
} else {
  println "No newer " + name + " job(s) in queue, proceeding"
}

println("\n ===================================================== \n ")
Jenkins.instance.queue.items.each { println "taskName" + it.task.name + " and its id is " + it.getId() + "\n" }
def q = Jenkins.instance.queue
println("get last build")
//Find items in queue that match <project name>
def queue = q.items.findAll { it.task.name.startsWith('Test') }
//get all jobs id to list
def queue_list = []
queue.each { queue_list.add(it.getId()) }
//sort id's, remove last one - in order to keep the newest job, cancel the rest
queue_list.sort().take(queue_list.size() - 1).each { it.task.name } // q.doCancelItem(it) 

