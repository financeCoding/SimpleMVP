#import("../simple_mvc.dart");
#import("../packages/unittest/unittest.dart");

#import('dart:html');

#source("utils.dart");
#source("event_test.dart");
#source("model_test.dart");
#source("model_list_test.dart");

main(){
  testEvents();
  testModels();
  testModelLists();
}