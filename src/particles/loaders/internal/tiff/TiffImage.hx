package particles.internal.tiff;

import haxe.io.Bytes;

class TiffImage {
    public var width : Int;
    public var height : Int;
    public var pixels : Bytes;

    public function new(width : Int, height : Int, pixels : Bytes) {
        this.width = width;
        this.height = height;
        this.pixels = pixels;
    }
}
