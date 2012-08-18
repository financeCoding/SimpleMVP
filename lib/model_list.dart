class ModelList<T> {
  final CollectionEvents on;
  List<T> models;
  
  ModelList():
    on = new CollectionEvents(),
    models = [];
  
  abstract String rootUrl();
  
  abstract T makeInstance(Map attrs, ModelList list);
  
  forEach(fn(T)) => models.forEach(fn);

  map(fn(T)) => models.map(fn);
  
  void add(model){
    models.add(model);
    model.modelList = this;
    on.insert.dispatch(new CollectionInsertEvent(this, model));
  }

  void remove(T model){
    var index = models.indexOf(model);
    models.removeRange(index, 1);
    on.remove.dispatch(new CollectionRemoveEvent(this, model));
  }

  operator[]=(int index, T value){
    var oldModel = models[index];
    models[index] = value;
    on.update.dispatch(new CollectionUpdateEvent(this, oldModel, value, index));
  }
 
  void fetch(){
    var req = new XMLHttpRequest();
    req.on.load.add((event){
      var list = JSON.parse(req.response);
      _handleOnLoad(list);
    });
    req.open("get", rootUrl(), true);
    req.send();
  }
  
  _handleOnLoad(list){
    models = list.map((attrs) => makeInstance(attrs, this));
    on.load.dispatch(new CollectionLoadEvent(this));
  }  
}
