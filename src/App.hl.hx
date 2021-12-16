import appropos.Appropos;

class App {
	static var photosLoader:hxd.res.Loader;
	static var photosDir:String;

	static public function main() {
		var selectedPhoto = hl.UI.loadFile({});

		if (selectedPhoto == null)
			Sys.exit(0);

		hxd.Res.initLocal();
		Appropos.init();
		var dirs = StringTools.replace(haxe.io.Path.directory(selectedPhoto), '\\', '/').split('/');
		photosDir = dirs.pop();
		var baseDir = dirs.join('/');
		photosLoader = new CustomLoader(new hxd.fs.LocalFileSystem(baseDir, null));
		new Main();
	}

	static public function loadPhotos() {
		return [
			for (entry in photosLoader.load(photosDir).entry)
				{
					name: haxe.io.Path.withoutExtension(entry.name).toUpperCase(),
					tile: photosLoader.load(entry.path).toTile()
				}
		];
		return [];
	}

	static public function maximize() {}
}
