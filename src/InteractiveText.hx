@:publicFields
class InteractiveText extends h2d.Object {
	var tf:h2d.Text;
	var interactive:h2d.Interactive;

	public var text(get, set):String;

	function get_text():String {
		return tf.text;
	}

	function set_text(text:String):String {
		tf.text = text;
		tf.x = (interactive.width - tf.textWidth) * .5;
		tf.y = (interactive.height - tf.textHeight) * .5;
		return text;
	}

	public function new(font:h2d.Font, textWidth:UInt, textHeight:UInt, bg:Bool = true, ?parent, ?onclick:Void->Void) {
		super(parent);

		interactive = new h2d.Interactive(textWidth, textHeight, this);
		tf = new h2d.Text(font, this);
		if (bg)
			interactive.backgroundColor = 0xAA912691;

		interactive.onClick = (e:hxd.Event) -> {
			if (onclick != null) {
				onclick();
			} else {
				if (text == Main.inst.getCurrentName()) {
					var absPos = getAbsPos().getPosition();
					var absScale = getAbsPos().getScale().x;
					var px = absPos.x + e.relX * absScale;
					var py = absPos.y + e.relY * absScale;
					Main.inst.correctAnswerClicked(px, py);
				} else {
					Shake.run(this);
				}
			}
		};
	}
}
