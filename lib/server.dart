class Server {
  void submit(String method, String url, Map json, [callback]){
    var req = new XMLHttpRequest();
    req.on.load.add((e){
      var parsed = JSON.parse(req.response); 
      if(callback != null)
        callback(parsed);
    });
    req.open(method, url, true);
    req.send(json);
  }
}