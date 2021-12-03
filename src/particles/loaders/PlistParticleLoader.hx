package particles.loaders;

import haxe.Json;
import particles.loaders.utils.DynamicExt;
import hxd.Math;
import particles.ParticleGroup;

using particles.loaders.utils.DynamicTools;
using particles.loaders.utils.XmlExt;

class PlistParticleLoader {
    public static function load(path : String) : ParticleGroup {
        var root = Xml.parse(hxd.Res.load(path).toText()).firstElement().firstElement();

        if (root.nodeName != "dict") {
            throw 'Expecting "dict", but "${root.nodeName}" found';
        }

        var key : String = null;
        var map : Map<String, Dynamic> = new Map<String, Dynamic>();

        for (node in root.elements()) {
            if (key == null) {
                if (node.nodeName == "key") {
                    key = node.innerText();

                    if (key == "") {
                        throw "Empty key is not supported";
                    }

                    continue;
                }

                throw 'Expecting element "key", but "${node.nodeName}" found';
            }

            var textValue = node.innerText();

            switch (node.nodeName) {
                case "false":
                    map[key] = false;

                case "true":
                    map[key] = true;

                case "real":
                    var value = Std.parseFloat(textValue);

                    if (Math.isNaN(value)) {
                        throw 'Could not parse "${textValue}" as real (for key "${key}")';
                    }

                    map[key] = value;

                case "integer":
                    var value = Std.parseInt(textValue);

                    if (value == null) {
                        throw 'Could not parse "${textValue}" as integer (for key "${key}")';
                    }

                    map[key] = value;

                case "string":
                    map[key] = textValue;

                default:
                    throw 'Unsupported element "${node.nodeName}"';
            }

            key = null;
        }

        var pg = new ParticleGroup();

        pg.emitterType = map["emitterType"].asInt();
        pg.maxParticles = map["maxParticles"].asInt();
        pg.positionType = map["positionType"].asInt();
        pg.duration = map["duration"].asFloat();
        pg.gravity = asVector(map, "gravity");
        pg.particleLifespan = map["particleLifespan"].asFloat();
        pg.particleLifespanVariance = map["particleLifespanVariance"].asFloat();
        pg.speed = map["speed"].asFloat();
        pg.speedVariance = map["speedVariance"].asFloat();
        pg.sourcePosition = asVector(map, "sourcePosition");
        pg.sourcePositionVariance = asVector(map, "sourcePositionVariance");
        pg.angle = hxd.Math.degToRad(map["angle"].asFloat());
        pg.angleVariance = hxd.Math.degToRad(map["angleVariance"].asFloat());
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
        pg.rotationStart = hxd.Math.degToRad(map["rotationStart"].asFloat());
        pg.rotationStartVariance = hxd.Math.degToRad(map["rotationStartVariance"].asFloat());
        pg.rotationEnd = hxd.Math.degToRad(map["rotationEnd"].asFloat());
        pg.rotationEndVariance = hxd.Math.degToRad(map["rotationEndVariance"].asFloat());
        pg.rotatePerSecond = hxd.Math.degToRad(map["rotatePerSecond"].asFloat());
        pg.rotatePerSecondVariance = hxd.Math.degToRad(map["rotatePerSecondVariance"].asFloat());
        pg.radialAcceleration = map["radialAcceleration"].asFloat();
        pg.radialAccelerationVariance = map["radialAccelVariance"].asFloat();
        pg.tangentialAcceleration = map["tangentialAcceleration"].asFloat();
        pg.tangentialAccelerationVariance = map["tangentialAccelVariance"].asFloat();
        var blendSrc = map["blendFuncSource"].asInt();
        var blendDst = map["blendFuncDestination"].asInt();
        pg.blendMode = ParticleLoader.toBlendMode(blendSrc, blendDst);
        pg.tile = ParticleLoader.loadTexture(map["textureImageData"].asString(), map["textureFileName"].asString(), path);
        pg.yCoordMultiplier = (map["yCoordFlipped"].asInt() == 1 ? -1.0 : 1.0);
        pg.headToVelocity = (map["headToVelocity"].asInt() == 1); // custom property
        pg.forceSquareTexture = true;

        return pg;
    }

    private static function asVector(map : Map<String, Dynamic>, prefix : String) : h3d.Vector {
        return new h3d.Vector(
            map['${prefix}x'].asFloat(),
            map['${prefix}y'].asFloat()
        );
    }

    private static function asColor(map : Map<String, Dynamic>, prefix : String) : h3d.Vector {
        return new h3d.Vector(
            map['${prefix}Red'].asFloat(),
            map['${prefix}Green'].asFloat(),
            map['${prefix}Blue'].asFloat(),
            map['${prefix}Alpha'].asFloat()
        );
    }
}
