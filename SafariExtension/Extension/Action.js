var Action = function() { }

Action.prototype = {
  
// called before extension runs
run: function(parameters) {
  // data sending to the extension
  parameters.completionFunction({"URL": document.URL, "title": document.title});
},
  
// called after the extension has been ran
finalize: function(parameters){
  var customJavaScript = parameters["customJavaScript"];
  // execute js
  eval(customJavaScript);
}
  
};

var ExtensionPreprocessingJS = new Action
