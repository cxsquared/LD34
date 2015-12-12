package;

import flixel.text.FlxText;
import openfl.Assets;
import flixel.FlxSprite;
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

    var startText:FlxText;
    var startTimer:FlxTimer;

	/**
	 * Function that is called up when to state is created to set it up. 
	 */
	override public function create():Void
	{
		super.create();

        var background = new FlxSprite(0, 0, AssetPaths.background__png);
        add(background);

        startText = new FlxText(0,0, 0, 24);
        startText.text = "3";
        startText.x = FlxG.width/2 - startText.width/2;
        startText.y = FlxG.height/2 - startText.height/2;
        add(startText);

        musicTrack = new FlxSound();
        FlxG.sound.music = musicTrack;

        targets = new FlxTypedGroup<Target>();
        parseTargets('assets/data/level00.txt');
        add(targets);

        startTimer = new FlxTimer();
        startTimer.start(3, startLevel, 1);
	}

    private function startLevel(timer:FlxTimer):Void {
        startText.kill();
        FlxG.sound.playMusic(AssetPaths.LD34Mix01_01__mp3, 1, false);
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

        if (startText.alive && startTimer.active) {
            startText.text = Std.string(Math.ceil(startTimer.timeLeft));
        }

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

    private function parseTargets(file:String):Void {
        var fileText = Assets.getText(file);
        for (line in fileText.split('\n')) {
            var options = line.split(',');
            if (options[0] != "//"){
                var tar:Target;
                if (options[0] == "right"){
                    tar = new Target(Std.parseFloat(options[1]),Std.parseFloat(options[2]), ClickType.RIGHTCLICK, bpm);
                } else if (options[0] == "left"){
                    tar = new Target(Std.parseFloat(options[1]),Std.parseFloat(options[2]), ClickType.LEFTCLICK, bpm);
                } else if (options[0] == "both") {
                    tar = new Target(Std.parseFloat(options[1]),Std.parseFloat(options[2]), ClickType.BOTHCLICK, bpm);
                } else {
                    tar = new Target(Std.parseFloat(options[1]),Std.parseFloat(options[2]), ClickType.RANDOM, bpm);
                }

                tar.setTimes(Std.parseFloat(options[3]), Std.parseFloat(options[4]), bpm/2);
                targets.add(tar);
            }
        }
    }
}