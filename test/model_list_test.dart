testModelLists(){
  var capturer = new EventCapturer();
  
  group("add", (){
    var list;
    var m;
    
    setUp((){
      list = new TestModelList();
      m = new TestModel({});
    });
    
    test("adds the element to the collection", (){
      list.add(m);
      expect(list.models, equals([m]));
    });
    
    test("sets the modelList property on the model", (){
      list.add(m);
      expect(m.modelList, equals(list));
    });

    test("raises an event", (){
      list.on.insert.add(capturer.callback);
      list.add(m);
      
      expect(capturer.event.model, equals(m));
    });
  });

  group("remove", (){
    var list;
    var m;
    
    setUp((){
      list = new TestModelList();
      m = new TestModel({});
      list.add(m);
    });
    
    test("removes the element from the collection", (){
      list.remove(m);
      expect(list.models, equals([]));
    });
    
    test("does nothing when cannot find the element", (){
      list.remove(m);
      list.remove(m);
    });

    test("raises an event", (){
      list.on.insert.add(capturer.callback);
      list.add(m);
      
      expect(capturer.event.model, equals(m));
    });
  });
}