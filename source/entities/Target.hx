package entities;
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

    // Temp vars
    public var w = 75;
    public var h = 75;

    public function new(X:Float = 0, Y:Float = 0, Type:ClickType, Bpm:Float) {
        super(X, Y);

        this.visible = false;
        this.bpm = Bpm;

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

    public function setTimes(TargetTime:Float, DifficultyOffset:Float):Void {
        this.triggerTime = TargetTime - bpm;
        this.targetTime = TargetTime;
        this.difficultyOffset = DifficultyOffset;
    }

    public function updateTime(MusicTime:Float):Void {
        this.musicTime = MusicTime;
    }

    override public function update():Void {
        if (triggerTime <= musicTime && !this.visible) {
            this.alpha = 0;
            this.visible = true;
            FlxTween.tween(this, {alpha:1}, bpm);
        }

        if (targetTime+difficultyOffset <= musicTime) {
            this.kill();
        }
    }

    public function clicked(MusicTime):Void {
        this.musicTime = MusicTime;

        if (targetTime - difficultyOffset <= musicTime && targetTime + difficultyOffset >= musicTime) {
            switch(type) {
                case ClickType.BOTHCLICK:
                    if (FlxG.mouse.justPressed && FlxG.mouse.justPressedRight){
                        FlxG.log.add("Both Clicked on Target");
                        kill();
                    }
                case ClickType.LEFTCLICK:
                    if (FlxG.mouse.justPressed && !FlxG.mouse.justPressedRight){
                        FlxG.log.add("Left Clicked on Target");
                        kill();
                    }
                case ClickType.RIGHTCLICK:
                    if (FlxG.mouse.justPressedRight && !FlxG.mouse.justPressed){
                        FlxG.log.add("Both Clicked on Target");
                        kill();
                    }
                case ClickType.RANDOM:
                    FlxG.log.add("This Shouldn't be called");
            }
        }
    }

    public function pulse():Void {
        this.scale.set(1.15, 1.15);
        FlxTween.tween(this.scale, {x:1, y:1}, .25);
    }
}
