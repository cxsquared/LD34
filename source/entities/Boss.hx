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
    public var bullets:FlxTypedGroup<Bullet>;

    var fireCounter = 1;

    var dir = 1;
    var speed = 100;

    public function new(X:Float=0, Y:Float=0, PlayState:PlayState) {
        super(X, Y);

        this.state = PlayState;

        loadGraphic(AssetPaths.boss__png);

        bullets = new FlxTypedGroup<Bullet>();
        state.add(bullets);
    }

    override public function update():Void {
        super.update();

        this.y += speed * FlxG.elapsed * dir;

        if (this.y + this.height > FlxG.height || this.y < 0 ) {
            dir = dir * -1;
        }
    }

    public function pulse():Void {
        if (fireCounter%2 == 0){
            fire();
            if (FlxRandom.chanceRoll(33)){
                dir *= -1;
            }
        }

        fireCounter++;
    }

    private function fire():Void {
        var rand = FlxRandom.float();

        if (rand > .66){
            for (spot in gunSpots){
                var bullet = new Bullet(this.x + spot.x, this.y + spot.y, 100,  1.5*Math.PI);
                FlxG.log.add("New bullet at " + (this.x + spot.x) + ":" + (this.y + spot.y));
                bullets.add(bullet);
            }
        } else if (rand > .33){
            var bullet = new Bullet(this.x + gunSpots[0].x, this.y + gunSpots[0].y, 100,  1.66*Math.PI);
            bullets.add(bullet);

            var bullet = new Bullet(this.x + gunSpots[1].x, this.y + gunSpots[1].y, 100,  1.60*Math.PI);
            bullets.add(bullet);

            var bullet = new Bullet(this.x + gunSpots[2].x, this.y + gunSpots[2].y, 100,  1.55*Math.PI);
            bullets.add(bullet);

            var bullet = new Bullet(this.x + gunSpots[3].x, this.y + gunSpots[3].y, 100,  1.45*Math.PI);
            bullets.add(bullet);

            var bullet = new Bullet(this.x + gunSpots[4].x, this.y + gunSpots[4].y, 100,  1.40*Math.PI);
            bullets.add(bullet);

            var bullet = new Bullet(this.x + gunSpots[5].x, this.y + gunSpots[5].y, 100,  1.33*Math.PI);
            bullets.add(bullet);
        } else {
            var spotCounter = 0;
            for (spot in gunSpots){
                var bullet = new Bullet(this.x + spot.x, this.y + spot.y, 100,  1.5*Math.PI);
                if (spotCounter == 0 || spotCounter == 5){
                    bullet.setSine(true, 1.5, 4);
                } else if (spotCounter == 1 || spotCounter == 4) {
                    bullet.setSine(true, 2, 2);
                }
                FlxG.log.add("New bullet at " + (this.x + spot.x) + ":" + (this.y + spot.y));
                bullets.add(bullet);
                spotCounter++;
            }
        }
    }
}
