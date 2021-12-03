import appropos.Appropos;
import h2d.Bitmap;
import h2d.Flow;
import h2d.Tile;
import particles.ParticleSystem;
import particles.loaders.ParticleLoader;

using StringTools;

@:publicFields
class Main extends hxd.App {
	var container:Flow;
	var bg:Bg;
	var tiles:Array<{name:String, tile:h2d.Tile}>;
	var index:UInt = 0;
	var randomIndices:Array<UInt>;
	var optionsFlow:Flow;
	var bitmap:h2d.Bitmap;
	var applause:h2d.Bitmap;
	var w:UInt;
	var h:UInt;

	var positions:{
		var bitmap:h2d.col.Point;
		var option1:h2d.col.Point;
		var option2:h2d.col.Point;
		var option3:h2d.col.Point;
	}

	var option1:InteractiveText;
	var option2:InteractiveText;
	var option3:InteractiveText;
	var end:h2d.Object;

	var partSystem:ParticleSystem;
	var waitEvent:hxd.WaitEvent;

	@:v('title:TITLE')
	var title:String;

	@:v('photos-dir:photos')
	var photosDir:String;

	@:v('ending-text:Success')
	var endingText:String;

	@:v('ending-text.x-pos-percentage:0')
	var endingTextXPosPercent:Float;

	@:v('ending-text.y-pos-percentage:0')
	var endingTextYPosPercent:Float;

	@:v('applause.show-time:1.5')
	var applauseShowTime:Float;

	@:v('applause.start-scale:0.8')
	var applauseStartScale:Float;

	@:v('applause.end-scale:1.5')
	var applauseEndScale:Float;

	@:v('fullscreen:false')
	var initFullscreen:Bool;
	var isFullscreen:Bool;

	static var inst:Main;

	override function init() {
		Appropos.init();

		inst = this;

		h3d.Engine.getCurrent().backgroundColor = 0xff912691;
		isFullscreen = initFullscreen;
		#if hl
		engine.fullScreen = initFullscreen;
		#end

		try {
			hxd.Res.music.play(true);
		} catch (nf:hxd.res.NotFound) {
			trace('Music file not found.');
		}

		waitEvent = new hxd.WaitEvent();

		w = hxd.Window.getInstance().width;
		h = hxd.Window.getInstance().height;

		bg = new Bg(w, h, s2d);

		var applauseTile = hxd.Res.applause.toTile();
		applause = new h2d.Bitmap(applauseTile.center());
		applause.scale((h * .5) / applauseTile.height);
		applause.x = w * .5;
		applause.y = h * .5;

		var font = hxd.Res.font.toSdfFont(Std.int(h * .08), 3);

		container = new h2d.Flow(s2d);
		container.layout = Vertical;
		container.verticalSpacing = Std.int(h * .05);

		var titleFlow = new h2d.Flow(container);
		titleFlow.layout = Horizontal;
		titleFlow.horizontalSpacing = 20;
		titleFlow.verticalAlign = Middle;
		try {
			var logoTile = hxd.Res.logo.toTile();
			new h2d.Bitmap(logoTile, titleFlow).setScale(h * .15 / logoTile.height);
		} catch (nf:hxd.res.NotFound) {
			trace('Logo not found.');
		}
		var tf = new h2d.Text(font, titleFlow);
		tf.text = title.replace("\\n", "\n");

		tiles = [
			for (anyRes in hxd.Res.loader.dir(photosDir))
				{
					name: haxe.io.Path.withoutExtension(anyRes.name).toUpperCase(),
					tile: anyRes.toTile()
				}
		];

		for (t in tiles)
			t.tile.scaleToSize(w * .3, w * .3);

		randomIndices = [for (i in 0...tiles.length) i];

		var gameFlow = new h2d.Flow(container);
		gameFlow.backgroundTile = h2d.Tile.fromColor(0x333333, Std.int(w * .8), Std.int(h * .8), .3);
		gameFlow.layout = Horizontal;
		gameFlow.padding = 20;
		gameFlow.horizontalSpacing = Std.int(w * .1);

		bitmap = new Bitmap(tiles[index].tile, gameFlow);
		var mask = new h2d.Graphics(bitmap);
		mask.beginFill(Std.int(hxd.Math.random(0xffffff)));
		var r = bitmap.tile.width * .5;
		mask.drawCircle(r, r, r);
		bitmap.filter = new h2d.filter.Mask(mask);

		optionsFlow = new h2d.Flow(gameFlow);
		optionsFlow.layout = Vertical;
		optionsFlow.verticalSpacing = Std.int(tileHeight(bitmap) * .08);
		optionsFlow.padding = 10;
		optionsFlow.paddingRight = Std.int(w * .08);

		var tw = Std.int(w * .5);
		var th = Std.int(tileHeight(bitmap) * .25);

		option1 = new InteractiveText(font, tw, th, optionsFlow);
		option2 = new InteractiveText(font, tw, th, optionsFlow);
		option3 = new InteractiveText(font, tw, th, optionsFlow);

		end = new h2d.Object();
		var endTile = hxd.Res.end.toTile().center();
		var endBmp = new h2d.Bitmap(endTile, end);
		endBmp.scale((h * .5) / endTile.height);
		tw = Std.int(w * .7);
		var endText = new InteractiveText(hxd.Res.font.toSdfFont(Std.int(h * .077), 3), tw, th, false, end, () -> {
			Artean.simple(.5, 1, 0, (f, p) -> {
				end.alpha = f;
				if (p == 1.) {
					end.remove();
					randomize();
					next();
				}
			});
		});
		endText.text = endingText.replace("\\n", "\n");
		endText.tf.color = new h3d.Vector();
		var tileW = endTile.width * endBmp.scaleX;
		var tileH = endTile.height * endBmp.scaleY;
		endText.x = (-tileW * .5) + tileW * (endingTextXPosPercent / 100) - endText.tf.textWidth * .5;
		endText.y = (-tileH * .5) + tileH * (endingTextYPosPercent / 100) - endText.tf.textHeight * .5;
		endText.interactive.width = endText.tf.textWidth;
		endText.interactive.height = endText.tf.textHeight;
		endText.interactive.x = endText.tf.x;
		endText.interactive.y = endText.tf.y;
		end.x = w * .5;
		end.y = h * .5;

		positions = {
			bitmap: new h2d.col.Point(bitmap.x + 20, bitmap.y),
			option1: new h2d.col.Point(option1.x, option1.y),
			option2: new h2d.col.Point(option2.x, option2.y),
			option3: new h2d.col.Point(option3.x, option3.y),
		};

		partSystem = new ParticleSystem(s2d);
		var bubPg = ParticleLoader.load('parts/emitter.pixi');
		bubPg.tile = hxd.Res.parts.Bubbles50px.toTile();
		var firePg = ParticleLoader.load('parts/emitter.pixi');
		firePg.tile = hxd.Res.parts.Fire.toTile();
		var rainPg = ParticleLoader.load('parts/emitter.pixi');
		rainPg.tile = hxd.Res.parts.HardRain.toTile();
		var partPg = ParticleLoader.load('parts/emitter.pixi');
		partPg.tile = hxd.Res.parts.particle.toTile();
		var smokePg = ParticleLoader.load('parts/emitter.pixi');
		smokePg.tile = hxd.Res.parts.smokeparticle.toTile();
		var sparkPg = ParticleLoader.load('parts/emitter.pixi');
		sparkPg.tile = hxd.Res.parts.Sparks.toTile();
		partSystem.addParticleGroup(bubPg);
		partSystem.addParticleGroup(firePg);
		partSystem.addParticleGroup(rainPg);
		partSystem.addParticleGroup(partPg);
		partSystem.addParticleGroup(smokePg);
		partSystem.addParticleGroup(sparkPg);

		bitmap.x = -tileWidth(bitmap) * 1.1;
		option1.x = w + 10;
		option2.x = w + 10;
		option3.x = w + 10;

		randomize();
		next();

		onResize();
	}

	override function onResize() {
		super.onResize();

		w = hxd.Window.getInstance().width;
		h = hxd.Window.getInstance().height;

		bg.paint(w, h);

		var endW = end.getSize().width / end.scaleX;
		end.setScale((w * .65) / endW);
		end.x = w * .5;
		end.y = h * .5;

		applause.scale((h * .5) / applause.tile.height);
		applause.x = w * .5;
		applause.y = h * .5;

		var size = container.getSize();
		var sizeW = size.width / container.scaleX;
		var sizeH = size.height / container.scaleY;
		var scale = .95 * w / sizeW;
		container.setScale(scale);
		container.x = (w - sizeW * scale) * .5;
		container.y = (h - sizeH * scale) * .3;
	}

	inline function tileWidth(b:h2d.Bitmap)
		return b.tile.width * b.scaleX;

	inline function tileHeight(b:h2d.Bitmap)
		return b.tile.height * b.scaleY;

	function hide(?cb:Void->Void) {
		Artean.simple(1, bitmap.x, -tileWidth(bitmap) * 1.1, (f, p) -> {
			bitmap.x = f;
			bitmap.alpha = 1. - p;
		});
		Artean.simple(1, option1.x, w + 10, (f, p) -> {
			option1.x = f;
			option1.alpha = 1. - p;
		});
		Artean.simple(1, option2.x, w + 10, (f, p) -> {
			option2.x = f;
			option2.alpha = 1. - p;
		});
		Artean.simple(1, option3.x, w + 10, (f, p) -> {
			option3.x = f;
			option3.alpha = 1. - p;
			if (p == 1 && cb != null) {
				cb();
			}
		});
	}

	function show() {
		Artean.simple(1, bitmap.x, positions.bitmap.x, (f, p) -> {
			bitmap.x = f;
			bitmap.alpha = p;
		});
		Artean.simple(1, option1.x, positions.option1.x, (f, p) -> {
			option1.x = f;
			option1.alpha = p;
		});
		Artean.simple(1, option2.x, positions.option2.x, (f, p) -> {
			option2.x = f;
			option2.alpha = p;
		});
		Artean.simple(1, option3.x, positions.option3.x, (f, p) -> {
			option3.x = f;
			option3.alpha = p;
		});
	}

	function next() {
		hide(() -> {
			var rndIndex = randomIndices[index];
			bitmap.tile = tiles[rndIndex].tile;

			var tilesLength = tiles.length;

			var randomOptions = [];
			inline function rndInd() {
				var optionInd = Std.int(hxd.Math.random(tilesLength));
				while (randomOptions.indexOf(optionInd) != -1 || optionInd == rndIndex)
					optionInd = Std.int(hxd.Math.random(tilesLength));
				return optionInd;
			}

			randomOptions.push(rndInd());
			randomOptions.push(rndInd());
			var opts = [getCurrentName(), tiles[randomOptions[0]].name, tiles[randomOptions[1]].name];

			hxd.Math.shuffle(opts);

			option1.text = opts[0];
			option2.text = opts[1];
			option3.text = opts[2];

			show();
		});
	}

	function randomize() {
		index = 0;
		hxd.Math.shuffle(randomIndices);
	}

	function getCurrentName() {
		return tiles[randomIndices[index]].name;
	}

	function correctAnswerClicked(px:Float, py:Float) {
		partSystem.x = px;
		partSystem.y = py;

		partSystem.stop();
		partSystem.start();

		applause.alpha = 0;
		s2d.addChild(applause);
		Artean.simple(applauseShowTime, applauseStartScale, applauseEndScale, (d, p) -> {
			applause.setScale(d);
			applause.alpha = p;
			if (p == 1) {
				applause.remove();
			}
		});

		haxe.Timer.delay(() -> onCorrect(), 1500);
	}

	function onCorrect() {
		index++;
		if (index >= tiles.length) {
			hide();
			end.alpha = 0;
			s2d.addChild(end);
			Artean.simple(.5, 0, 1, (f, p) -> end.alpha = f);
		} else
			next();
	}

	override function update(dt:Float) {
		super.update(dt);
		if (partSystem != null)
			partSystem.update(dt);
		Artean.update(dt);

		if (waitEvent != null)
			waitEvent.update(dt);

		if (hxd.Key.isReleased(hxd.Key.F11)) {
			isFullscreen = !isFullscreen;
			#if hl
			engine.fullScreen = isFullscreen;
			#end
		}
	}

	static function main() {
		hxd.Res.initLocal();
		new Main();
	}
}
