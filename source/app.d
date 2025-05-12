import std.stdio;
import backronyms;
import misskey;
import std.process;
import std.logger;
void main()
{
	globalLogLevel = LogLevel.trace;
	info("Hello world");
	auto generator = BackronymGenerator.load;
	auto misskey = new MisskeyClient(
		environment.get("MISSKEY_INSTANCE"),
		environment.get("MISSKEY_TOKEN")
	);

	auto boobFormat = "boob is short for\n\n" ~ generator.formatBackronymList("boob");
	writefln("-- dry --\n%s", boobFormat);
	writefln("%s", misskey.createNote(new BasicNote("public", boobFormat)));
}
