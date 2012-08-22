class Server {
  void submit(String method, String url, Map json, [callback]){
    var req = _createRequest(method, url, callback);
    _sendRequest(req, json);
  }
  
  _createRequest(method, url, callback){
    var req = new XMLHttpRequest();
    req.on.load.add((e){
      String response = req.response;
      if(!response.isEmpty() && callback != null){
        callback(JSON.parse(response));
      }
    });
    req.open(method, url, true);
    return req;
  }
  
  _sendRequest(req, json){
    if(json != null){
      req.send(JSON.stringify(json));
    }else{
      req.send();
    }
  }
}