package;

import flixel.util.FlxTimer;
import flixel.util.FlxRandom;
import entities.Target;
import flixel.system.FlxSound;
import flixel.group.FlxTypedGroup;
import flixel.util.FlxCollision;
import flixel.input.mouse.FlxMouse;
import flixel.FlxG;
import flixel.FlxState;


/**
 * A FlxState which can be used for the actual gameplay.
 */
class PlayState extends FlxState
{

    var targets:FlxTypedGroup<Target>;
    var musicTrack:FlxSound;
    var bpm = .5;

	/**
	 * Function that is called up when to state is created to set it up. 
	 */
	override public function create():Void
	{
		super.create();

        musicTrack = new FlxSound();
        FlxG.sound.music = musicTrack;
        FlxG.sound.playMusic(AssetPaths.HaxeFlixel_Tutorial_Game__mp3, 1, false);

        targets = new FlxTypedGroup<Target>();

		for(i in 0...4){
            var tar = new Target(FlxRandom.floatRanged(75, FlxG.width-75), FlxRandom.floatRanged(75, FlxG.height-75), ClickType.LEFTCLICK);
            tar.setTimes(5, 10, 5);
            targets.add(tar);
        }

        add(targets);

        startPulse();
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

        updateTargets();

        FlxG.watch.addQuick("Music Time", musicTrack.time/1000);
        FlxG.watch.addQuick("Left Click", FlxG.mouse.justPressed);
        FlxG.watch.addQuick("Right Click", FlxG.mouse.justPressedRight);
        FlxG.watch.addQuick("Middle Click", FlxG.mouse.justPressedMiddle);
    }


    private function updateTargets():Void {
        targets.callAll("updateTime", [musicTrack.time/1000]);

        for (tar in targets){
            if (FlxCollision.pixelPerfectPointCheck(Std.int(FlxG.mouse.x), Std.int(FlxG.mouse.y), tar)){
                if (FlxG.mouse.pressed || FlxG.mouse.pressedRight) {
                    tar.clicked(musicTrack.time/1000);
                }
            }
        }
    }

    private function startPulse():Void {
        var pulseTimer = new FlxTimer();
        pulseTimer.start(bpm, onPulse, 0);
    }

    private function onPulse(timer:FlxTimer):Void {
        targets.callAll("pulse");
    }
}