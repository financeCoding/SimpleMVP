testEvents(){  
  group("Listeners", (){
    test("adds listeners", (){
      var l = new Listeners();
      l.add("listener1").add("listener2");
      expect(l.listeners, equals(["listener1", "listener2"]));
    });
    
    test("dispatches events", (){
      var l = new Listeners();
      var actualEvent;
      l.add((e) => actualEvent = e);
      
      l.dispatch("expected event");
      expect(actualEvent, equals("expected event"));
    });
  });

  group("events", (){
    test("returns a list of listeners for the given event type", (){
      var e = new EventMap();
      e.listeners("type1").add("handler");
      expect(e.listeners("type1").listeners, equals(["handler"]));
    });

    test("returns a new list for every given type", (){
      var e = new EventMap();
      expect(e.listeners("type1"), isNot(equals(e.listeners("type2"))));
    });
  });
}
