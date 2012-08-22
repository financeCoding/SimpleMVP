#import('dart:html');
#import("../simple_mvc.dart", prefix: "smvc");

class Tasks extends smvc.ModelList<Task>{
  final rootUrl = "/api/tasks";
  makeInstance(attrs, tasks) => new Task(attrs, tasks);
}

class Task extends smvc.Model {
  Task(attrs, models): super(attrs, models);
  Task.withText(String text): this({"text": text}, null);
  
  final rootUrl = "/api/task";
  final createUrl = "/api/tasks";
}




oneTaskTemplate(c) => """
  ${c.text}
  <a class="delete" href="#">[X]</a>
""";

newTaskTemplate(c) => """
   <input type="text" id="task-text"/>
   <button id="create-task">Create!</button> 
""";

taskListTemplate(c) => """
    <div id="tasks">
    </div>
""";




class TaskPresenter extends smvc.Presenter {
  TaskPresenter(task, el) : super(task, el, oneTaskTemplate);
  
  subscribeToHtmlEvents(){
    el.query("a.delete").on.click.add(_onDelete); 
  }
  
  _onDelete(event){
    model.destroy();
  }
}

class NewTaskPresenter extends smvc.Presenter {
  NewTaskPresenter(tasks, el) : super(tasks, el, newTaskTemplate);

  subscribeToHtmlEvents(){
    el.query("#create-task").on.click.add(_addNewTask); 
  }

  _addNewTask(event){
    var text = el.query("#task-text").value;
    var task = new Task.withText(text);
    model.add(task);
    task.save();
  } 
}

class TasksPresenter extends smvc.Presenter{
  TasksPresenter(tasks, el) : super(tasks, el, taskListTemplate);
 
  subscribeToModelEvents(){
    model.on.load.add(_rerenderTasks);
    model.on.insert.add(_rerenderTasks);
    model.on.remove.add(_rerenderTasks);
  }

  _rerenderTasks(event){
    var t = el.query("#tasks");
    t.elements.clear();
    
    _buildPresenters().forEach((v){
      t.elements.add(v.render().el);
    });
  }
  
  _buildPresenters() => model.map((t) => new TaskPresenter(t, new Element.tag("li")));
}

main() {
  var tasks = new Tasks();
  var newTaskPresenter = new NewTaskPresenter(tasks, new Element.tag("div"));
  var tasksPresenter = new TasksPresenter(tasks, new Element.tag("div"));
  
  query("#container").elements.addAll([newTaskPresenter.render().el, tasksPresenter.render().el]);

  tasks.fetch();
}