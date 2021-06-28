package;

import flixel.util.FlxTimer;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.math.FlxMath;

/**
 * A FlxState which can be used for the game's menu.
 */
class MenuState extends FlxState
{
    var title:FlxText;
    var instructions:FlxText;
    var twitter:FlxText;

	/**
	 * Function that is called up when to state is created to set it up. 
	 */
	override public function create():Void
	{
		super.create();

        FlxG.mouse.visible = true;

        var background = new FlxSprite(0,0, AssetPaths.background__png);
        add(background);

        FlxG.sound.playMusic(AssetPaths.LD34IntroLoop_01__mp3);

        title = new FlxText(0,0,0,48);
        title.color = FlxColor.GRAY;
        title.text = "Duality";
        title.y = 100;
        title.x = FlxG.width/2 - title.width/2 - 57;
        title.alpha = 0;
        title.setFormat("assets/data/BebasNeue.ttf", 48, FlxColor.GRAY, "center");
        FlxTween.tween(title, {alpha:1}, 1);
        add(title);

        instructions = new FlxText(0,0,0,32);
        instructions.color = FlxColor.GRAY;
        instructions.text = "Click to Start";
        instructions.y = FlxG.height/2 + 50;
        instructions.x = FlxG.width/2 - instructions.width/2 - 75;
        instructions.alpha = 0;
        instructions.setFormat("assets/data/BebasNeue.ttf", 32, FlxColor.GRAY, "center");
        FlxTween.tween(instructions, {alpha:1}, 1.5);
        add(instructions);

        twitter = new FlxText(0,0,0,32);
        twitter.color = FlxColor.GRAY;
        twitter.text = "@Cxsquared";
        twitter.y = FlxG.height - twitter.height - 10;
        twitter.x = 10;
        twitter.alpha = 0;
        twitter.setFormat("assets/data/BebasNeue.ttf", 32, FlxColor.GRAY, "center");
        FlxTween.tween(twitter, {alpha:1}, 2);
        add(twitter);
	}
	
	/**
	 * Function that is called when this state is destroyed - you might want to 
	 * consider setting all objects this state uses to null to help garbage collection.
	 */
	override public function destroy():Void
	{
		super.destroy();
	}

	/**
	 * Function that is called once every frame.
	 */
	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);

        if (FlxG.mouse.justPressed){
            FlxTween.tween(title, {alpha:0}, 2, {onComplete:function(tween:FlxTween):Void {
                FlxG.sound.music.stop();
                FlxG.sound.music.volume = 1;
                FlxG.switchState(new PlayState());
            }});
            FlxTween.tween(FlxG.sound.music, {volume:0}, 2);
            FlxTween.tween(instructions, {alpha:0}, 1.5);
            FlxTween.tween(twitter, {alpha:0}, 1);
        }
	}	
}