import Shape.ShapeTypes;
import haxe.Timer;
import h2d.Font;
import h2d.Text;
import hxd.Res;
import Random;
import js.Browser;
import color.Color;

class Main extends hxd.App {
	var textShapesLen:Text;
	var textAreaOcc:Text;
	var shapesPerSec:Int = 1;

	public static var listOfShapes:Array<Shape> = new Array<Shape>();

	override function init() {
		Res.initEmbed();
		engine.backgroundColor = 0xDBDBDB;
		var font:Font = Res.RobotoBlack.build(18);
		textShapesLen = new Text(font, s2d);
		textAreaOcc = new Text(font, s2d);
		textShapesLen.y = 20;
		textShapesLen.x = 20;
		textShapesLen.text = "Number of shapes: " + listOfShapes.length;
		textAreaOcc.text = "Area occupied : " + listOfShapes.length;
		textAreaOcc.y = 40;
		textAreaOcc.x = 20;
		textShapesLen.textColor = 0x2ca3de;
		textAreaOcc.textColor = 0x2ca3de;

		Browser.document.getElementById("decreaseShapesPerSec").onclick = (event) -> handleNumShapes(-1);
		Browser.document.getElementById("increaseShapesPerSec").onclick = (event) -> handleNumShapes(1);
		Browser.document.getElementById("decreaseGravity").onclick = (event) -> handleGravity(-0.1);
		Browser.document.getElementById("increaseGravity").onclick = (event) -> handleGravity(0.1);

		s2d.addEventListener(onEvent);

		var timer = new haxe.Timer(1000);
		timer.run = function() {
			generateShape(shapesPerSec);
		}
	}

	function onEvent(event:hxd.Event) {
		switch (event.kind) {
			case EPush:
				var shapeWidth = Random.int(50, 100);
				var shapeHeight = Random.int(50, 100);

				var shape = new Shape(s2d, event.relX - (shapeWidth / 2), event.relY - (shapeHeight / 2), shapeWidth, shapeHeight, Color.random(0xFF),
					cast(Random.int(3, 8), ShapeTypes));
				listOfShapes.push(shape);
				event.propagate = false;
			case _:
		}
	}

	function handleGravity(e) {
		if (Shape.gravity + e < 0)
			return;
		Shape.gravity += e;
		Browser.document.getElementById("gravityValue").innerText = Std.string(round(Shape.gravity, 1));
	}

	public function round(number:Float, ?precision = 2):Float {
		number *= Math.pow(10, precision);
		return Math.round(number) / Math.pow(10, precision);
	}

	function handleNumShapes(e) {
		if (shapesPerSec + e < 0)
			return;
		shapesPerSec += e;
		Browser.document.getElementById("shapesPerSec").innerText = Std.string(shapesPerSec);
	}

	function generateShape(numShapes:Int) {
		for (i in 0...numShapes) {
			var shapeWidth = Random.int(50, 100);
			var shapeHeight = Random.int(50, 100);
			var x = Random.float(0, s2d.width - shapeWidth);
			var shape = new Shape(s2d, x, 0 - shapeHeight, shapeWidth, shapeHeight, Color.random(0xFF), cast(Random.int(3, 8), ShapeTypes));
			listOfShapes.push(shape);
		}
	}

	function usedSurfaceArea() {
		// this doesn't take into account if a shape overlays on top of another
		var totalShapesArea:Float = 0;
		for (shape in listOfShapes) {
			totalShapesArea += shape.width * shape.height;
		}
		return totalShapesArea;
	}

	function windowSurfaceArea() {
		return engine.width * engine.height;
	}

	override function update(dt:Float) {
		for (shape in listOfShapes) {
			shape.update(dt);
		}
		textShapesLen.text = "Number of shapes: " + listOfShapes.length;
		Browser.document.getElementById("shapeCount").innerText = Std.string(listOfShapes.length);
		var area = usedSurfaceArea() + "px / " + windowSurfaceArea() + "px";
		textAreaOcc.text = "Surface area occupied by shapes: " + area;
		Browser.document.getElementById("shapeArea").innerText = area;
	}

	static function main() {
		new Main();
	}
}
