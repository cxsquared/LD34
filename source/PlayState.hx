package;

import flixel.effects.particles.FlxEmitterExt;
import entities.Explosion;
import entities.Bullet;
import entities.Boss;
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
    var starting:Bool = false;

    public var score = 0;
    var scoreText:FlxText;
    var isLevelDone = false;

    var boss:Boss;
    var player:FlxSprite;

    var bossTriggerTime = 119.75;
    var bossKillTime = 211.71;

    var explosion:FlxEmitterExt;

    var instruct:FlxSprite;
    var instructText:FlxText;

	/**
	 * Function that is called up when to state is created to set it up. 
	 */
	override public function create():Void
	{
		super.create();

        FlxG.mouse.visible = false;

        var background = new FlxSprite(0, 0, AssetPaths.background__png);
        add(background);

        createInstruct();

        musicTrack = new FlxSound();
        FlxG.sound.music = musicTrack;

        targets = new FlxTypedGroup<Target>();
        parseTargets('assets/data/level00.txt');
        add(targets);

        createBoss();

        createPlayer();

        createUI();

        createExplosion();
	}

    private function createInstruct():Void {
        instruct = new FlxSprite(FlxG.width/2-100, FlxG.height-160, AssetPaths.instruct__png);
        instruct.alpha = 0;
        FlxTween.tween(instruct, {alpha:1}, .5);

        instructText = new FlxText(FlxG.width/2-125,FlxG.height-80,0);
        instructText.setFormat("assets/data/BebasNeue.ttf", 32, FlxColor.GRAY, "center");
        instructText.text = "Left Click     Right Click";
        instructText.alpha = 0;
        FlxTween.tween(instructText, {alpha:1}, 1);

        add(instruct);
        add(instructText);

        var instuctTimer = new FlxTimer();
        instuctTimer.start(4, function(timer:FlxTimer):Void {
            startTimer = new FlxTimer();
            startTimer.start(3, startLevel, 1);

            var countdownTimer = new FlxTimer();
            countdownTimer.start(1, countDown, 2);
            FlxG.sound.play("assets/sounds/countdown.wav", 0.25);

            FlxTween.tween(scoreText, {alpha:1}, 1);
            FlxTween.tween(startText, {alpha:1}, .5);
            starting = true;

            FlxTween.tween(instruct, {alpha:0}, .5, {complete:function(tween:FlxTween):Void {
                instruct.kill();
                instructText.kill();
            }});
            FlxTween.tween(instructText, {alpha:0}, .25);
        }, 1);
    }

    private function startLevel(timer:FlxTimer):Void {
        startText.kill();
        musicTrack.loadEmbedded(AssetPaths.LD34Mix01_01__mp3, false, false, onSongEnd);
        musicTrack.play();
        startPulse();
    }

    private function countDown(timer:FlxTimer):Void {
        FlxG.sound.play("assets/sounds/countdown.wav", 0.5);
    }

    private function createExplosion():Void {
        explosion = new FlxEmitterExt();
        explosion.setRotation(0, 360);
        explosion.setMotion(0, 5, 0.2, 360, 200, 1.8);
        explosion.makeParticles("assets/images/red.png", 25, 0, true, 0);
        explosion.setAlpha(1, 1, 0, 0);
        add(explosion);
    }

    private function createBoss():Void {
        boss = new Boss(0,0,this);
        boss.x = FlxG.width - boss.width;
        boss.y = FlxG.height/2 - boss.height/2;
        boss.alpha = 0;
        add(boss);
    }

    private function createPlayer():Void {
        player = new FlxSprite(0,0,AssetPaths.player__png);
        player.scale.set(0.5, 0.5);
        add(player);
    }

    private function createUI():Void {
        startText = new FlxText(0,0,0,72);
        startText.text = "3";
        startText.color = FlxColor.GRAY;
        startText.setFormat("assets/data/BebasNeue.ttf", 72, FlxColor.GRAY, "center");
        startText.x = FlxG.width/2 - startText.width/2;
        startText.y = FlxG.height/2 - startText.height/2;
        startText.alpha = 0;
        add(startText);

        scoreText = new FlxText(0,0,0,36);
        scoreText.text = "0";
        scoreText.x = FlxG.width/2 - scoreText.width/2;
        scoreText.y = 5;
        scoreText.setFormat("assets/data/BebasNeue.ttf", 36, FlxColor.GRAY, "center");
        scoreText.color = FlxColor.GRAY;
        scoreText.alpha = 0;
        add(scoreText);
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

        updateBoss();

        if (starting) {
            if (score < 0){
                score = 0;
            }
            scoreText.text = Std.string(score);

            if (startText.alive && startTimer.active) {
                startText.text = Std.string(Math.ceil(startTimer.timeLeft));
            }
        }

        if (isLevelDone && FlxG.mouse.justPressed){
            FlxG.switchState(new MenuState());
        }

        updatePlayer();

        FlxG.collide(player, boss.bullets, onPlayerCollision);

        FlxG.watch.addQuick("Music Time", musicTrack.time/1000);
        FlxG.watch.addQuick("Left Click", FlxG.mouse.justPressed);
        FlxG.watch.addQuick("Right Click", FlxG.mouse.justPressedRight);
        FlxG.watch.addQuick("Middle Click", FlxG.mouse.justPressedMiddle);
    }

    private function updateBoss():Void {
        if (!boss.shouldDo && bossTriggerTime <= musicTrack.time/1000 && boss.alpha == 0 && boss.alive){
            FlxTween.tween(boss, {alpha:1}, 2, {complete:function(tween:FlxTween):Void {
                boss.shouldDo = true;
            }});
        }

        if (boss.shouldDo && bossKillTime <= musicTrack.time/1000 && boss.alpha == 1) {
            boss.explode();
            boss.shouldDo = false;
            FlxTween.tween(boss, {alpha:0}, 2, {complete:function(tween:FlxTween):Void {
                boss.kill();
            }});
        }
    }

    private function onPlayerCollision(player:FlxSprite, bullet:Bullet):Void {
        score--;
        this.setPlayerScale(-0.05);
        bullet.kill();
        FlxG.camera.shake(0.005, 0.15);
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

    private function updatePlayer():Void {
        player.x = FlxG.mouse.x - player.width/2;
        player.y = FlxG.mouse.y - player.height/2;
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
        boss.pulse();
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

    public function setPlayerScale(IncreaseAmount:Float):Void {
        var newX = player.scale.x + IncreaseAmount;
        var newY = player.scale.y + IncreaseAmount;

        if (newX > 1.25 || newY > 1.2){
            newX = 1.25;
            newY = 1.15;
        } else if (newX < .5 || newY < .5){
            newX = .5;
            newY = .5;
        }

        player.scale.set(newX, newY);
    }

    public function explode(X:Float, Y:Float):Void {
        explosion.x = X;
        explosion.y = Y;
        explosion.start(true, 0.5, .1);
    }
}