package;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.tweens.FlxTween;

class LanguageState extends MusicBeatState
{
	var selectedSomethin:Bool = false;
    var warn:Bool = false;
	var curSelected:Int = 0;
	var options:Array<String> = ["portugues", "english"];
	var daButtons:Array<FlxText> = [];

    var warnText:FlxText;
    var fieldOffset:Float = 0;

	override function create()
	{
		super.create();
		
		for(i in 0...options.length)
		{
			var daText:FlxText = new FlxText(40, 40, 1180, options[i].toUpperCase(), 36);
			daText.setFormat(Paths.font("vcr.ttf"), 36, FlxColor.WHITE, CENTER);
			daText.setBorderStyle(OUTLINE, FlxColor.BLACK, 1.5);
			daText.antialiasing = true;

			daText.x = Math.floor((FlxG.width / 2) - (daText.width / 2));
			daText.y = Math.floor((FlxG.height / 2) - (daText.height / 2));
			
			daText.y += (i == 0) ? 15 : -15;
			
			daText.ID = i;
			daButtons.push(daText);
			add(daText);
		}

        warnText = new FlxText(0, 0, FlxG.width - fieldOffset, "", 32);
		warnText.setFormat(Paths.font("vcr.ttf"), 32, FlxColor.WHITE, CENTER);
		warnText.screenCenter();
		warnText.alpha = 0;
		add(warnText);
	}

	override function update(elapsed:Float)
	{
		if(!selectedSomethin)
		{
			if(controls.ACCEPT) {
                if (warn) {
                    gotoGame();
                }
                else {
                    ClientPrefs.lang = options[curSelected];
                    ClientPrefs.saveSettings();
                    FlxG.sound.play(Paths.sound('confirmMenu'));

                    warn = true;

                    if (options[curSelected] == 'english') {
                        warnText.text = 'Hey, this mod contains intensive shaders and flashing lights.'
                        + "\nIf you are experiencing lag, crashes or are photosensitive,"
                        + "\nplease consider disabling them in the Options Menu."
                        + "\n"
                        + "\nPress ENTER to continue.";
                    }
                    else {
                        warnText.text = 'Este mod tem luzes que piscam e shaders intensos.'
                        + "\nSe tiveres lag ou tiveres problemas de fotossensitividade,"
                        + "\ndesliga-os nas opções."
                        + "\n"
                        + "\nPrime ENTER para continuar.";
                    }

                    for(i in daButtons)
                        FlxTween.tween(i, {alpha: 0}, 0.4);

                    FlxTween.tween(warnText, {alpha: 1}, 0.8);
                }
            }

			
			if(controls.UI_UP_P || controls.UI_DOWN_P)
				changeSelection();
		}
		
        if(!warn) {
            for(i in daButtons)
                i.alpha = (i.ID == curSelected) ? 1 : 0.7;
        }

	}

	function gotoGame()
	{
		selectedSomethin = true;
		FlxG.sound.play(Paths.sound('cancelMenu'));
	
        FlxG.sound.play(Paths.sound('confirmMenu'));
		
		MusicBeatState.switchState(new TitleState());
	}
	
	function changeSelection()
	{
		curSelected++;
		
		FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);
		
		if(curSelected < 0)
		   curSelected = options.length - 1;
		if(curSelected > options.length - 1)
		   curSelected = 0;
	}
}