#import("../lib/simple_mvc.dart");
#import("../packages/unittest/unittest.dart");

class TestModel extends Model {
  TestModel(attrs, [list]): super(attrs, list);
  rootUrl() => "url";
}

main(){  

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
      
      test("dispatches an event", (){
        var event;
        m.on.change.add((e){
          event = e;
        });
        m.key = "newValue";
        
        expect(event.attrName, equals("key"));
        expect(event.oldValue, equals("value"));
        expect(event.newValue, equals("newValue"));
      });
    });
  });
}
