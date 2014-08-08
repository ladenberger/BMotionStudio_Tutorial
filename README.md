# BMotionStudio 2 Tutorial

## BMotion Studio 2

BMotion Studio 2 is a visual editor for creating domain specific visualisations of formal models with support for Event-B, Classical-B and CSP. The tool is not officially released yet, but the source code is available [here](https://github.com/bendisposto/prob2).

## Try out the lift example

* Clone this repository.
* [Download](http://www.stups.hhu.de/bmotionstudio/index.php/Downloads) the BMotionStudio 2 standalone version for your operating system.
* Unzip the archive and navigate to the bin folder.
* Start BMotionStudio passing the template file as a first argument. For example:

```
./BMotionStudio ~/GIT/BMotionStudio_Tutorial/examples/lift/lift.html
```

Thats all! Your default browser should open with the lift visualisation running.

Try out the build-in graphical editor by clicking on the "Start Editor" button located at the top right corner.

## Getting Started

You can use the default template (located in the template folder) as a starting point to create your own visualisation. The folder contains three files:

* template.html: The actual template file that contains your visualisation. You can use any HTML, SVG, CSS, JavaScript ... The default template file contains an empty SVG graphics that can be opened and edited with the build-in graphical editor.
* observers.json: Contains the observers in JSON format that are created by the editor.
* script.groovy: This file is needed if you want to script your visualisation. With this file you can access the entire [ProB 2 API](http://nightly.cobra.cs.uni-duesseldorf.de/prob2/developer-documentation/prob-devel.pdf) and send updates to the visualisation.

## Build-in Graphical Editor

tbd

## Scripting

Sometimes the build-in graphical editor is insufficient for creating a visualisation. This is the case for more complex visualisations, like interlocking systems and dynamic visualisations. For this reason, BMotion Studio provides a way to script your visualisation. Note that it is possible to mix observers created with the build-in graphical editor and scripting.

Open the _script.groovy_ file and take a look at the _update_ function:

```groovy
bms.registerGroovyObserver(
	[
		update: { ITool tool ->
			// Do something ...
			return
		}
	] as IBMotionGroovyObserver
)
```

The _update_ function is called whenever the model changes in state. Here is the starting point to interact with the model and to send updates to the visualisation. Any code in the _update_ function will be called whenever the model changes in state. The _tool_ argument is the access point to the running model. Every supported formal language has its own _ITool_ implementation. For instance, in case of an Event-B and Classical-B model you can access the Trace with _tool.getTrace()_.

Of course you can use the entire function and feature range of Groovy.

### Evaluating Expressions and Predicates

In order to evaluate expressions and predicates you can use the _eval_ method provided by the BMotion Studio API:
```groovy
// Evaluate expression card({1,2,3,4})
def res1 = bms.eval("card({1,2,3,4})")

assert res1.value == "4"
```
This example evaluates the expression _card(call_buttons)_ in the current state of the model. The result is of the type _EvalResult_. _EvalResult_ is a special class created to make dealing with the evaluated result much easier.

Every _EvalResult_ also has a method which allows for the easy translation of the String representation to be translated into a corresponding Java object (i.e. "1" will be translated as the integer object 1).

Here is an example:

```groovy
def res1 = bms.eval("card({1,2,3,4})")
def trans1 = res1.translate(tool.getStateSpace())

assert trans1.value == 4

def res2 = bms.eval("2 < 4")
def trans2 = res2.translate(tool.getStateSpace())

assert trans2.value == true
```

### Send Updates to the Visualisation

The BMotion Studio API provides some methods to apply modifications on the visualisation. 

The first method can apply so called _Transformers_ on the visualisation [1]. A transformer allows the user to manipulate the DOM of the visualization. A transformer follows the [jQuery selector syntax](http://api.jquery.com/category/selectors). Hower, we decided to lift the functionality of the jQuery selector syntax to the groovy scripting level.

```groovy
// Select elements with ids "circle1" and "rectangle1" and set their fill and stroke attributes
def t = transform("#circle1,#rectangle1") {
  set "fill", "red"
  set "stroke", "gray"
}
// Apply transformer to visualization
bms.apply(t)
```

It is also possible to harness the power of the Groovy closure in order to create a transformer that can be parameterized:

```groovy
// Create a closure that can be parameterized
def colorize = { selection, color ->
  transform(selection) {
    set "fill", color
  }
}
// Color elements "sroot" and "s1" green
bms.apply(colorize("#sroot,#s1", "green"))
```

The next method calls a defined JavaScript method which is defined in your template passing any JSON object:

```groovy
// Create a JSON object
def res = bms.eval("card(call_buttons)")
def json = [result : rest.value, exp : "card(call_buttons)"]
// Call JavaScript function doSomethingWithJson with the created JSON object
bms.apply("doSomethingWithJson", json)
```

You have to create a corresponding JavaScript method in your template (either inline or in a referenced JavaScript file), for instance:

```javascript
function doSomethingWithJson(json) {
  console.log("The result of the expression " + json.exp + " is " + json.result)
}
```

The last method applies a JavaScript code snippet given as a string on the visualisation:

```groovy
// Apply any JavaScript to visualisation
bms.apply('\$("#circle1").attr("fill","blue")')
```
The JavaScript code snippet selects an element with the id "circle1" and sets its "fill" attribute to the color "blue" (See [jQuery selector syntax](http://api.jquery.com/category/selectors) for more details).

### References
[1] [Data Visualization in ProB, Joy Clark, 2013 (Bachelor Thesis)](http://www.stups.hhu.de/w/Data_Visualization_in_ProB)

