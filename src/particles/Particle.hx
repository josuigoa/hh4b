package particles;

import h3d.Vector;

@:access(ParticleGroup)
class Particle extends h2d.SpriteBatch.BatchElement {
    
    var group : ParticleGroup;
    var tileSize : Float = 0;
    public var groupScale : Float = 1.;
    
    public var startPos : Vector = new Vector(0.0, 0.0);
    public var prevPosition : Vector = new Vector(0.0, 0.0);
    public var direction : Vector = new Vector(0.0, 0.0);
    public var colorDelta : Vector = new Vector(0.0, 0.0, 0.0, 0.0);
    //public var rotation : Float = 0.0;
    public var rotationDelta : Float = 0.0;
    public var radius : Float = 0.0;
    public var radiusDelta : Float = 0.0;
    public var angle : Float = 0.0;
    public var angleDelta : Float = 0.0;
    public var particleSize : Float = 0.0;
    public var particleSizeDelta : Float = 0.0;
    public var radialAcceleration : Float = 0.0;
    public var tangentialAcceleration : Float = 0.0;
    public var timeToLive : Float = 0.0;

    public function new(group) {
        super(null);
        this.group = group;
        t = group.tile;
        if (t != null)
            tileSize = t.width;
    }

    override public function update(dt : Float) : Bool {
        timeToLive -= dt;

        if (timeToLive <= 0.0) {
            return false;
        }

        prevPosition.x = x;
        prevPosition.y = y;

        if (group.emitterType == ParticleGroup.EMITTER_TYPE_RADIAL) {
            angle += angleDelta * dt;
            radius += radiusDelta * dt;

            x = startPos.x - Math.cos(angle) * radius;
            y = startPos.y - Math.sin(angle) * radius * group.yCoordMultiplier;
        } else {
            var radial = { x: 0.0, y: 0.0 };

            x -= startPos.x;
            y = (y - startPos.y) * group.yCoordMultiplier;

            if (x != 0.0 || y != 0.0) {
                var length = Math.sqrt(x * x + y * y);

                radial.x = x / length;
                radial.y = y / length;
            }

            var tangential = {
                x: - radial.y,
                y: radial.x,
            };

            radial.x *= radialAcceleration;
            radial.y *= radialAcceleration;

            tangential.x *= tangentialAcceleration;
            tangential.y *= tangentialAcceleration;

            direction.x += (radial.x + tangential.x + group.gravity.x) * dt;
            direction.y += (radial.y + tangential.y + group.gravity.y) * dt;

            x += direction.x * dt + startPos.x;
            y = (y + direction.y * dt) * group.yCoordMultiplier + startPos.y;
        }

        r += colorDelta.r * dt;
        g += colorDelta.g * dt;
        b += colorDelta.b * dt;
        a += colorDelta.a * dt;

        particleSize += particleSizeDelta * dt;
        particleSize = Math.max(0, particleSize);
        
        scale = groupScale * particleSize / tileSize;

        if (group.headToVelocity) {
            var vx = x - prevPosition.x;
            var vy = y - prevPosition.y;

            if (Math.abs(vx) > 0.00001 || Math.abs(vy) > 0.00001) {
                rotation = Math.atan2(vy, vx);
            } else {
                rotation = Math.atan2(direction.y, direction.x);
            }
        } else {
            rotation += rotationDelta * dt;
        }

        return true;
    }
}
