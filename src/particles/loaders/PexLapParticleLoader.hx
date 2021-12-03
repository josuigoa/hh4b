package particles.loaders;

import particles.ParticleGroup;
import h3d.Vector;
import hxd.Math;

class PexLapParticleLoader {
    public static function load(path : String) : ParticleGroup {
        var root = Xml.parse(hxd.Res.load(path).toText()).firstElement();

        if (root.nodeName != "particleEmitterConfig" && root.nodeName != "lanicaAnimoParticles") {
            throw 'Expecting "particleEmitterConfig" or "lanicaAnimoParticles", but "${root.nodeName}" found';
        }

        var map : Map<String, Xml> = new Map<String, Xml>();

        for (node in root.elements()) {
            map[node.nodeName] = node;
        }

        var pg = new ParticleGroup();

        pg.emitterType = parseIntNode(map["emitterType"]);
        pg.maxParticles = parseIntNode(map["maxParticles"]);
        pg.positionType = 0;
        pg.duration = parseFloatNode(map["duration"]);
        pg.gravity = parseVectorNode(map["gravity"]);
        pg.particleLifespan = parseFloatNode(map["particleLifeSpan"]);
        pg.particleLifespanVariance = parseFloatNode(map["particleLifespanVariance"]);
        pg.speed = parseFloatNode(map["speed"]);
        pg.speedVariance = parseFloatNode(map["speedVariance"]);
        pg.sourcePosition = parseVectorNode(map["sourcePosition"]);
        pg.sourcePositionVariance = parseVectorNode(map["sourcePositionVariance"]);
        pg.angle = Math.degToRad(parseFloatNode(map["angle"]));
        pg.angleVariance = Math.degToRad(parseFloatNode(map["angleVariance"]));
        pg.startParticleSize = parseFloatNode(map["startParticleSize"]);
        pg.startParticleSizeVariance = parseFloatNode(map["startParticleSizeVariance"]);
        pg.finishParticleSize = parseFloatNode(map["finishParticleSize"]);
        pg.finishParticleSizeVariance = parseFloatNode(map["finishParticleSizeVariance"]);
        pg.startColor = parseColorNode(map["startColor"]);
        pg.startColorVariance = parseColorNode(map["startColorVariance"]);
        pg.finishColor = parseColorNode(map["finishColor"]);
        pg.finishColorVariance = parseColorNode(map["finishColorVariance"]);
        pg.minRadius = parseFloatNode(map["minRadius"]);
        pg.minRadiusVariance = parseFloatNode(map["minRadiusVariance"]);
        pg.maxRadius = parseFloatNode(map["maxRadius"]);
        pg.maxRadiusVariance = parseFloatNode(map["maxRadiusVariance"]);
        pg.rotationStart = Math.degToRad(parseFloatNode(map["rotationStart"]));
        pg.rotationStartVariance = Math.degToRad(parseFloatNode(map["rotationStartVariance"]));
        pg.rotationEnd = Math.degToRad(parseFloatNode(map["rotationEnd"]));
        pg.rotationEndVariance = Math.degToRad(parseFloatNode(map["rotationEndVariance"]));
        pg.rotatePerSecond = Math.degToRad(parseFloatNode(map["rotatePerSecond"]));
        pg.rotatePerSecondVariance = Math.degToRad(parseFloatNode(map["rotatePerSecondVariance"]));
        pg.radialAcceleration = parseFloatNode(map["radialAcceleration"]);
        pg.radialAccelerationVariance = parseFloatNode(map["radialAccelVariance"]);
        pg.tangentialAcceleration = parseFloatNode(map["tangentialAcceleration"]);
        pg.tangentialAccelerationVariance = parseFloatNode(map["tangentialAccelVariance"]);
        var blendSrc = parseIntNode(map["blendFuncSource"]);
        var blendDst = parseIntNode(map["blendFuncDestination"]);
        pg.blendMode = ParticleLoader.toBlendMode(blendSrc, blendDst);
        pg.tile = ParticleLoader.loadTexture(map["texture"].get("data"), map["texture"].get("name"), path);
        pg.yCoordMultiplier = (parseIntNode(map["yCoordFlipped"]) == 1 ? -1.0 : 1.0);
        pg.headToVelocity = (parseIntNode(map["headToVelocity"]) == 1); // custom property
        pg.forceSquareTexture = true;

        return pg;
    }

    private static function parseIntNode(node : Xml) : Int {
        return (node == null ? 0 : parseIntString(node.get("value")));
    }

    private static function parseFloatNode(node : Xml) : Float {
        return (node == null ? 0 : parseFloatString(node.get("value")));
    }

    private static function parseVectorNode(node : Xml) : Vector {
        if (node == null) {
            return new Vector(0.0, 0.0);
        }

        return new Vector(
            parseFloatString(node.get("x")),
            parseFloatString(node.get("y"))
        );
    }

    private static function parseColorNode(node : Xml) : Vector {
        if (node == null) {
            return new Vector(0.0, 0.0, 0.0, 0.0);
        }

        return new Vector(
            parseFloatString(node.get("red")),
            parseFloatString(node.get("green")),
            parseFloatString(node.get("blue")),
            parseFloatString(node.get("alpha"))
        );
    }

    private static function parseIntString(s : String) : Int {
        if (s == null) {
            return 0;
        }

        var result = Std.parseInt(s);
        return (result == null ? 0 : result);
    }

    private static function parseFloatString(s : String) : Float {
        if (s == null) {
            return 0;
        }

        var result = Std.parseFloat(s);
        return (Math.isNaN(result) ? 0.0 : result);
    }
}
