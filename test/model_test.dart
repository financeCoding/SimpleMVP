testModels(){  
  var capturer = new EventCapturer();
  
  group("isSaved", (){
    test("is true when id is set", (){
      var m = new TestModel({"id": 1});
      expect(m.isSaved(), isTrue);     
    });
    
    test("is false otherwise", (){
      var m = new TestModel({});
      expect(m.isSaved(), isFalse);
    });
  });
  
  
  group("attributes", (){
    group("getter", (){
      var m;
      
      setUp((){
        m = new TestModel({"key": "value"});
      });
      
      test("returns the attribute value", (){
        expect(m.key, equals("value"));
      });
       

      test("raises an exception when invalid attribute name", (){
        expect(() => m.invalid, throws);    
      });
    });
    
    group("setter", (){
      var m;
      setUp((){
        m = new TestModel({"key": "value"});
      });
      
      test("updates the attribute", (){
        m.key = "newValue";
        expect(m.getAttr("key"), equals("newValue"));
      });

      test("raises an exception when invalid attribute name", (){
        expect(() => m.invalid = "value", throws);    
      });
      
      test("raises an event", (){
        m.on.change.add(capturer.callback);
        m.key = "newValue";
        
        expect(capturer.event.attrName, equals("key"));
        expect(capturer.event.oldValue, equals("value"));
        expect(capturer.event.newValue, equals("newValue"));
      });
    });
    
    group("save", (){
      test("sumbits changes to the server when updates", (){ 
        var m = new TestModel({"id": 1, "key": "value"});
        m.save();
        m.server.getLogs(callsTo('submit', "put", "url/1", m.attributes)).verify(happenedExactly(1));     
      });
      
      test("sumbits changes to the server when create", (){ 
        var m = new TestModel({"key": "value"});
        m.save();
        m.server.getLogs(callsTo('submit', "post", "url", m.attributes)).verify(happenedExactly(1));     
      });
    });

    group("destroy", (){
      var m, list;
      
      setUp((){
        m = new TestModel({"id": 1});
        list = new TestModelList();
      });
      
      test("sumbits changes to the server", (){ 
        m.destroy();
        m.server.getLogs(callsTo('submit', "delete", "url/1", {})).verify(happenedExactly(1));
      });
      
      test("removes itself from the model list", (){
        list.add(m);
        m.destroy();
        expect(list.models, equals([]));
      });
    });
  });
}
