class Listeners {
  final List listeners;
  
  Listeners():
    listeners = [];
  
  Listeners add(listener){
    listeners.add(listener);
    return this;
  }
  
  bool dispatch(event) {
    listeners.forEach((fn) {fn(event);});
    return true;
  }
}

class CollectionEvents {
  final Listeners load, insert, remove, update;
  
  CollectionEvents(): 
    load = new Listeners(), 
    insert = new Listeners(),
    remove = new Listeners(),
    update = new Listeners();
}

class CollectionLoadEvent {
  final collection;
  
  CollectionLoadEvent(this.collection);
}

class CollectionInsertEvent {
  final collection, model;
  
  CollectionInsertEvent(this.collection, this.model);
}

class CollectionRemoveEvent {
  final collection, model;
  
  CollectionRemoveEvent(this.collection, this.model);
}

class ModelEvents {
  final Listeners change;
  
  ModelEvents():
    change = new Listeners();
}

class ChangeEvent {
  final String attrName;
  final model;
  final oldValue;
  final newValue;

  ChangeEvent(this.model, this.attrName, this.oldValue, this.newValue);
}