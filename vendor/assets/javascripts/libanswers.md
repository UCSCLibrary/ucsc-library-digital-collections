# Updating libanswers.js

## 1. Update the widget, and get the script
First step is to customize the [Libanswers Feedback widget](https://answers.library.ucsc.edu/admin/product?m=widgets&widget_id=6282) to your preference. Save your changes.

Now [copy and paste this link](https://api2.libanswers.com/1.0/feedback/widgets/6282?type=embed) into your browser, and save the file as libanswers.js

## 2. Fix the Mustache definition

The define function for the embeded Mustache JS must be updated per the [AlmondJS readme](https://github.com/requirejs/almond/blob/master/README.md#common-errors).

You must update the minified version of MustacheJS that appears on or around line 323. *Tip: Do a find on the file for "define(" and you should go directly to the spot.*

Update the code from: 
```js
define(["exports"],e)
```
To:
```js
define('Mustache',["exports"],e)
```
Don't change any other code in the line.

## 3. Fix the Turbolinks integration

The function call at the bottom of the file must be wrapped in a [turbolinks:load event](https://stackoverflow.com/a/38708227).

From:
```js
(function(){ 
  springSpace.la.load_6282 = new springSpace.la.fbwidget_loader(6282); 
})();
```
To:
```js
document.addEventListener("turbolinks:load", function() { 
  springSpace.la.load_6282 = new springSpace.la.fbwidget_loader(6282);
 })();
```