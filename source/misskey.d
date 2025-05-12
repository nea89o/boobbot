module misskey;
import requests;
import std.logger;
import std.format;
import std.conv;
import jsonizer;

class MisskeyException : Exception
{

	string path;
	Response response;
	this(
		Response response,
		string path,
		string msg,
		string file = __FILE__, size_t line = __LINE__)
	{
		super("at path " ~ path ~ ": " ~ msg, file, line);
		this.response = response;
		this.path = path;
	}
}

class MisskeyClient
{
	string instanceUrl;
	string token;
	this(string instanceUrl, string token)
	{
		this.instanceUrl = instanceUrl;
		this.token = token;
		assert(token.length != 0);
		assert(instanceUrl.length != 0);
	}

	T request(string method, string path, T, R)(R body)
	{
		static assert(path[0] == '/');
		auto req = Request();
		req.addHeaders([
			"user-agent": "boobbot",
			"authorization": format("Bearer %s", this.token)
		]);
		auto fullPath = format("%s/api%s", this.instanceUrl, path);
		auto reqBody = toJSONString!R(body);
		infof("Executing request to %s with headers %s", fullPath, req.headers);
		Response response = mixin("req." ~ method)(
			fullPath,
			reqBody,
			"application/json"
		);
		if (response.code / 100 != 2)
			throw new MisskeyException(response, path, format("non 200 status code: %s", response
					.code));
		return fromJSONString!T(to!string(response.responseBody));
	}

	CreateNoteResponse createNote(BasicNote note)
	{
		return this.request!("post", "/notes/create", CreateNoteResponse, BasicNote)(note);
	}

}

class BasicNote
{
	mixin JsonizeMe;

	@jsonize(Jsonize.opt)
	{
		string visibility;
		string text;
		string id;
	}

	this()
	{
	}

	this(string visibility, string text)
	{
		this.visibility = visibility;
		this.text = text;
		this.id = "";
	}

}

class CreateNoteResponse
{
	mixin JsonizeMe;

	@jsonize
	BasicNote createdNote;
}

/*
curl https://sk.amy.rip/api/notes/create \
  --request POST \
  --header 'Content-Type: application/json' \
  --header 'Authorization: Bearer aaaaaaaaaa' \
  --data '{
  "visibility": "public",
  "visibleUserIds": [
    ""
  ],
  "cw": null,
  "localOnly": false,
  "reactionAcceptance": null,
  "noExtractMentions": false,
  "noExtractHashtags": false,
  "noExtractEmojis": false,
  "replyId": null,
  "renoteId": null,
  "channelId": null,
  "text": null,
  "fileIds": [
    ""
  ],
  "mediaIds": [
    ""
  ],
  "poll": {
    "choices": [
      ""
    ],
    "multiple": true,
    "expiresAt": null,
    "expiredAfter": null
  }
}'
*/
