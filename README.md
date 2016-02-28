# dollybot

This is a simple telegram bot written because I wanted to try
implementing a server in OCaml that handles JSON data. It took awhile
to figure out how to use
[Async](https://opensource.janestreet.com/async/) but I had a lot of
fun and I'm happy with how pleasant it has been to code in OCaml,
especially once you've [set it up
properly](https://github.com/realworldocaml/book/wiki/Installation-Instructions).
[Real World OCaml](https://realworldocaml.org/) and
[mjambon/atdgen](https://github.com/mjambon/atdgen) were really
helpful in helping me understand how to do this.

The bot responds with a photo of Dolly whenever `/dolly` is sent.

### Who is Dolly?

Dolly is a dog that I lived with during my semester abroad at UT
Austin. She shares the same love for ice cream as I do and I thought
it'd be great if I could respond with her photos in my telegram chats.

![Dolly](https://user-images.githubusercontent.com/3874336/73587012-a8059780-44f0-11ea-826e-6463b544f0d7.jpg)

## Installing

You'll have to [create your own Telegram
Bot](https://core.telegram.org/bots#botfather) and set then [set up a
webhook](https://core.telegram.org/bots/api#setwebhook) so that
Telegram will forward messages sent to your bot. The server sends a
photo's `file_id` in response to `POST` requests from Telegram so
you'll have to upload some photos first and then update the `match`
statement in `handle_dolly`.

```bash
> ./make.sh
> ocamlrun server.byte
```
