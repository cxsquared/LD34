package;

import flash.display.Sprite;
import flixel.text.FlxTextField;
import flixel.group.FlxTypedGroup;
import flixel.util.FlxCollision;
import flixel.util.FlxColor;
import flixel.plugin.MouseEventManager;
import flixel.addons.plugin.FlxMouseControl;
import flixel.interfaces.IFlxInput;
import flixel.input.mouse.FlxMouse;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxMath;

/**
 * A FlxState which can be used for the actual gameplay.
 */
class PlayState extends FlxState
{

    var square:FlxSprite;
    var targets:FlxTypedGroup<FlxSprite>;

	/**
	 * Function that is called up when to state is created to set it up. 
	 */
	override public function create():Void
	{
		super.create();

		square = new FlxSprite();
        square.makeGraphic(100, 100);
        square.x = FlxG.width/2 - square.width/2;
        square.y = FlxG.height/2 - square.height/2;

        targets = new FlxTypedGroup<FlxSprite>();
        targets.add(square);

        add(targets);

	}

    private function CheckTargets():Void {
        for (spr in targets){
            if (FlxCollision.pixelPerfectPointCheck(Std.int(FlxG.mouse.x), Std.int(FlxG.mouse.y), spr)){
                if (FlxG.mouse.justPressed && FlxG.mouse.justPressedRight){
                    spr.color = FlxColor.RED;
                } else if (FlxG.mouse.justPressed){
                    spr.color = FlxColor.BLUE;
                } else if (FlxG.mouse.justPressedRight){
                    spr.color = FlxColor.GREEN;
                }
            }
        }
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
	override public function update():Void
	{
		super.update();

        CheckTargets();

        FlxG.watch.addQuick("Mouse over", FlxCollision.pixelPerfectPointCheck(Std.int(FlxG.mouse.x), Std.int(FlxG.mouse.y), square));

        FlxG.watch.addQuick("Left Click", FlxG.mouse.justPressed);
        FlxG.watch.addQuick("Right Click", FlxG.mouse.justPressedRight);
        FlxG.watch.addQuick("Middle Click", FlxG.mouse.justPressedMiddle);
    }
}