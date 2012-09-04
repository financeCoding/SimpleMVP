#library("simple_mvp_test");

#import("package:unittest/unittest.dart");
#import("package:unittest/html_enhanced_config.dart");
#import('simple_mvp.dart');

#import('dart:html');

#source("test/utils.dart");
#source("test/event_test.dart");
#source("test/model_test.dart");
#source("test/model_list_test.dart");

main(){
  useHtmlEnhancedConfiguration();

  testEvents();
  testModels();
  testModelLists();
}