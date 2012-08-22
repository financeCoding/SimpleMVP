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

class Events {
  final _listeners;

  Events():
    _listeners = new Map();

  Listeners listeners(String eventType){
    _listeners.putIfAbsent(eventType, () => new Listeners());
    return _listeners[eventType];
  }
}

class CollectionEvents extends Events {
  Listeners get load() => listeners("load");
  Listeners get insert() => listeners("insert");
  Listeners get remove() => listeners("remove");
  Listeners get update() => listeners("update");
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

class ModelEvents extends Events {
  Listeners get change() => listeners("change");
}

class ChangeEvent {
  final String attrName;
  final model;
  final oldValue;
  final newValue;

  ChangeEvent(this.model, this.attrName, this.oldValue, this.newValue);
}