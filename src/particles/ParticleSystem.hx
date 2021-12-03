package particles;

class ParticleSystem extends h2d.Drawable {
	var groups:Array<ParticleGroup>;
	var pshader:ParticleShader;

	public function new(?parent) {
		super(parent);
		groups = [];
		pshader = new ParticleShader();
		addShader(pshader);
	}

	public function addParticleGroup(g:ParticleGroup) {
		if (g.name == null)
			g.name = "Group#" + (groups.length + 1);
		g.init(this);
		groups.push(g);
	}
	
	public function scaleGroups(s:Float) {
		for (g in groups)
			g.scale *= s;
	}
	
	public function setScaleGroups(s:Float) {
		for (g in groups)
			g.scale = s;
	}
	
	public function start() {
		for (g in groups)
			g.emit();
	}
	
	public function stop() {
		for (g in groups)
			g.stop();
	}

	public function removeParticleGroup(g:ParticleGroup) {
		var idx = groups.indexOf(g);
		g.stop();
		if (idx < 0)
			return;
		groups.splice(idx, 1)[0].remove();
	}
	
	public function clear() {
		while (groups.length > 0)
			removeParticleGroup(groups.shift());
	}

	public function update(dt:Float) {
		for (g in groups)
			g.update(dt);
	}

	override function draw(ctx:h2d.RenderContext) @:privateAccess {
		var old = blendMode;
		var realX:Float = absX;
		var realY:Float = absY;
		var realA:Float = matA;
		var realB:Float = matB;
		var realC:Float = matC;
		var realD:Float = matD;

		for (g in groups)
			if (g.active) {
				blendMode = g.batch.blendMode;
				g.batch.drawWith(ctx, this);
			}
		blendMode = old;
	}
}

private class ParticleShader extends hxsl.Shader {
	static var SRC = {
		@input var input:{color:Vec4};
		var pixelColor:Vec4;
		var textureColor:Vec4;
		function fragment() {
			pixelColor = textureColor * input.color;
			pixelColor.a *= input.color.a;
		}
	}
}
