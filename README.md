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

## Create your own visualisation

You can use the default template (located in the template folder) as a starting point to create your own visualisation. The folder contains three files:

* template.html: The actual template file that contains your visualisation. You can use any HTML, SVG, CSS, JavaScript ... The default template file contains an empty SVG graphics that can be opened and edited with the build-in graphical editor.
* observers.json: Contains the observers in JSON format that are created by the editor.
* script.groovy: This file is needed if you want to script your visualisation. With this file you can access the entire ProB 2 API and send updates to the visualisation.


