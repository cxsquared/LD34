package entities;
import flixel.tweens.FlxEase;
import flixel.plugin.TweenManager;
import flixel.util.FlxRandom;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxColorUtil;
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

    var pulseSizeOffset = 1.15;
    var bpm:Float;
    var state:PlayState;

    var scoreIncrease = 5;

    // Temp vars
    public var w = 75;
    public var h = 75;

    public function new(X:Float = 0, Y:Float = 0, Type:ClickType, State:PlayState) {
        super(X, Y);

        this.visible = false;
        this.state = State;
        this.bpm = State.bpm;

        setType(Type);
    }

    private function setType(Type:ClickType):Void {
        this.type = Type;

        switch(type) {
            case ClickType.RIGHTCLICK:
                loadGraphic(AssetPaths.rightTarget__png);
            case ClickType.LEFTCLICK:
                loadGraphic(AssetPaths.leftTarget__png);
            case ClickType.BOTHCLICK:
                loadGraphic(AssetPaths.bothTarget__png);
            case ClickType.RANDOM:
                var rand = FlxRandom.float();
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

    override public function update():Void {
        super.update();
        if (triggerTime <= musicTime && !this.visible) {
            this.alpha = 0;
            this.visible = true;
            FlxTween.tween(this, {alpha:1}, bpm, {ease:FlxEase.expoIn});
        }

        if (targetTime+difficultyOffset <= musicTime) {
            state.score--;
            state.setPlayerScale(-0.05);
            this.kill();
        }
    }

    public function clicked(MusicTime):Void {
        this.musicTime = MusicTime;

        if (targetTime - difficultyOffset <= musicTime && targetTime + difficultyOffset >= musicTime) {
            switch(type) {
                case ClickType.BOTHCLICK:
                    if ((FlxG.mouse.justPressed && FlxG.mouse.pressedRight) || (FlxG.mouse.justPressedRight && FlxG.mouse.pressed) ){
                        FlxG.log.add("Both Clicked on Target");
                        state.score += scoreIncrease;
                        state.setPlayerScale(0.05);
                        kill();
                    }
                case ClickType.LEFTCLICK:
                    if (FlxG.mouse.justPressed && !FlxG.mouse.pressedRight){
                        FlxG.log.add("Left Clicked on Target");
                        state.score += scoreIncrease;
                        state.setPlayerScale(0.05);
                        kill();
                    }
                case ClickType.RIGHTCLICK:
                    if (FlxG.mouse.justPressedRight && !FlxG.mouse.pressed){
                        FlxG.log.add("Right Clicked on Target");
                        state.score += scoreIncrease;
                        state.setPlayerScale(0.05);
                        kill();
                    }
                case ClickType.RANDOM:
                    FlxG.log.add("This Shouldn't be called");
            }
            if (this.alive) {
                state.score--;
                state.setPlayerScale(-0.05);
                kill();
            }
        }
    }

    public function pulse():Void {
        this.scale.set(1.15, 1.15);
        FlxTween.tween(this.scale, {x:1, y:1}, .25);
    }
}
