#library("must_player_server");

#import("dart:io");
#import("dart:json");

final HOST = "127.0.0.1";
final PORT = 8080;

void main() {
  var server = new HttpServer();
  server.addRequestHandler((request) => true, (request, response){
    new RequestHandler(request,response).process();
    }
  );
  server.listen(HOST, PORT); 
}

class RequestHandler {
  HttpRequest request;
  HttpResponse response;
  
  RequestHandler(this.request, this.response);
  
  void process() {
    print("REQUEST: ${request.uri}");
    
    if(request.uri.startsWith("/tasks.json")){
      _render("text/json", _items());
      
    } else if (request.uri.endsWith(".dart")) {
      var file = new File(_filename(request.uri));
      _render("application/dart", file.readAsTextSync());
      
    } else {
      var file = new File(_filename(request.uri));
      if(file.existsSync()){
        _render(_type(request.uri), file.readAsTextSync());
      }
    }
  }
  
  _type(file){
    if(file.endsWith("css")){
      return "text/css";
    } else {
      return "text/html";
    }
  }
  
  _render(contentType, body){
    response.headers.set(HttpHeaders.CONTENT_TYPE, "$contentType; charset=UTF-8");
    response.outputStream.writeString(body);
    response.outputStream.close();
  }
  
  _filename(url) => url.substring(url.indexOf("/") + 1);

  _items() {
    var r = [{"id": 1, "text": "Task 1"}, {"id": 2, "text": "Task 2"}];
    return JSON.stringify(r);
  }
}