class Model {
  Map attributes;
  ModelList modelList;
  final ModelEvents on;

  Model(this.attributes, [this.modelList]):
    on = new ModelEvents();
  
  abstract String rootUrl();
  
//  String getUrl() => isSaved() ? "$rootUrl()/$id" : rootUrl();

  get id() => attributes["id"];
  
  bool isSaved() => id != null;
  
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