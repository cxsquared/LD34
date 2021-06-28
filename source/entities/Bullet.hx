package entities;

import flixel.FlxG;
import flixel.FlxSprite;

class Bullet extends FlxSprite {
	var speed:Float;
	var dir:Float;
	var sin = false;
	var sinSpeed:Float;
	var sinAmount:Float;

	public function new(X:Float, Y:Float, Speed:Float, Dir:Float) {
		super(X, Y);
		this.speed = Speed;
		this.dir = Dir;
		loadGraphic(AssetPaths.bullet__png);
	}

	override public function update(elapsed:Float):Void {
		super.update(elapsed);

		if (this.x > FlxG.width || this.x < 0 || this.y > FlxG.height || this.y < 0) {
			this.kill();
		}

		this.x += speed * Math.sin(dir) * elapsed;
		if (sin) {
			this.y += (Math.sin(FlxG.elapsed * this.x * sinSpeed) * sinAmount);
		}
		this.y += speed * Math.cos(dir) * elapsed;

		FlxG.watch.addQuick("Bullet X", x);
		FlxG.watch.addQuick("Bullet y", y);
	}

	public function setSine(DoSine:Bool, Speed:Float, Amount:Float):Void {
		sin = DoSine;
		sinSpeed = Speed;
		sinAmount = Amount;
	}
}
