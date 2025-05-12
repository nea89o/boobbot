module backronyms;
import std.stdio;
import std.algorithm;
import std.random;
import std.conv;
import std.range;
import std.typecons;

struct BackronymGenerator
{
	WordList nouns;
	WordList adjectives;

	static BackronymGenerator load()
	{
		return BackronymGenerator(
			WordList.fromFile("SimpleWordlists/Wordlist-Nouns-Common-Audited-Len-3-6.txt"),
			WordList.fromFile("SimpleWordlists/Wordlist-Adjectives-All.txt"),
		);
	}

	string formatBackronymList(string word)
	{
		string ret;
		for (int i = 0; i < word.length; i++)
		{
			ret ~= (
				i + 1 == word.length
					? this.nouns : this.adjectives
			).findRandomWord(word[i]);
			ret ~= '\n';
		}
		return ret;
	}
}

struct WordList
{

	string[][char] words;

	string[] findBackronym(string word)
	{
		string[] ret;

		foreach (c; word)
		{
			ret ~= this.findRandomWord(c);
		}

		return ret;
	}

	string findRandomWord(char start)
	{
		return this.words[start].choice;
	}

	static WordList fromFile(string filePath)
	{
		auto file = File(filePath);
		return fromLines(file.byLine.map!(to!string));
	}

	static WordList fromLines(R)(R lines)
			if (isInputRange!R && is(ElementType!R == string))
	{
		WordList ret;

		foreach (line; lines)
		{
			if (line.length == 0)
				continue;

			ret.words[line[0]] ~= line;
		}

		return ret;
	}

}
