package entities;
import flixel.util.FlxColorUtil;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.weapon.FlxBullet;
class Bullet extends FlxSprite {

    var speed:Float;
    var dir:Float;

    public function new(X:Float, Y:Float, Speed:Float, Dir:Float) {
        super(X, Y);
        this.speed = Speed;
        this.dir = Dir;
        makeGraphic(8,4,FlxColorUtil.getRandomColor());
    }

    override public function update():Void {
        super.update();
        if (this.x > FlxG.width || this.x < 0 || this.y > FlxG.height || this.y < 0){
            this.kill();
        }

        this.x += speed * Math.sin(dir) * FlxG.elapsed;
        this.y += speed * Math.cos(dir) * FlxG.elapsed;

        FlxG.watch.addQuick("Bullet X", x);
        FlxG.watch.addQuick("Bullet y", y);
    }
}
