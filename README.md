# alda-for-kak

Run the wonderful [alda](https://github.com/alda-lang/alda) musical programming language from inside the [kakoune](https://github.com/mawww/kakoune) editor. Make music with kak!

This is **v0.0.1** of a project which contains experimental features not found in other alda plug-ins, so no promises about it working well at this stage. Alda is fantastic, though, and I'm pretty confident you can be composing simple, catchy tunes in kak in no time by installing this plugin! More testing must be done to make sure all the advanced features of alda work as intended, however.

![Image of alda mode](https://i.ibb.co/71N5yQw/alda.png)

## Installation

You'll need to install alda, first of all, (and kakoune, obviously!) to make use of this plugin. (It can take a little bit of effort, because you have to install Java first, but the alda website does provide single executables you can simply save in your PATH.)

The recommended way to install *alda-for-kak* is using [plug.kak](https://github.com/andreyorst/plug.kak). Enter the command `plug-install sawdust-and-diamonds/alda-for-kak` and then put the following line into your kakrc:

```
plug "sawdust-and-diamonds/alda-for-kak"

```

If you'd prefer not to use plug, just pop the files into the autoload directory inside your kak config folder.

## Features

* A minimal syntax highlighting scheme for Alda.

*Not yet supported: In-line Clojure highlighting*

*Not yet supported: Alda formatting options*

* Play music written in kakoune via an Alda server running in the background.

* Open an alda REPL in tmux, or install your own plug-in to use the REPL whichever way you want.

* Without a REPL, save command history to replicate the same functionality.

* Manage the alda server and history file, clearing up saved data as needed. 

## Using the REPL

Alda offers a command line REPL-Read, Evaluate, Print loop-so you can write music in the alda language and hear the results immediately. As running a REPL is pretty complicated with kakoune, so far we only support the built-in *tmux-repl* function. If you're not using tmux you'll probably want to customize it, and there are a couple of ways to do that:

[kakoune-repl-buffer](https://gitlab.com/Screwtapello/kakoune-repl-buffer) by Screwtapello is an excellent tool which runs a REPL inside a kakoune buffer.

[kakoune-repl-bridge](https://github.com/jjk96/kakoune-repl-bridge) by JJK96 is another nifty plugin which can run a REPL and use a kak register as your 'interface', which can be very useful for e.g. testing computations.

*Yet to come: A more detailed explanation of how to use kakoune-repl-buffer for alda*

Still stuck on enabling the REPL? While having a REPL is nice, alda-for-kak has been designed not to need it, as the history feature makes it possible to save and update your temporary settings while composing:

## Playing music and using the history feature

Alda-for-kak makes it easier to roll without the REPL. Inside *alda mode* you can send selected text to Alda (default key: `t`), or instead the current cursor line(s) (default key: `l`) or even the entire buffer (default key: `f`).

If you're just trying to play a string of notes, you probably won't hear anything:

```
o5 c4 < c8 c d4 c2 b4 > c
[AlDA-SERVER] No sound...
```

Why's that? Because we haven't selected an instrument (or rather, a voice) to play our melodies. That makes it pretty difficult to randomly play different snippets of music as you're composing melody lines, doesn't it? After all, you don't want to prefix every note with an instrument value. Well, we can actually pass our desired state to alda as a *history* value. Alda-for-kak lets you manage and update this history, so, if your history file contains something like this:

```
piano: o3 c d e f g
```

then, anything you send will follow on from that point—you'll default to the playing with the piano from the third octave (o3). Alda mode lets you append selections (default key: `y`), lines (default key: `l`), or the whole buffer for the current file (default key: `b`) to your history. You can use `Ctrl+h` to clear or `h` to switch to your history buffer. To play your current selections without including the history, the default key binding is a capital `T` from within alda mode.

## Inspiration

`alda-for-kak` takes heavy inspiration from [alda-mode](https://gitlab.com/jgkamat/alda-mode) for Emacs. The history feature in both utilities is very similar, but I can't say it's a shameless imitation—in the case of kak, it's difficult enough to create a REPL inside the editor that I wanted to use the history buffer to get around the need for a REPL entirely, making it more of a core feature.

## License

I'm releasing this under the MIT license, unless alda-mode decide to sue me for copyright breach! Hopefully everything in this current implementation will count as original.
