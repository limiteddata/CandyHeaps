import h2d.Scene;
import h2d.Graphics;
import h2d.Interactive;

enum abstract ShapeTypes(Int) {
	var Sides_3 = 3;
	var Sides_4 = 4;
	var Sides_5 = 5;
	var Sides_6 = 6;
	var Circle = 7;
	var Elipse = 8;
}

class Shape {
	var shapeGraph:Graphics;

	public static var gravity:Float = 3.1;

	var velocity:Float = 0;
	var scene:Scene;

	public var X:Float;
	public var Y:Float;
	public var width:Float;
	public var height:Float;

	public function new(_scene:Scene, _x:Float, _y:Float, _width:Float, _height:Float, color:Int, shape:ShapeTypes = Sides_4) {
		scene = _scene;
		X = _x;
		Y = _y;
		width = _width;
		height = _height;
		shapeGraph = new Graphics(scene);
		var interaction = new Interactive(width, height, shapeGraph);
		interaction.onClick = function(event:hxd.Event) {
			this.destroy();
		}
		shapeGraph.beginFill(color);
		if (shape == Sides_4)
			shapeGraph.drawRect(0, 0, width, height);
		else if (shape == Circle)
			shapeGraph.drawCircle(width / 2, height / 2, width / 2);
		else if (shape == Elipse)
			shapeGraph.drawEllipse(width / 2, width / 2, width, width / 2);
		else
			shapeGraph.drawCircle(width / 2, height / 2, width / 2, cast(shape, Int));
		shapeGraph.endFill();
	}

	public function setPosition(x:Float, y:Float) {
		X = x;
		Y = y;
		shapeGraph.x = x;
		shapeGraph.y = y;
	}

	public function update(dt:Float) {
		if (shapeGraph.y > scene.height + height) {
			this.destroy();
			return;
		}
		setPosition(X, Y + gravity * dt * 100);
		velocity += gravity * dt;
	}

	public function destroy() {
		Main.listOfShapes.remove(this);
		scene.removeChild(shapeGraph);
	}
}
