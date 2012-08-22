typedef String Template<T>(T model);

class Presenter<T> {
  final HtmlElement el;
  final Template<T> template;
  final T model;
  
  Presenter(this.model, this.el, [this.template]){
    subscribeToModelEvents(); 
  }
  
  Presenter<T> render(){
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