package entities;

import flixel.math.FlxRandom;
import flixel.util.FlxTimer;
import flixel.FlxSprite;

class Explosion extends FlxSprite {
	public function new(X:Float, Y:Float, State:PlayState) {
		var random = new FlxRandom();
		super(X, Y);

		loadGraphic(AssetPaths.explosion__png, true, 50, 50);
		animation.add("explode", [0, 1, 2], 12, false);
		animation.callback = onAnimFinish;
		this.angle = random.int(0, 360);

		var delay = new FlxTimer();
		delay.start(random.float(0, 1.75), function(timer:FlxTimer):Void {
			State.add(this);
			this.animation.play("explode");
		}, 1);
	}

	private function onAnimFinish(Name:String, FrameNum:Int, FrameIndex:Int):Void {
		if (Name == "explode" && FrameNum >= 2) {
			this.kill();
		}
	}
}
