package particles;

import haxe.Timer;
import hxd.Math;
import h3d.Vector;

class ParticleGroup {
    public static inline var EMITTER_TYPE_GRAVITY : Int = 0;
    public static inline var EMITTER_TYPE_RADIAL : Int = 1;

    public static inline var POSITION_TYPE_FREE : Int = 0;
    public static inline var POSITION_TYPE_RELATIVE : Int = 1;
    public static inline var POSITION_TYPE_GROUPED : Int = 2;

    public var emitterType : Int = 0;
    public var maxParticles : Int = 0;
    public var positionType : Int = 0;
    public var duration : Float = 0.0;
    public var gravity : Vector = new Vector(0.0, 0.0);
    public var particleLifespan : Float = 0.0;
    public var particleLifespanVariance : Float = 0.0;
    public var speed : Float = 0.0;
    public var speedVariance : Float = 0.0;
    public var sourcePosition : Vector = new Vector(0.0, 0.0);
    public var sourcePositionVariance : Vector = new Vector(0.0, 0.0);
    public var angle : Float = 0.0;
    public var angleVariance : Float = 0.0;
    public var startParticleSize : Float = 0.0;
    public var startParticleSizeVariance : Float = 0.0;
    public var finishParticleSize : Float = 0.0;
    public var finishParticleSizeVariance : Float = 0.0;
    public var startColor : Vector = new Vector(0.0, 0.0, 0.0, 0.0);
    public var startColorVariance : Vector = new Vector(0.0, 0.0, 0.0, 0.0);
    public var finishColor : Vector = new Vector(0.0, 0.0, 0.0, 0.0);
    public var finishColorVariance : Vector = new Vector(0.0, 0.0, 0.0, 0.0);
    public var minRadius : Float = 0.0;
    public var minRadiusVariance : Float = 0.0;
    public var maxRadius : Float = 0.0;
    public var maxRadiusVariance : Float = 0.0;
    public var rotationStart : Float = 0.0;
    public var rotationStartVariance : Float = 0.0;
    public var rotationEnd : Float = 0.0;
    public var rotationEndVariance : Float = 0.0;
    public var radialAcceleration : Float = 0.0;
    public var radialAccelerationVariance : Float = 0.0;
    public var tangentialAcceleration : Float = 0.0;
    public var tangentialAccelerationVariance : Float = 0.0;
    public var rotatePerSecond : Float = 0.0;
    public var rotatePerSecondVariance : Float = 0.0;
    public var blendMode : h2d.BlendMode = None;
    public var tile : h2d.Tile = null;
    public var active : Bool = false;
    public var restart : Bool = false;
    public var particleScaleX : Float = 1.0;
    public var particleScaleY : Float = 1.0;
    public var particleScaleSize : Float = 1.0;
    public var yCoordMultiplier : Float = 1.0;
    public var headToVelocity : Bool = false;
    public var emissionFreq : Float = 0.0;
    public var forceSquareTexture : Bool = false;

    private var prevTime : Float = -1.0;
    private var emitCounter : Float = 0.0;
    private var elapsedTime : Float = 0.0;

    public var __particleList : Array<Particle> = [];
    public var __particleCount : Int = 0;
    
    public var name:String;
	var batch : h2d.SpriteBatch;
    public var scale:Float = 1.;

    public function new() {}
    
    public function init(parent:h2d.Object) {
		batch = new h2d.SpriteBatch(tile, parent);
		batch.visible = false;
		batch.hasRotationScale = true;
		batch.hasUpdate = false;
        batch.blendMode = blendMode;
        
        prevTime = -1.0;
        emitCounter = 0.0;
        elapsedTime = 0.0;

        if (emissionFreq <= 0.0) {
            var emissionRate : Float = maxParticles / Math.max(0.0001, particleLifespan);

            if (emissionRate > 0.0) {
                emissionFreq = 1.0 / emissionRate;
            }
        }

        __particleList = [];
        __particleCount = 0;

        for (i in 0 ... maxParticles) {
            __particleList[i] = new Particle(this);
        }
    }

    public function update(dt:Float) : Bool {

        if (dt < 0.0001)
            return false;

        if (active && emissionFreq > 0.0) {
            emitCounter += dt;
            if (__particleCount < maxParticles)
            while (__particleCount < maxParticles && emitCounter > emissionFreq) {
                initParticle(__particleList[__particleCount]);
                __particleCount++;
                emitCounter -= emissionFreq;
            }

            if (emitCounter > emissionFreq) {
                emitCounter = (emitCounter % emissionFreq);
            }

            elapsedTime += dt;

            if (duration >= 0.0 && duration < elapsedTime) {
                stop();
            }
        }

        var updated = false;

        if (__particleCount > 0) {
            updated = true;
        }

        var index = 0;
        var particle;
        while (index < __particleCount) {
            particle = __particleList[index];

            if (particle.update(dt)) {
                index++;
            } else {
                particle.remove();
                if (index != __particleCount - 1) {
                    __particleList[index] = __particleList[__particleCount - 1];
                    __particleList[__particleCount - 1] = particle;
                }

                __particleCount--;
            }
        }

        if (__particleCount > 0) {
            updated = true;
        } else if (restart) {
            active = true;
        }

        return updated;
    }
    
    public function remove() {
        if (batch != null) {
            var parts = batch.getElements();
            while(parts.hasNext())
                parts.next().remove();
            batch.remove();
        }
    }

    private function initParticle(p : Particle) : Void {
        // Common
        p.timeToLive = scale * Math.max(0.0001, particleLifespan + particleLifespanVariance * Math.srand());

        p.startPos.x = sourcePosition.x / particleScaleX;
        p.startPos.y = sourcePosition.y / particleScaleY;

        p.r = Math.clamp(startColor.r + startColorVariance.r * Math.srand());
        p.g = Math.clamp(startColor.g + startColorVariance.g * Math.srand());
        p.b = Math.clamp(startColor.b + startColorVariance.b * Math.srand());
        p.a = Math.clamp(startColor.a + startColorVariance.a * Math.srand());

        p.colorDelta.r = (Math.clamp(finishColor.r + finishColorVariance.r * Math.srand()) - p.r) / p.timeToLive;
        p.colorDelta.g = (Math.clamp(finishColor.g + finishColorVariance.g * Math.srand()) - p.g) / p.timeToLive;
        p.colorDelta.b = (Math.clamp(finishColor.b + finishColorVariance.b * Math.srand()) - p.b) / p.timeToLive;
        p.colorDelta.a = (Math.clamp(finishColor.a + finishColorVariance.a * Math.srand()) - p.a) / p.timeToLive;

        p.groupScale = scale;
        p.particleSize = scale * Math.max(0.0, startParticleSize + startParticleSizeVariance * Math.srand());

        p.particleSizeDelta = scale * (Math.max(
            0.0,
            finishParticleSize + finishParticleSizeVariance * Math.srand()) - p.particleSize
        ) / p.timeToLive;

        p.rotation = rotationStart + rotationStartVariance * Math.srand();
        p.rotationDelta = (rotationEnd + rotationEndVariance * Math.srand() - p.rotation) / p.timeToLive;

        var computedAngle = angle + angleVariance * Math.srand();

        // For gravity emitter type
        var directionSpeed = scale * (speed + speedVariance * Math.srand());

        p.x = p.startPos.x + sourcePositionVariance.x * Math.srand();
        p.y = p.startPos.y + sourcePositionVariance.y * Math.srand();
        p.direction.x = Math.cos(computedAngle) * directionSpeed;
        p.direction.y = Math.sin(computedAngle) * directionSpeed;
        p.radialAcceleration = radialAcceleration + radialAccelerationVariance * Math.srand();
        p.tangentialAcceleration = tangentialAcceleration + tangentialAccelerationVariance * Math.srand();

        // For radial emitter type
        p.angle = computedAngle;
        p.angleDelta = (rotatePerSecond + rotatePerSecondVariance * Math.srand()) / p.timeToLive;
        p.radius = maxRadius + maxRadiusVariance * Math.srand();
        p.radiusDelta = (minRadius + minRadiusVariance * Math.srand() - p.radius) / p.timeToLive;
        
        batch.add(p);
    }

    public function emit(?sourcePositionX : Null<Float>, ?sourcePositionY : Null<Float>) : Void {
        if (sourcePositionX != null) {
            sourcePosition.x = sourcePositionX;
        }

        if (sourcePositionY != null) {
            sourcePosition.y = sourcePositionY;
        }

        active = true;
    }

    public function stop() : Void {
        active = false;
        elapsedTime = 0.0;
        emitCounter = 0.0;
    }

    public function reset() : Void {
        stop();

        for (i in 0 ... __particleCount) {
            __particleList[i].timeToLive = 0.0;
        }
    }
}