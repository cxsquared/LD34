package;

import flixel.util.FlxColor;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
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
    public var bpm = .5;

    var startText:FlxText;
    var startTimer:FlxTimer;

    public var score = 0;
    var scoreText:FlxText;
    var isLevelDone = false;

	/**
	 * Function that is called up when to state is created to set it up. 
	 */
	override public function create():Void
	{
		super.create();

        var background = new FlxSprite(0, 0, AssetPaths.background__png);
        add(background);

        startText = new FlxText(0,0,0,72);
        startText.text = "3";
        startText.color = FlxColor.GRAY;
        startText.setFormat("assets/data/BebasNeue.ttf", 72, FlxColor.GRAY, "center");
        startText.x = FlxG.width/2 - startText.width/2;
        startText.y = FlxG.height/2 - startText.height/2;
        add(startText);

        scoreText = new FlxText(0,0,0,36);
        scoreText.text = "0";
        scoreText.x = FlxG.width/2 - scoreText.width/2;
        scoreText.y = 5;
        scoreText.setFormat("assets/data/BebasNeue.ttf", 36, FlxColor.GRAY, "center");
        scoreText.color = FlxColor.GRAY;
        add(scoreText);

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
        musicTrack.loadEmbedded(AssetPaths.LD34Mix01_01__mp3, false, false, onSongEnd);
        musicTrack.play();
        startPulse();
    }

    private function onSongEnd():Void {
        var endText = new FlxText(0,0,0,32);
        endText.text = "Level Finished";
        endText.color = FlxColor.GRAY;
        endText.alpha = 0;
        endText.setFormat("assets/data/BebasNeue.ttf", 32, FlxColor.GRAY, "center");
        FlxTween.tween(endText, {alpha:1}, 1);
        add(endText);
        endText.x = FlxG.width/2 - endText.width/2 - 55;
        endText.y = FlxG.height/2 - endText.height - endText.height/2 - 10;

        scoreText.y = FlxG.height/2 - scoreText.height/2;
        scoreText.alpha = 0;
        FlxTween.tween(scoreText, {alpha:1}, 1);

        var endText2 = new FlxText(0,0,0,32);
        endText2.color = FlxColor.GRAY;
        endText2.text = "Click to Restart";
        endText2.alpha = 0;
        endText2.setFormat("assets/data/BebasNeue.ttf", 32, FlxColor.GRAY, "center");
        FlxTween.tween(endText2, {alpha:1}, 1, {complete:function(tween:FlxTween):Void {
            isLevelDone = true;
        }});
        add(endText2);
        endText2.x = FlxG.width/2 - endText2.width/2 - 60;
        endText2.y = FlxG.height/2 + endText2.height/2 + 10;
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

        scoreText.text = Std.string(score);

        if (startText.alive && startTimer.active) {
            startText.text = Std.string(Math.ceil(startTimer.timeLeft));
        }

        if (isLevelDone && FlxG.mouse.justPressed){
            FlxG.switchState(new MenuState());
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
        var prePulseTimer = new FlxTimer();
        prePulseTimer.start(0.25, function(timer:FlxTimer):Void{
            pulseTimer.start(bpm, onPulse, 0);
        }, 1);
    }

    private function onPulse(timer:FlxTimer):Void {
        targets.callAll("pulse");
        scoreText.scale.set(1.15, 1.15);
        FlxTween.tween(scoreText.scale, {x:1, y:1}, bpm/2, {ease:FlxEase.expoOut});
    }

    private function parseTargets(file:String):Void {
        var fileText = Assets.getText(file);
        for (line in fileText.split('\n')) {
            var options = line.split(',');
            if (options[0] != "//"){
                var tar:Target;
                if (options[0] == "right"){
                    tar = new Target(Std.parseFloat(options[1]),Std.parseFloat(options[2]), ClickType.RIGHTCLICK, this);
                } else if (options[0] == "left"){
                    tar = new Target(Std.parseFloat(options[1]),Std.parseFloat(options[2]), ClickType.LEFTCLICK, this);
                } else if (options[0] == "both") {
                    tar = new Target(Std.parseFloat(options[1]),Std.parseFloat(options[2]), ClickType.BOTHCLICK, this);
                } else {
                    tar = new Target(Std.parseFloat(options[1]),Std.parseFloat(options[2]), ClickType.RANDOM, this);
                }

                tar.setTimes(Std.parseFloat(options[3]), Std.parseFloat(options[4]), bpm/1.5);
                targets.add(tar);
            }
        }
    }
}