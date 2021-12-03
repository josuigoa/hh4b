class Bg extends h2d.Object {
    
    var g:h2d.Graphics;
    
    public function new(w, h, parent) {
        super(parent);
        g = new h2d.Graphics(this);
        
        paint(w, h);
    }
    
    public function paint(w, h) {
        g.clear();
        var k = 20;
        var r = 10;
        for (x in 0...Std.int(w/k)) {
            for (y in 0...Std.int(h/k)) {
                g.beginFill(Std.int(hxd.Math.random(0xffffff)));
                
                if (y < h*.18/k || hxd.Math.random(y) < 6) {
                    var rnd = Math.random();
                    var xx = x*k + hxd.Math.srand(r);
                    var yy = y*k + hxd.Math.srand(r);
                    if (rnd < .4)
                        g.drawEllipse(xx, yy, r * .8, r * 1.2, hxd.Math.degToRad(hxd.Math.random(360)));
                    else
                        g.drawCircle(xx, yy, r);
                }
            }
        }
    }
}