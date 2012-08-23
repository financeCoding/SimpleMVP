class Model {
  Map attributes;
  ModelList modelList;
  final ModelEvents on;
  Storage storage;

  Model(this.attributes, [this.modelList]):
    on = new ModelEvents(){

    storage = new Storage({"read" : rootUrl, "create" : createUrl,
        "update" : updateUrl, "destroy" : destroyUrl});
  }
  
  abstract String get rootUrl();
  String get createUrl() => rootUrl;
  String get updateUrl() => "${rootUrl}/$id";
  String get destroyUrl() => "${rootUrl}/$id";
  
  get id() => attributes["id"];
  
  bool isSaved() => id != null;
  
  void save(){
    var f = isSaved() ? storage.update(attributes) : storage.create(attributes);
    f.then((attrs) => attributes = attrs);
  }
  
  void destroy(){
    if(isSaved()){
      storage.destroy(id);
    }
    if(modelList != null){
      modelList.remove(this);
    }
  }
  
  getAttr(String name) => attributes[name];

  setAttr(String name, value){
    var oldValue = attributes[name]; 
    attributes[name] = value;
    on.change.dispatch(new ChangeEvent(this, name, oldValue, value));
  }

  noSuchMethod(String name, args){
    if(name.startsWith("get:")){
      var attrName = _extractAttributeName(name);
      if(attributes.containsKey(attrName)){
        return getAttr(attrName);
      }
    } else if (name.startsWith("set:")){
      var attrName = _extractAttributeName(name);
      if(attributes.containsKey(attrName)){
        return setAttr(attrName, args[0]);
      }
    }
    throw new NoSuchMethodException(this, name, args);
  }
  
  _extractAttributeName(name) => name.substring(4);
}