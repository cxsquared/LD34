package entities;
import flixel.FlxG;
import flixel.util.FlxMath;
import flixel.group.FlxTypedGroup;
import flixel.util.FlxRandom;
import flixel.util.FlxPoint;
import flixel.FlxSprite;
class Boss extends FlxSprite {

    var gunSpots = [new FlxPoint(40,24), new FlxPoint(48, 59), new FlxPoint(64, 87), new FlxPoint(64, 113), new FlxPoint(48, 142), new FlxPoint(40, 177)];

    var state:PlayState;
    var bullets:FlxTypedGroup<Bullet>;

    var fireCounter = 1;

    public function new(X:Float=0, Y:Float=0, PlayState:PlayState) {
        super(X, Y);

        this.state = PlayState;

        loadGraphic(AssetPaths.boss__png);

        bullets = new FlxTypedGroup<Bullet>();
        state.add(bullets);
    }

    override public function update():Void {
        super.update();
    }

    public function pulse():Void {
        if (fireCounter%2 == 0){
            fire();
        }

        fireCounter++;
    }

    private function fire():Void {
        var rand = FlxRandom.float();
        var speed = 100;
        for (spot in gunSpots){
            var bullet = new Bullet(this.x + spot.x, this.y + spot.y, speed,  1.5*Math.PI);
            FlxG.log.add("New bullet at " + (this.x + spot.x) + ":" + (this.y + spot.y));
            bullets.add(bullet);
        }
    }
}
