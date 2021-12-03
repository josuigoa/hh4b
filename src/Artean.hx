package;

class Artean {
	static public var defaultEase:Float->Float->Float->Float->Float = easeLinear;

	static inline var PI_M2:Float = 3.141592653589793 * 2;
	static inline var PI_D2:Float = 3.141592653589793 / 2;

	static public var updateList:Array<Float->Bool>;

	static public function simple(duration:Float, from:Float, to:Float, func:Float->Float->Void, easeFunc:Float->Float->Float->Float->Float = null) {
		var ease = (easeFunc == null) ? defaultEase : easeFunc;
		var t = 0.;
		var diff = to - from;

		var _tmp = function(dt:Float) {
			t += dt;
			if (t > duration)
				func(to, 1.);
			else
				func(ease(t, from, diff, duration), t/duration);
			return t > duration;
		}

		addOnUpdate(_tmp);
	}

	static function addOnUpdate(f:Float->Bool) {
		if (updateList == null)
			updateList = [];
		updateList.push(f);
	}

	static public function update(dt:Float) {
		if (updateList == null || updateList.length == 0)
			return;
		for (f in updateList)
			if (f(dt))
				updateList.remove(f);
	}

	/**
	 *  [Description]
	 *  @param t - time
	 *  @param b - begin
	 *  @param c - change
	 *  @param d - duration
	 *  @return Float
	 *  		return c*t/d + b
	 */
	static inline public function easeLinear(t:Float, b:Float, c:Float, d:Float):Float
		return c * t / d + b;

	// Sine
	static inline public function easeInSine(t:Float, b:Float, c:Float, d:Float):Float
		return -c * Math.cos(t / d * PI_D2) + c + b;

	static inline public function easeOutSine(t:Float, b:Float, c:Float, d:Float):Float
		return c * Math.sin(t / d * PI_D2) + b;

	static inline public function easeInOutSine(t:Float, b:Float, c:Float, d:Float):Float
		return -c / 2 * (Math.cos(Math.PI * t / d) - 1) + b;

	// Quintic
	static inline public function easeInQuint(t:Float, b:Float, c:Float, d:Float):Float
		return c * (t /= d) * t * t * t * t + b;

	static inline public function easeOutQuint(t:Float, b:Float, c:Float, d:Float):Float
		return c * ((t = t / d - 1) * t * t * t * t + 1) + b;

	static inline public function easeInOutQuint(t:Float, b:Float, c:Float, d:Float):Float {
		if ((t /= d / 2) < 1)
			return c / 2 * t * t * t * t * t + b;
		return c / 2 * ((t -= 2) * t * t * t * t + 2) + b;
	}

	// Quartic
	static inline public function easeInQuart(t:Float, b:Float, c:Float, d:Float):Float
		return c * (t /= d) * t * t * t + b;

	static inline public function easeOutQuart(t:Float, b:Float, c:Float, d:Float):Float
		return -c * ((t = t / d - 1) * t * t * t - 1) + b;

	static inline public function easeInOutQuart(t:Float, b:Float, c:Float, d:Float):Float {
		if ((t /= d / 2) < 1)
			return c / 2 * t * t * t * t + b;
		return -c / 2 * ((t -= 2) * t * t * t - 2) + b;
	}

	// Quadratic
	static inline public function easeInQuad(t:Float, b:Float, c:Float, d:Float):Float
		return c * (t /= d) * t + b;

	static inline public function easeOutQuad(t:Float, b:Float, c:Float, d:Float):Float
		return -c * (t /= d) * (t - 2) + b;

	static inline public function easeInOutQuad(t:Float, b:Float, c:Float, d:Float):Float {
		if ((t /= d / 2) < 1)
			return c / 2 * t * t + b;
		return -c / 2 * ((--t) * (t - 2) - 1) + b;
	}

	// Exponential
	static inline public function easeInExpo(t:Float, b:Float, c:Float, d:Float):Float
		return (t == 0) ? b : c * Math.pow(2, 10 * (t / d - 1)) + b;

	static inline public function easeOutExpo(t:Float, b:Float, c:Float, d:Float):Float
		return (t == d) ? b + c : c * (-Math.pow(2, -10 * t / d) + 1) + b;

	static inline public function easeInOutExpo(t:Float, b:Float, c:Float, d:Float):Float {
		if (t == 0)
			return b;
		if (t == d)
			return b + c;
		if ((t /= d / 2) < 1)
			return c / 2 * Math.pow(2, 10 * (t - 1)) + b;
		return c / 2 * (-Math.pow(2, -10 * --t) + 2) + b;
	}

	// Elastic
	static inline public function easeInElastic(t:Float, b:Float, c:Float, d:Float):Float {
		if (t == 0)
			return b;
		if ((t /= d) == 1)
			return b + c;
		var p = d * .3, s = p / 4, a = c;
		return -(a * Math.pow(2, 10 * (t -= 1)) * Math.sin((t * d - s) * PI_M2 / p)) + b;
	}

	static inline public function easeOutElastic(t:Float, b:Float, c:Float, d:Float):Float {
		if (t == 0)
			return b;
		if ((t /= d) == 1)
			return b + c;
		var p = d * .3, s = p / 4, a = c;
		return (a * Math.pow(2, -10 * t) * Math.sin((t * d - s) * PI_M2 / p) + c + b);
	}

	static inline public function easeInOutElastic(t:Float, b:Float, c:Float, d:Float):Float {
		if (t == 0)
			return b;
		if ((t /= d / 2) == 2)
			return b + c;
		var p = d * .45, s = p / 4, a = c;
		if (t < 1)
			return -.5 * (a * Math.pow(2, 10 * (t -= 1)) * Math.sin((t * d - s) * PI_M2 / p)) + b;
		return a * Math.pow(2, -10 * (t -= 1)) * Math.sin((t * d - s) * PI_M2 / p) * .5 + c + b;
	}

	// Circular
	static inline public function easeInCircular(t:Float, b:Float, c:Float, d:Float):Float
		return -c * (Math.sqrt(1 - (t /= d) * t) - 1) + b;

	static inline public function easeOutCircular(t:Float, b:Float, c:Float, d:Float):Float
		return c * Math.sqrt(1 - (t = t / d - 1) * t) + b;

	static inline public function easeInOutCircular(t:Float, b:Float, c:Float, d:Float):Float {
		if ((t /= d / 2) < 1)
			return -c / 2 * (Math.sqrt(1 - t * t) - 1) + b;
		return c / 2 * (Math.sqrt(1 - (t -= 2) * t) + 1) + b;
	}

	// Back
	static inline public function easeInBack(t:Float, b:Float, c:Float, d:Float):Float {
		var s = 1.70158;
		return c * (t /= d) * t * ((s + 1) * t - s) + b;
	}

	static inline public function easeOutBack(t:Float, b:Float, c:Float, d:Float):Float {
		var s = 1.70158;
		return c * ((t = t / d - 1) * t * ((s + 1) * t + s) + 1) + b;
	}

	static inline public function easeInOutBack(t:Float, b:Float, c:Float, d:Float):Float {
		var s = 1.70158;
		if ((t /= d / 2) < 1)
			return c / 2 * (t * t * (((s *= (1.525)) + 1) * t - s)) + b;
		return c / 2 * ((t -= 2) * t * (((s *= (1.525)) + 1) * t + s) + 2) + b;
	}

	// Bounce
	static inline public function easeInBounce(t:Float, b:Float, c:Float, d:Float):Float
		return c - easeOutBounce(d - t, 0, c, d) + b;

	static inline public function easeOutBounce(t:Float, b:Float, c:Float, d:Float):Float {
		if ((t /= d) < (1 / 2.75)) {
			return c * (7.5625 * t * t) + b;
		} else if (t < (2 / 2.75)) {
			return c * (7.5625 * (t -= (1.5 / 2.75)) * t + .75) + b;
		} else if (t < (2.5 / 2.75)) {
			return c * (7.5625 * (t -= (2.25 / 2.75)) * t + .9375) + b;
		} else {
			return c * (7.5625 * (t -= (2.625 / 2.75)) * t + .984375) + b;
		}
	}

	static inline public function easeInOutBounce(t:Float, b:Float, c:Float, d:Float):Float {
		if (t < d / 2)
			return easeInBounce(t * 2, 0, c, d) * .5 + b;
		else
			return easeOutBounce(t * 2 - d, 0, c, d) * .5 + c * .5 + b;
	}

	// Cubic
	static inline public function easeInCubic(t:Float, b:Float, c:Float, d:Float):Float
		return c * (t /= d) * t * t + b;

	static inline public function easeOutCubic(t:Float, b:Float, c:Float, d:Float):Float
		return c * ((t = t / d - 1) * t * t + 1) + b;

	static inline public function easeInOutCubic(t:Float, b:Float, c:Float, d:Float):Float {
		if ((t /= d / 2) < 1)
			return c / 2 * t * t * t + b;
		return c / 2 * ((t -= 2) * t * t + 2) + b;
	}
}
