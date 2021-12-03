package particles.loaders;

import haxe.Json;
import particles.loaders.utils.DynamicExt;
import h3d.Vector;
import hxd.Math;

using particles.loaders.utils.DynamicTools;

class JsonParticleLoader {
    public static function load(path : String) : ParticleGroup {
        var map : DynamicExt = Json.parse(hxd.Res.load(path).toText());
        var pg = new ParticleGroup();

        pg.emitterType = map["emitterType"].asInt();
        pg.maxParticles = map["maxParticles"].asInt();
        pg.positionType = 0;
        pg.duration = map["duration"].asFloat();
        pg.gravity = asVector(map, "gravity");
        pg.particleLifespan = map["particleLifespan"].asFloat();
        pg.particleLifespanVariance = map["particleLifespanVariance"].asFloat();
        pg.speed = map["speed"].asFloat();
        pg.speedVariance = map["speedVariance"].asFloat();
        pg.sourcePosition = new Vector(0.0, 0.0);
        pg.sourcePositionVariance = asVector(map, "sourcePositionVariance");
        pg.angle = Math.degToRad(map["angle"].asFloat());
        pg.angleVariance = Math.degToRad(map["angleVariance"].asFloat());
        pg.startParticleSize = map["startParticleSize"].asFloat();
        pg.startParticleSizeVariance = map["startParticleSizeVariance"].asFloat();
        pg.finishParticleSize = map["finishParticleSize"].asFloat();
        pg.finishParticleSizeVariance = map["finishParticleSizeVariance"].asFloat();
        pg.startColor = asColor(map, "startColor");
        pg.startColorVariance = asColor(map, "startColorVariance");
        pg.finishColor = asColor(map, "finishColor");
        pg.finishColorVariance = asColor(map, "finishColorVariance");
        pg.minRadius = map["minRadius"].asFloat();
        pg.minRadiusVariance = map["minRadiusVariance"].asFloat();
        pg.maxRadius = map["maxRadius"].asFloat();
        pg.maxRadiusVariance = map["maxRadiusVariance"].asFloat();
        pg.rotationStart = Math.degToRad(map["rotationStart"].asFloat());
        pg.rotationStartVariance = Math.degToRad(map["rotationStartVariance"].asFloat());
        pg.rotationEnd = Math.degToRad(map["rotationEnd"].asFloat());
        pg.rotationEndVariance = Math.degToRad(map["rotationEndVariance"].asFloat());
        pg.rotatePerSecond = Math.degToRad(map["rotatePerSecond"].asFloat());
        pg.rotatePerSecondVariance = Math.degToRad(map["rotatePerSecondVariance"].asFloat());
        pg.radialAcceleration = map["radialAcceleration"].asFloat();
        pg.radialAccelerationVariance = map["radialAccelVariance"].asFloat();
        pg.tangentialAcceleration = map["tangentialAcceleration"].asFloat();
        pg.tangentialAccelerationVariance = map["tangentialAccelVariance"].asFloat();
        var blendSrc = map["blendFuncSource"].asInt();
        var blendDst = map["blendFuncDestination"].asInt();
        pg.blendMode = ParticleLoader.toBlendMode(blendSrc, blendDst);
        pg.tile = ParticleLoader.loadTexture(map["textureImageData"].asString(), map["textureFileName"].asString(), path);
        pg.yCoordMultiplier = (map["yCoordFlipped"].asInt() == 1 ? -1.0 : 1.0);
        pg.headToVelocity = map["headToVelocity"].asBool(); // custom property
        pg.forceSquareTexture = true;

        return pg;
    }

    private static function asVector(map : DynamicExt, prefix : String) : Vector {
        return new Vector(
            map['${prefix}x'].asFloat(),
            map['${prefix}y'].asFloat()
        );
    }

    private static function asColor(map : DynamicExt, prefix : String) : Vector {
        return new Vector(
            map['${prefix}Red'].asFloat(),
            map['${prefix}Green'].asFloat(),
            map['${prefix}Blue'].asFloat(),
            map['${prefix}Alpha'].asFloat()
        );
    }
}
