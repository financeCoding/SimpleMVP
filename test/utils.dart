class EventCapturer {
  var event;
  
  callback(e){
    event = e;  
  }
}

class FakeServer extends Mock implements Server{}

class TestModel extends Model {
  TestModel(attrs, [list]): super(attrs, list) {
    server = new FakeServer();  
  }
  
  final rootUrl = "url";
}

class TestModelList extends ModelList<TestModel> {
  TestModelList(){
    server = new FakeServer();
  }

  final rootUrl = "url";
  
  makeInstance(attrs, list) => new TestModel(attrs, list);
}