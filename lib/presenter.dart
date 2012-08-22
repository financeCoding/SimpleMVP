typedef String Template<T>(T model);

class Presenter<T> {
  final HtmlElement el;
  final Template<T> template;
  final T model;

  Map get events() => {};
  
  Presenter(this.model, this.el, [this.template]){
    subscribeToModelEvents();
    subscribeToDOMEvents();
  }
  
  Presenter<T> render(){
    if(template != null){
      el.innerHTML = template(model);
    }
    return this;
  }
  
  void subscribeToDOMEvents(){
    events.forEach((eventSelector, callback){
      new DelegatedEvent(eventSelector, callback).registerOn(el);
    });
  }
  
  void subscribeToModelEvents(){
  }
}