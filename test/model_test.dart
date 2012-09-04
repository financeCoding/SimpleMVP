testModels() {
  group("model_test", () {

    var capturer = new EventCapturer();

    group("isSaved", () {
      test("is true when id is set", () {
        var m = new TestModel({"id": 1});
        expect(m.isSaved(), isTrue);
      });

      test("is false otherwise", () {
        var m = new TestModel({});
        expect(m.isSaved(), isFalse);
      });
    });


    group("attributes", () {
      group("getter", () {
        var m;

        setUp(() {
          m = new TestModel({"key": "value"});
        });

        test("returns the attribute value", () {
          expect(m.key, equals("value"));
        });


        test("raises an exception when invalid attribute name", () {
          expect(() => m.invalid, throws);
        });
      });

      group("setter", () {
        var m;
        setUp(() {
          m = new TestModel({"key": "value"});
        });

        test("updates the attribute", () {
          m.key = "newValue";
          expect(m.getAttr("key"), equals("newValue"));
        });

        test("raises an exception when invalid attribute name", () {
          expect(() => m.invalid = "value", throws);
        });

        test("raises an event", () {
          m.on.change.add(capturer.callback);
          m.key = "newValue";

          expect(capturer.event.attrName, equals("key"));
          expect(capturer.event.oldValue, equals("value"));
          expect(capturer.event.newValue, equals("newValue"));
        });
      });

      group("save", () {
        var dummyFuture = new Future.immediate("value");

        test("updates the element in the storage", () {
          var m = new TestModel({"id": 1, "key": "value"});
          m.storage.when(callsTo('update', 1, m.attributes)).alwaysReturn(dummyFuture);
          m.save();
        });

        test("creates the element in the storage", () {
          var m = new TestModel({"key": "value"});
          m.storage.when(callsTo('create', m.attributes)).alwaysReturn(dummyFuture);
          m.save();
        });
      });

      group("destroy", () {
        var m, list;

        setUp(() {
          m = new TestModel({"id": 1});
          list = new TestModelList();
        });

        test("removes the element from the storage", () {
          m.destroy();
          m.storage.getLogs(callsTo('destroy', 1)).verify(happenedExactly(1));
        });

        test("removes itself from the model list", () {
          list.add(m);
          m.destroy();
          expect(list.models, equals([]));
        });
      });
    });
  });
}
