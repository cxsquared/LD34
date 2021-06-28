package entities;

import flixel.effects.particles.FlxParticle;
import flixel.math.FlxMath;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween.FlxTweenManager;
import flixel.math.FlxRandom;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxColorTransformUtil;
import flixel.FlxG;
import flixel.FlxSprite;

enum ClickType {
	LEFTCLICK;
	RIGHTCLICK;
	BOTHCLICK;
	RANDOM;
}

class Target extends FlxSprite {
	var triggerTime:Float;
	var targetTime:Float;
	var difficultyOffset:Float;
	var type:ClickType;
	var musicTime:Float;

	var shadow:FlxSprite;

	var pulseSizeOffset = 1.15;
	var bpm:Float;
	var state:PlayState;

	var scoreIncrease = 5;

	var random = new FlxRandom();

	public function new(X:Float = 0, Y:Float = 0, Type:ClickType, State:PlayState) {
		super(X, Y);

		this.visible = false;
		this.state = State;
		this.bpm = State.bpm;

		shadow = new FlxSprite(X, Y);
		shadow.visible = false;
		shadow.alpha = 0.25;
		state.add(shadow);

		setType(Type);
	}

	private function setType(Type:ClickType):Void {
		this.type = Type;

		switch (type) {
			case ClickType.RIGHTCLICK:
				loadGraphic(AssetPaths.rightTarget__png);
				shadow.loadGraphic(AssetPaths.rightTarget__png);
			case ClickType.LEFTCLICK:
				loadGraphic(AssetPaths.leftTarget__png);
				shadow.loadGraphic(AssetPaths.leftTarget__png);
			case ClickType.BOTHCLICK:
				loadGraphic(AssetPaths.bothTarget__png);
				shadow.loadGraphic(AssetPaths.bothTarget__png);
			case ClickType.RANDOM:
				var rand = random.float();
				if (rand > .66) {
					setType(ClickType.LEFTCLICK);
				} else if (rand > .33) {
					setType(ClickType.RIGHTCLICK);
				} else {
					setType(ClickType.BOTHCLICK);
				}
		}
	}

	public function setTimes(TargetTime:Float, TriggerOffset:Float, DifficultyOffset:Float):Void {
		this.triggerTime = TargetTime - TriggerOffset;
		this.targetTime = TargetTime;
		this.difficultyOffset = DifficultyOffset;
	}

	public function updateTime(MusicTime:Float):Void {
		this.musicTime = MusicTime;
	}

	override public function update(elapsed:Float):Void {
		super.update(elapsed);

		// Showing target
		if (triggerTime <= musicTime && !this.visible) {
			// this.alpha = 0;
			this.scale.set(0, 0);
			this.visible = true;
			shadow.visible = true;
			// FlxTween.tween(this, {alpha:1}, bpm, {ease:FlxEase.expoIn});
			FlxTween.tween(this.scale, {x: 1, y: 1}, targetTime - triggerTime);
		}

		// Target not click in time
		if (targetTime + difficultyOffset <= musicTime) {
			state.score--;
			this.kill();
		}
	}

	override public function kill():Void {
		state.targets.addTarget(1);
		shadow.kill();
		super.kill();
	}

	public function clicked(MusicTime):Void {
		this.musicTime = MusicTime;

		if (targetTime - difficultyOffset <= musicTime && targetTime + difficultyOffset >= musicTime) {
			switch (type) {
				case ClickType.BOTHCLICK:
					if ((FlxG.mouse.justPressed && FlxG.mouse.pressedRight) || (FlxG.mouse.justPressedRight && FlxG.mouse.pressed)) {
						FlxG.log.add("Both Clicked on Target");
						state.score += scoreIncrease;
						state.setPlayerScale(0.05);
						state.explode(this.x + this.width / 2, this.y + this.height / 2);
						kill();
					}
				case ClickType.LEFTCLICK:
					if (FlxG.mouse.justPressed && !FlxG.mouse.pressedRight) {
						FlxG.log.add("Left Clicked on Target");
						state.score += scoreIncrease;
						state.setPlayerScale(0.05);
						state.explode(this.x + this.width / 2, this.y + this.height / 2);
						kill();
					}
				case ClickType.RIGHTCLICK:
					if (FlxG.mouse.justPressedRight && !FlxG.mouse.pressed) {
						FlxG.log.add("Right Clicked on Target");
						state.score += scoreIncrease;
						state.setPlayerScale(0.05);
						state.explode(this.x + this.width / 2, this.y + this.height / 2);
						kill();
					}
				case ClickType.RANDOM:
					FlxG.log.add("This Shouldn't be called");
			}
			if (this.alive && this.type != ClickType.BOTHCLICK) {
				state.score--;
				playGlicth();
				kill();
			}
		}
	}

	public function pulse():Void {
		shadow.scale.set(1.15, 1.15);
		FlxTween.tween(shadow.scale, {x: 1, y: 1}, .25);
	}

	private function playGlicth():Void {
		var rand = random.float();
		if (rand > .8) {
			FlxG.sound.play("assets/sounds/glitch00.wav", 0.25);
		} else if (rand > .6) {
			FlxG.sound.play("assets/sounds/glitch01.wav", 0.25);
		} else if (rand > .4) {
			FlxG.sound.play("assets/sounds/glitch02.wav", 0.25);
		} else if (rand > .2) {
			FlxG.sound.play("assets/sounds/glitch03.wav", 0.25);
		} else {
			FlxG.sound.play("assets/sounds/glitch04.wav", 0.25);
		}
	}
}
