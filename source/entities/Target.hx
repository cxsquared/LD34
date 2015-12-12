package entities;
import flixel.util.FlxColor;
import flixel.util.FlxColorUtil;
import flixel.FlxG;
import flixel.FlxSprite;

enum ClickType {
    LEFTCLICK;
    RIGHTCLICK;
    BOTHCLICK;
}

class Target extends FlxSprite {

    var triggerTime:Float;
    var targetTime:Float;
    var difficultyOffset:Float;
    var type:ClickType;
    var musicTime:Float;

    // Temp vars
    public var w = 75;
    public var h = 75;

    public function new(X:Float = 0, Y:Float = 0, Type:ClickType) {
        super(X, Y);

        this.visible = false;

        setType(Type);
    }

    private function setType(Type:ClickType):Void {
        this.type = Type;

        switch(type) {
            case ClickType.RIGHTCLICK:
                makeGraphic(w, h, FlxColor.GREEN);
            case ClickType.LEFTCLICK:
                makeGraphic(w, h, FlxColor.BLUE);
            case ClickType.BOTHCLICK:
                makeGraphic(w, h, FlxColor.RED);
        }
    }

    public function setTimes(TriggerTime:Float, TargetTime:Float, DifficultyOffset:Float):Void {
        this.triggerTime = TriggerTime;
        this.targetTime = TargetTime;
        this.difficultyOffset = DifficultyOffset;
    }

    public function updateTime(MusicTime:Float):Void {
        this.musicTime = MusicTime;
    }

    override public function update():Void {
        if (triggerTime <= musicTime && !this.visible) {
            this.visible = true;
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
            }
        }
    }
}
