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
			return
		}
	] as IBMotionGroovyObserver
)
```

The _update_ function is called whenever the model changes in state. Here is the starting point to interact with the model and send updates to the visualisation. Any code in the __update__ function will be called whenever the model changes in state. Of course you can use the entire function and feature range of Groovy.

### Evaluating Expressions and Predicates

In order to evaluate expressions and predicates you can use the _eval_ method provided by the BMotion Studio API:
```groovy
def result = bms.eval("card(call_buttons")
```

### Send Updates to the Visualisation

The BMotion Studio API provides some methods to send updates to the visualisation. The first method can evaluate any JavaScript code snippet given as a string:

```groovy
// Apply any JavaScript to visualisation
bms.apply('\$("#mycircle").attr("fill","blue")')
```

The second method can send any JSON object to the visualisation:

```groovy
// Create a JSON object
def json = [result : bms.eval("card(call_buttons")]
// Call JavaScript function bms.doSomethingWithJson with JSON object
bms.apply("bms.doSomethingWithJson", json)
```
Using this method you have to create a corresponding JavaScript method which handles the JSON data. For instance:

```javascript
bms.doSomethingWithJson = function(data) {
  console.log(data)
}
```

The third method can apply so called _Transformers_. A Transformer allows the user to manipulate the DOM of the visualization. Transformer follows the [jQuery selector syntax](http://api.jquery.com/category/selectors).

```groovy
// Select elements with ids "circle1" and "rectangle1" and set their fill and stroke attributes
def t = transform("#circle1,#rectangle1") {
  set "fill", "red"
  set "stroke", "gray"
}
// Apply transformer to visualization
bms.apply(t)
```
