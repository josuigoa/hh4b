package particles.loaders;

import h2d.BlendMode;
import particles.ParticleGroup;
//import particles.loaders.internal.tiff.TiffDecoder;

enum abstract GLBlend(Int) from Int {
    var ZERO                = 0;
    var ONE                 = 1;
    var SRC_COLOR           = 768;
    var ONE_MINUS_SRC_COLOR = 769;
    var SRC_ALPHA           = 770;
    var ONE_MINUS_SRC_ALPHA = 771;
    var DST_ALPHA           = 772;
    var ONE_MINUS_DST_ALPHA = 773;
    var DST_COLOR           = 774;
    var ONE_MINUS_DST_COLOR = 775;
    var SRC_ALPHA_SATURATE  = 776;
}

class ParticleLoader {
    public static function load(path : String) : ParticleGroup {
        var ext = hxd.Res.load(path).entry.extension;

        switch (ext) {
            case "plist":
                return PlistParticleLoader.load(path);

            case "json":
                return JsonParticleLoader.load(path);
            
            case "pixi":
                return PixiParticleLoader.load(path);

            case "pex" | "lap":
                return PexLapParticleLoader.load(path);

            default:
                throw 'Unsupported extension "${ext}"';
        }
        
        return null;
    }

    static public function loadTexture(textureImageData : String, textureFileName : String, path : String) : h2d.Tile {
        var tilePath = textureFileName;
        var dir = haxe.io.Path.directory(path);
        if (dir != '')
            tilePath = dir + '/' + tilePath;
        if (textureImageData == null || textureImageData.length == 0) {
            return hxd.Res.load(tilePath).toTile().center();
        }

        return hxd.res.Any.fromBytes(tilePath, haxe.crypto.Base64.decode(textureImageData)).toTile().center();
        
        /*
        var data = haxe.crypto.Base64.decode(textureImageData);

        if (data.get(0) == 0x1f && data.get(1) == 0x8b) {
            var reader = new format.gz.Reader(new haxe.io.BytesInput(data));
            data = reader.read().data;
        }

        var decoded = TiffDecoder.decode(data);

        var result = new hxd.BitmapData(decoded.width, decoded.height);
		result.setPixels(new hxd.Pixels(decoded.width, decoded.height, decoded.pixels));
        return h2d.Tile.fromBitmap(result);
        */
    }

    static public function toBlendMode(src:GLBlend, dst:GLBlend) {
        return switch [src, dst] {
            case [ONE, ZERO]: None;
            case [SRC_ALPHA, ONE_MINUS_SRC_ALPHA]: Alpha;
            case [SRC_ALPHA, ONE]: Add;
            case [ONE, ONE_MINUS_SRC_ALPHA]: AlphaAdd;
            case [ONE_MINUS_DST_COLOR, ONE]: SoftAdd;
            case [DST_COLOR, ZERO]: Multiply;
            case [DST_COLOR, ONE_MINUS_SRC_ALPHA]: AlphaMultiply;
            case [ZERO, ONE_MINUS_SRC_COLOR]: Erase;
            case [ONE, ONE_MINUS_SRC_COLOR]: Screen;
            // case [SRC_ALPHA, ONE]: Sub;
            default: None;
        }
    }
}