package entities;
import flixel.FlxG;
import openfl.Assets;
import entities.Target.ClickType;
import flixel.group.FlxGroup.FlxTypedGroup;
class TargetManager extends FlxTypedGroup<Target> {

    var targetLines:Array<String>;
    var state:PlayState;

    public function new(LevelFile:String, State:PlayState) {
        super();

        this.state = State;

        parseLevel(LevelFile);

        addTarget(25);
    }

    private function parseLevel(LevelFile:String):Void {
        targetLines = new Array<String>();
        var fileText = Assets.getText(LevelFile);
        targetLines = fileText.split('\n');
    }

    public function addTarget(NumberOfTargets:Int):Void {
        if (NumberOfTargets > targetLines.length){
            NumberOfTargets = targetLines.length;
        }

        for (tar in 0...NumberOfTargets){
            var options = targetLines.shift().split(',');
            if (options[0] != "//"){
                var tar:Target;
                if (options[0] == "right"){
                    tar = new Target(Std.parseFloat(options[1]),Std.parseFloat(options[2]), ClickType.RIGHTCLICK, state);
                } else if (options[0] == "left"){
                    tar = new Target(Std.parseFloat(options[1]),Std.parseFloat(options[2]), ClickType.LEFTCLICK, state);
                } else if (options[0] == "both") {
                    tar = new Target(Std.parseFloat(options[1]),Std.parseFloat(options[2]), ClickType.BOTHCLICK, state);
                } else {
                    tar = new Target(Std.parseFloat(options[1]),Std.parseFloat(options[2]), ClickType.RANDOM, state);
                }

                tar.setTimes(Std.parseFloat(options[3]), Std.parseFloat(options[4]), state.bpm/1.5);
                this.add(tar);
            }
        }

        FlxG.watch.addQuick("Number of Lines left", targetLines.length);
    }
}
