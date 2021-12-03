
class Shake {
	static public function run(sprite:h2d.Object, amount = 1., time = 1., onShake:Float->Void = null, onComplete:Void->Bool = null) {
		var baseX = -sprite.x;
		var baseY = -sprite.y;
		var totalTime = time;

		Main.inst.waitEvent.waitUntil(function(dt) {
			time -= dt;
			if (time < 0) {
				sprite.x = -baseX;
				sprite.y = -baseY;
				if (onComplete != null)
					onComplete();
				return true;
			}
			if (onShake != null)
				onShake((totalTime - time) / totalTime);
			sprite.x += hxd.Math.srand() * amount * 2.5 * (time < 0.25 ? time / 0.25 : 1);
			sprite.y += hxd.Math.srand() * amount * 2.5 * (time < 0.25 ? time / 0.25 : 1);
			return false;
		});
	}
}
