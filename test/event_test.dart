#import("../lib/simple_mvc.dart");
#import("../packages/unittest/unittest.dart");

main(){  

  group("Listeners", (){
    test("adds listeners", (){
      var l = new Listeners();
      l.add("listener1").add("listener2");
      expect(l.listeners, equals(["listener1", "listener2"]));
    });
    
    test("dispatches eents", (){
      var l = new Listeners();
      var actualEvent;
      l.add((e) => actualEvent = e);
      
      l.dispatch("expected event");
      expect(actualEvent, equals("expected event"));
    });
  });
}
