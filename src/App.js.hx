import js.Browser.document;
import js.html.*;
import js.jquery.Helper.J;
import appropos.Appropos;

class App {
	static var window:nw.Window;

	static var photosLoader:hxd.res.Loader;

	static function main() {
		window = nw.Window.get();
		#if debug
		window.showDevTools();
		#end

		chooseDirectory(function(dir) {
			var currentDir = haxe.io.Path.directory(Sys.programPath());
			Appropos.init(currentDir + '/app.props');
			photosLoader = new CustomLoader(new hxd.fs.LocalFileSystem(dir, null));
			hxd.Res.initLocal();
			new Main();
		});
	}

	static public function loadPhotos() {
		return [
			for (photo in photosLoader.dir('.'))
				{
					name: haxe.io.Path.withoutExtension(photo.name).toUpperCase(),
					tile: photo.toTile()
				}
		];
	}

	static public function maximize() {
		window.maximize();
	}

	static public function makeRelative(path:String) {
		path = path.split("\\").join("/");
		return path;
	}

	static public function chooseDirectory(onSelect:String->Void) {
		var e = J('<input type="file" style="visibility:hidden" value="" nwdirectory/>');
		e.change(function(ev) {
			var dir = makeRelative(ev.getThis().val());
			onSelect(dir == "" ? null : dir);
			e.remove();
		}).appendTo(window.window.document.body).click();
	}
}
