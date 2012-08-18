class Model {
  Map attributes;
  ModelList modelList;
  final ModelEvents on;
  Server server;

  Model(this.attributes, [this.modelList]):
    on = new ModelEvents(),
    server = new Server();
  
  abstract String get rootUrl();
  String get createUrl() => rootUrl;
  String get updateUrl() => "${rootUrl}/$id";
  String get destroyUrl() => "${rootUrl}/$id";
  
  get id() => attributes["id"];
  
  bool isSaved() => id != null;
  
  void save(){
    var method = isSaved() ? "put" : "post";
    var url = isSaved() ? updateUrl : createUrl;
    server.submit(method, url, attributes, (attrs){
      attributes = attrs;
    });
  }
  
  void destroy(){
    if(isSaved())
      server.submit("delete", destroyUrl, {});
    if(modelList != null)
      modelList.remove(this);
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