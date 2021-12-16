class CustomLoader extends hxd.res.Loader {
	var pathKeys = new Map<String, {}>();

	function getKey(path:String) {
		var k = pathKeys.get(path);
		if (k == null) {
			k = {};
			pathKeys.set(path, k);
		}
		return k;
	}

	override function loadCache<T:hxd.res.Resource>(path:String, c:Class<T>):T {
		if ((c : Dynamic) == (hxd.res.Image : Dynamic))
			return cast loadImage(path);
		return super.loadCache(path, c);
	}

	function loadImage(path:String) {
		var engine = h3d.Engine.getCurrent();
		var i:hxd.res.Image = @:privateAccess engine.resCache.get(getKey(path));
		if (i == null) {
			i = new hxd.res.Image(fs.get(path));
			@:privateAccess engine.resCache.set(getKey(path), i);
		}
		return i;
	}
}
