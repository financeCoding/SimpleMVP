class ModelList<T extends Model> {
  final CollectionEvents on;
  List<T> models;
  Storage storage;
  
  ModelList():
    on = new CollectionEvents(),
    models = []{

    storage = new Storage({"readAll" : rootUrl});
  }

  abstract String get rootUrl;
  
  abstract T makeInstance(Map attrs, ModelList list);
  
  forEach(fn(T)) => models.forEach(fn);

  map(fn(T)) => models.map(fn);
  
  void add(T model){
    models.add(model);
    model.modelList = this;
    on.insert.dispatch(new CollectionInsertEvent(this, model));
  }

  void remove(T model){
    var index = models.indexOf(model);
    if(index == -1) return;
    
    models.removeRange(index, 1);
    on.remove.dispatch(new CollectionRemoveEvent(this, model));
  }

  void reset(List list){
    models = list.map((attrs) => makeInstance(attrs, this));
    on.load.dispatch(new CollectionLoadEvent(this));
  }
 
  void fetch(){
    storage.readAll().then(reset);
  }
}