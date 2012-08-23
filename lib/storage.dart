class Storage {
  final _urls;

  Storage(this._urls);

  Future<List> readAll() => _submit("GET", _urls["readAll"], {});

  Future<Map> read(id) => _submit("GET", _urls["read"], {"id" : id});

  Future<Map> create(Map attrs) => _submit("POST", _urls["create"], attrs);

  Future<Map> update(Map attrs) => _submit("PUT", _urls["update"], attrs);

  Future<Map> destroy(id) => _submit("DELETE", _urls["destroy"], {"id" : id});

  _submit(method, url, json){
    var c = new Completer();
    var req = _createRequest(method, url, (res) => c.complete(res));
    req.send(JSON.stringify(json));
    return c.future;
  }

  _createRequest(method, url, callback){
    var req = new XMLHttpRequest();

    req.on.load.add((e){
      String response = req.response;
      var parsedResponse = response.isEmpty() ? {} : JSON.parse(response);
      callback(parsedResponse);
    });

    req.open(method, url, true);
    return req;
  }
}