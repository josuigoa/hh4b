package nw;

extern class App {

	public static var argv(default, never) : Array<String>;
	public static var dataPath(default, never) : String;
	public static function on( event : String, callb : String -> Void ) : Void;

}