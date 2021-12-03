package particles.loaders;

import haxe.Json;
import particles.ParticleGroup;
import h2d.BlendMode;
import h3d.Vector;
import hxd.Math;
import particles.loaders.utils.DynamicExt;

using particles.loaders.utils.DynamicTools;

class PixiParticleLoader {
    private static inline var BLEND_MODE_NORMAL : String = "normal";
    private static inline var BLEND_MODE_ADD : String = "add";
    private static inline var BLEND_MODE_MULTIPLY : String = "multiply";

    public static function load(path : String) : ParticleGroup {
        var map : DynamicExt = Json.parse(hxd.Res.load(path).toText());
        var pg = new ParticleGroup();

        var texturePath = map["texturePath"].asString();
        pg.tile = ParticleLoader.loadTexture(null, texturePath, path);

        if (pg.tile == null) {
            throw 'Expecting valid texture';
        }

        var scaleMap = map["scale"].asDynamic();

        // Assumes texture is rectangular!
        var startSize = scaleMap["start"].asFloat() * pg.tile.width;
        var endSize = scaleMap["end"].asFloat() * pg.tile.width;

        pg.startParticleSize = startSize;
        pg.startParticleSizeVariance = 0.0;

        pg.finishParticleSize = endSize;
        pg.finishParticleSizeVariance = 0.0;

        // TODO: There is not a good mapping between the spawn and emitter types, so assume radial for now
        // var spawnType = map["spawnType"].asString();
        pg.emitterType = ParticleGroup.EMITTER_TYPE_RADIAL;

        pg.maxParticles = map["maxParticles"].asInt();
        pg.positionType = 0;
        pg.duration = map["emitterLifetime"].asFloat();
        pg.emissionFreq = map["frequency"].asFloat();

        var lifeMap = map["lifetime"].asDynamic();
        var lifeMin = lifeMap["min"].asFloat();
        var lifeMax = lifeMap["max"].asFloat();
        var averageLife = (lifeMin + lifeMax) * 0.5;

        pg.particleLifespan = (lifeMin + lifeMax) * 0.5;
        pg.particleLifespanVariance = (lifeMax - lifeMin) * 0.5;

        var speedMap = map["speed"].asDynamic();
        var speedMin = speedMap["min"].asFloat();
        var speedMax = speedMap["max"].asFloat();

        // Only applies to gravity emitters (not radial)
        pg.speed = (speedMin + speedMax) * 0.5;
        pg.speedVariance = (speedMax - speedMin) * 0.5;

        pg.gravity = asVector(map, "gravity");
        pg.sourcePosition = new Vector(0.0, 0.0);
        pg.sourcePositionVariance = asVector(map, "sourcePositionVariance");

        var startRot = map["startRotation"].asDynamic();
        var startRotMin = startRot["min"].asFloat() + 180.0;
        var startRotMax = startRot["max"].asFloat() + 180.0;

        pg.angle = Math.degToRad((startRotMin + startRotMax) * 0.5);
        pg.angleVariance = Math.degToRad((startRotMax - startRotMin) * 0.5);

        // TODO: color animation not supported in html5
        pg.startColor = asColor(map, "color", "start");
        pg.startColorVariance = new Vector(0.0, 0.0, 0.0, 0.0);

        pg.finishColor = asColor(map, "color", "end");
        pg.finishColorVariance = new Vector(0.0, 0.0, 0.0, 0.0);

        var alpha = map["alpha"].asDynamic();
        pg.startColor.a = alpha["start"].asFloat();
        pg.finishColor.a = alpha["end"].asFloat();

        // Pixi uses start, end speed, while pex uses a min and max radius for the radial emitter
        var startSpeed = speedMap["start"].asFloat();
        var endSpeed = speedMap["end"].asFloat();
        var averageSpeed = (startSpeed + endSpeed) * 0.5;

        var minDist = averageSpeed * lifeMin;
        var maxDist = averageSpeed * lifeMax;
        var averageDist = averageSpeed * averageLife;

        pg.minRadius = averageDist;
        pg.minRadiusVariance = (maxDist - minDist) * 0.5;

        pg.maxRadius = 0.0;
        pg.maxRadiusVariance = 0.0;

        var rotSpeedMap = map["rotationSpeed"];
        var rotSpeedMin = rotSpeedMap["min"].asFloat();
        var rotSpeedMax = rotSpeedMap["max"].asFloat();

        // TODO: rotationStart and rotationStartVariance currently equal to angle and angleVariance, is it right?
        pg.rotationStart = Math.degToRad((startRotMin + startRotMax) * 0.5);
        pg.rotationStartVariance = Math.degToRad((startRotMax - startRotMin) * 0.5);

        var rotMin = rotSpeedMin * averageLife;
        var rotMax = rotSpeedMax * averageLife;

        pg.rotationEnd = pg.rotationStart + Math.degToRad((rotMin + rotMax) * 0.5);
        pg.rotationEndVariance = Math.degToRad((rotMax - rotMin) * 0.5);

        // This rotates the emitter itself, which is not supported by pixi
        pg.rotatePerSecond = 0.0;
        pg.rotatePerSecondVariance = 0.0;

        pg.blendMode = switch (map["blendMode"].asString()) {
                        case BLEND_MODE_NORMAL: None;
                        case BLEND_MODE_ADD: Add;
                        case BLEND_MODE_MULTIPLY: Multiply;
                        default: None;
                    };

        pg.yCoordMultiplier = (map["yCoordFlipped"].asInt() == 1 ? -1.0 : 1.0);

        pg.radialAcceleration = 0.0;
        pg.radialAccelerationVariance = 0.0;
        pg.tangentialAcceleration = 0.0;
        pg.tangentialAccelerationVariance = 0.0;

        pg.forceSquareTexture = false;

        return pg;
    }

    private static function asVector(map : DynamicExt, prefix : String) : Vector {
        return new Vector(
            map['${prefix}x'].asFloat(),
            map['${prefix}y'].asFloat()
        );
    }

    private static function asColor(map : DynamicExt, param : String, subParam : String) : Vector {
        if (!map.exists(param)) {
            return new Vector(0.0, 0.0, 0.0, 1.0);
        }

        var str = map[param].asDynamic()[subParam].asString();
        var val = Std.parseInt(StringTools.replace(str, "#", "0x"));

        return new Vector(
            ((val >> 16) & 0xff) / 255.0,
            ((val >> 8) & 0xff) / 255.0,
            (val & 0xff) / 255.0,
            1.0
        );
    }
}
