package;

import StageData;
import flixel.FlxBasic;
import flixel.FlxG;
import flixel.util.FlxColor;
import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;

using StringTools;

class Stage extends FlxTypedGroup<FlxBasic>
{
    public var curStage = '';
    public var gfVersion:String = 'gf';

    public static var contents:Stage;

    public var songName:String = null;

    public var foregroundSprites:FlxTypedGroup<BGSprite>;

    public var stripes:BGSprite;
    
    public function new(curStage:String)
    {
        super();
        this.curStage = curStage;

        songName = Paths.formatToSongPath(PlayState.SONG.song);

        if(PlayState.SONG.stage == null || PlayState.SONG.stage.length < 1)
        {
			switch (songName)
			{
				default:
					curStage = 'stage';
			}
		}
		PlayState.SONG.stage = curStage;

        foregroundSprites = new FlxTypedGroup<BGSprite>();

        switch (curStage)
        {
            case 'stage': //balls
                var bg:BGSprite = new BGSprite('backgrounds/stage/stageback', -600, -200, 0.9, 0.9);
                add(bg);

                var stageFront:BGSprite = new BGSprite('backgrounds/stage/stagefront', -650, 600, 0.9, 0.9);
                stageFront.setGraphicSize(Std.int(stageFront.width * 1.1));
                stageFront.updateHitbox();
                add(stageFront);

            case 'blank':
                var blank:FlxSprite = new FlxSprite(-800, -575).makeGraphic(Std.int(FlxG.width * 5), Std.int(FlxG.height * 5), FlxColor.WHITE);
				blank.scrollFactor.set(0, 0);
				add(blank);
            case 'end':
                stripes = new BGSprite('stages/bridge/stripes', -3000, -650, 0, 0);
                FlxTween.tween(stripes, {x: -1200}, 15, {type: FlxTween.PINGPONG, ease: FlxEase.sineInOut});
                stripes.alpha = 0;
                add(stripes);
            
            case 'end2':
                stripes = new BGSprite('stages/bridge/stripes', -3000, -650, 0, 0);
                FlxTween.tween(stripes, {x: -1200}, 15, {type: FlxTween.PINGPONG, ease: FlxEase.sineInOut});
                add(stripes);

            
            case 'bridge':
                var bg:BGSprite = new BGSprite('stages/bridge/sky', -1300, -450, 0.4, 0.2);
                add(bg);

                var mountains:BGSprite = new BGSprite('stages/bridge/mtns', -1300, -450, 0.6, 0.5);
                add(mountains);

                var ground:BGSprite = new BGSprite('stages/bridge/grnd', -1300, -450, 1, 1);
                add(ground);

                var shn:BGSprite = new BGSprite('stages/bridge/glow', -1300, -450, 0.4, 0.2);
                shn.alpha = 0.5;
                add(shn);
            case 'sunset':
                var bg:BGSprite = new BGSprite('stages/sunset/sky', -1300, -450, 0.4, 0.2);
                add(bg);

                var mountains:BGSprite = new BGSprite('stages/sunset/mtns', -1300, -450, 0.6, 0.5);
                add(mountains);

                var ground:BGSprite = new BGSprite('stages/sunset/grnd', -1300, -450, 1, 1);
                add(ground);

                var shn:BGSprite = new BGSprite('stages/sunset/glow', -1300, -450, 0.4, 0.2);
                shn.alpha = 0.5;
                add(shn);
            case 'night':
                var bg:BGSprite = new BGSprite('stages/night/sky', -1300, -450, 0.4, 0.2);
                add(bg);

                var mountains:BGSprite = new BGSprite('stages/night/mtns', -1300, -450, 0.6, 0.5);
                add(mountains);

                var ground:BGSprite = new BGSprite('stages/night/grnd', -1300, -450, 1, 1);
                add(ground);

                var shn:BGSprite = new BGSprite('stages/night/glow', -1300, -450, 0.4, 0.2);
                shn.alpha = 0.5;
                add(shn);
        }
    }

    public function returnGFtype(curStage)
    {
        gfVersion = PlayState.SONG.gfVersion;

        if(gfVersion == null || gfVersion.length < 1)
        {
            switch (curStage)
            {
                default:
                    gfVersion = 'speaker';
            }
            PlayState.SONG.gfVersion = gfVersion; //chart shit fix
        }

        return gfVersion;
    }

    public function stageUpdate(curBeat:Int, boyfriend:Boyfriend, gf:Character, dad:Character)
    {
        switch (curStage)
		{
			case 'blah':
                //
		}
    }

    public function stageUpdateConst(elapsed:Float, boyfriend:Boyfriend, gf:Character, dad:Character)
    {
        switch (curStage)
		{
			case 'blah':
                //
		}
    }
}