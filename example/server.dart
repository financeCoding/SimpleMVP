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
    var uri = request.uri;
    
    print("${request.method} ${uri} : ${request.inputStream.read()}");
    
    if(uri.startsWith("/api/tasks")){
      _render("text/json", _items());

    } else if (uri.startsWith("/api/task")){
      _render("text/json", _nextItem());
        
    } else if (uri.endsWith(".dart")) {
      _renderDartFile();
      
    } else if (uri.endsWith(".css")){
      var file = new File("example/${_filename(uri)}");
      _render("text/css", file.readAsTextSync());

    } else if (uri.endsWith(".html")){
      var file = new File("example/${_filename(uri)}");
      _render("text/html", file.readAsTextSync());
    }
  }
  
  _renderDartFile(){
    var uri = request.uri;

    var libFile = new File(_filename(uri));
    var exampleFile =  new File("example/${_filename(uri)}");
    
    if(libFile.existsSync()){
      _render("application/dart", libFile.readAsTextSync());
    } else {
      _render("application/dart", exampleFile.readAsTextSync());
    }
  }
  
  _filename(uri) => uri.substring(uri.indexOf("/") + 1);
  
  _render(contentType, body){
    response.headers.set(HttpHeaders.CONTENT_TYPE, "$contentType; charset=UTF-8");
    response.outputStream.writeString(body);
    response.outputStream.close();
  }

  _items() {
    var r = [{"id": 1, "text": "Task 1"}, {"id": 2, "text": "Task 2"}];
    return JSON.stringify(r);
  }

  _nextItem() {
    var r = [{"id": 1, "text": "Task 1"}];
    return JSON.stringify(r);
  }
  
  //log all parameters
  //implement "DELETE" "PUT" "POST"
}