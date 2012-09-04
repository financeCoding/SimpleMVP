#import('dart:html');
#import('../simple_mvp.dart', prefix: "smvp");

class Tasks extends smvp.ModelList<Task>{
  final rootUrl = "/api/tasks";
}

class Task extends smvp.Model {
  Task(attrs, modelList): super(attrs, modelList);
  Task.fromText(String text): this({"text": text}, null);
  
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




class TaskPresenter extends smvp.Presenter<Task> {
  TaskPresenter(task, el) : super(task, el, oneTaskTemplate);

  get events => {
    "click a.delete": _onDelete
  };

  _onDelete(event){
    model.destroy();
  }
}

class NewTaskPresenter extends smvp.Presenter<Tasks> {
  NewTaskPresenter(tasks, el) :super(tasks, el, newTaskTemplate);

  get events => {
    "click button": _addNewTask
  };

  _addNewTask(event){
    var textField = el.query(".task-text");
    _createTask(textField.value);
    textField.value = "";
  }

  _createTask(text){
    var task = new Task.fromText(text);
    model.add(task);
    task.save();
  }
}

class TasksPresenter extends smvp.Presenter<Tasks>{
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