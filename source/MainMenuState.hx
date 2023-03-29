package;

#if desktop
import Discord.DiscordClient;
#end
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxCamera;
import flixel.addons.transition.FlxTransitionableState;
import flixel.effects.FlxFlicker;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.math.FlxMath;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import lime.app.Application;
import Achievements;
import editors.MasterEditorMenu;
import flixel.input.keyboard.FlxKey;

using StringTools;

class MainMenuState extends MusicBeatState
{
	public static var psychEngineVersion:String = '0.6.3'; //This is also used for Discord RPC
	public static var curSelected:Int = 0;

	var menuItems:FlxTypedGroup<FlxSprite>;
	
	var optionShit:Array<String> = [
		'jogar',
		'creditos',
		'opcoes'
	];

	var sub:FlxSprite;
	var debugKeys:Array<FlxKey>;

	var suffix:String = '';

	override function create()
	{
		#if MODS_ALLOWED
		Paths.pushGlobalMods();
		#end
		WeekData.loadTheFirstEnabledMod();

		FlxG.mouse.visible = true;
		FlxG.mouse.useSystemCursor = true;
		
		if (ClientPrefs.lang == 'english') suffix = '-en';
		#if desktop
		// Updating Discord Rich Presence
		DiscordClient.changePresence("In the Menus", null);
		#end
		debugKeys = ClientPrefs.copyKey(ClientPrefs.keyBinds.get('debug_1'));

		transIn = FlxTransitionableState.defaultTransIn;
		transOut = FlxTransitionableState.defaultTransOut;

		persistentUpdate = persistentDraw = true;

		var bg:FlxSprite = new FlxSprite(-80).loadGraphic(Paths.image('menu/bg$suffix'));
		bg.updateHitbox();
		bg.screenCenter();
		bg.antialiasing = ClientPrefs.globalAntialiasing;
		add(bg);

		sub = new FlxSprite(1133, 278).loadGraphic(Paths.image('menu/subscribe$suffix'));
		sub.updateHitbox();
		//sub.screenCenter();
		sub.antialiasing = ClientPrefs.globalAntialiasing;
		add(sub);
		
		// magenta.scrollFactor.set();

		menuItems = new FlxTypedGroup<FlxSprite>();
		add(menuItems);

		var scale:Float = 1;
		/*if(optionShit.length > 6) {
			scale = 6 / optionShit.length;
		}*/

		for (i in 0...optionShit.length)
		{
			var menuItem:FlxSprite = new FlxSprite((i * 210) + 30, 460).loadGraphic(Paths.image('menu/' + optionShit[i] + suffix));
			menuItem.ID = i;
			menuItems.add(menuItem);
			menuItem.antialiasing = ClientPrefs.globalAntialiasing;
			//menuItem.setGraphicSize(Std.int(menuItem.width * 0.58));
			menuItem.updateHitbox();
		}

		var versionShit:FlxText = new FlxText(12, FlxG.height - 44, 0, "Psych Engine v" + psychEngineVersion, 12);
		versionShit.scrollFactor.set();
		versionShit.setFormat("VCR OSD Mono", 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		//add(versionShit);
		var versionShit:FlxText = new FlxText(12, FlxG.height - 24, 0, "Friday Night Funkin' v" + Application.current.meta.get('version'), 12);
		versionShit.scrollFactor.set();
		versionShit.setFormat("VCR OSD Mono", 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		//add(versionShit);

		// NG.core.calls.event.logEvent('swag').send();

		changeItem();

		super.create();
	}

	var selectedSomethin:Bool = false;

	override function update(elapsed:Float)
	{
		if (FlxG.sound.music.volume < 0.8)
		{
			FlxG.sound.music.volume += 0.5 * FlxG.elapsed;
			if(FreeplayState.vocals != null) FreeplayState.vocals.volume += 0.5 * elapsed;
		}

		if (!selectedSomethin)
		{
			if (controls.BACK)
			{
				selectedSomethin = true;
				FlxG.sound.play(Paths.sound('cancelMenu'));
				MusicBeatState.switchState(new TitleState());
			}

			menuItems.forEach(function(spr:FlxSprite)
			{
				var daChoice = optionShit[spr.ID];
				if(FlxG.mouse.overlaps(spr)){
					if(FlxG.mouse.justPressed){
						selectedSomethin = true;
						FlxG.sound.play(Paths.sound("confirmMenu"), 1.5);
						//FlxG.camera.fade(FlxColor.WHITE,1);
						FlxFlicker.flicker(spr, .5, 0.06, false, false, function(flick:FlxFlicker)
						{
							switch (daChoice)
							{
								case 'jogar':
									MusicBeatState.switchState(new StoryMenuState());
								case 'creditos':
									MusicBeatState.switchState(new CreditsState());
								case 'opcoes':
									LoadingState.loadAndSwitchState(new options.OptionsState());
							}
						});
					}
				}
			});

			if(FlxG.mouse.overlaps(sub)){
				if(FlxG.mouse.justPressed){
					FlxG.sound.play(Paths.sound("confirmMenu"), 1.5);
					FlxFlicker.flicker(sub, 1, 0.05, false, false, function(flick:FlxFlicker)
					{
						var poop:String = Highscore.formatSong('info', 1);

						PlayState.SONG = Song.loadFromJson(poop, 'info');
						PlayState.isStoryMode = false;
						PlayState.storyDifficulty = 1;

						LoadingState.loadAndSwitchState(new PlayState());
					});
				}
			}

			#if desktop
			if (FlxG.keys.anyJustPressed(debugKeys))
			{
				selectedSomethin = true;
				MusicBeatState.switchState(new MasterEditorMenu());
			}
			#end
		}

		super.update(elapsed);
	}

	function changeItem(huh:Int = 0)
	{
		curSelected += huh;

		if (curSelected >= menuItems.length)
			curSelected = 0;
		if (curSelected < 0)
			curSelected = menuItems.length - 1;

		menuItems.forEach(function(spr:FlxSprite)
		{
			spr.updateHitbox();

			if (spr.ID == curSelected)
			{
				var add:Float = 0;
				if(menuItems.length > 4) {
					add = menuItems.length * 8;
				}
				spr.centerOffsets();
			}
		});
	}
}
