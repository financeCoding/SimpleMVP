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
   <input type="text" class="task-text"/>
   <button>Create!</button>
""";

taskListTemplate(c) => """
    <div id="tasks">
    </div>
""";




class TaskPresenter extends smvc.Presenter<Task> {
  TaskPresenter(task, el) : super(task, el, oneTaskTemplate);

  get events() => {
    "click a.delete": _onDelete
  };

  _onDelete(event){
    model.destroy();
  }
}

class NewTaskPresenter extends smvc.Presenter<Tasks> {
  NewTaskPresenter(tasks, el) :super(tasks, el, newTaskTemplate);

  get events() => {
    "click button": _addNewTask
  };

  _addNewTask(event){
    var textField = el.query(".task-text");
    _createTask(textField.value);
    textField.value = "";
  }

  _createTask(text){
    var task = new Task.withText(text);
    model.add(task);
    task.save();
  }
}

class TasksPresenter extends smvc.Presenter<Tasks>{
  TasksPresenter(tasks, el) : super(tasks, el, taskListTemplate){
    model.fetch();
  }
 
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
}