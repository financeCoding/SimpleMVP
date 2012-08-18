typedef String Template<T>(T model);

class View<T> {
  final HtmlElement el;
  final Template<T> template;
  final T model;
  
  View(this.model, this.el, [this.template]){
    subscribeToModelEvents(); 
  }
  
  View<T> render(){
    if(template != null){
      el.innerHTML = template(model);
    }
    subscribeToHtmlEvents();
    return this;
  }
  
  void subscribeToHtmlEvents(){
  }
  
  void subscribeToModelEvents(){
  }
}