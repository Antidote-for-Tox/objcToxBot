[![Circle CI](https://circleci.com/gh/Antidote-for-Tox/objcToxBot.svg?style=svg)](https://circleci.com/gh/Antidote-for-Tox/objcToxBot)

# objcToxBot

[Tox](https://tox.chat/) bot for iOS.

This bot is made for testing [objcTox](https://github.com/Antidote-for-Tox/objcTox) library and [Antidote](https://github.com/Antidote-for-Tox/Antidote). I'm not sure if it would be usable for something else.

## Downloads

1. Clone repo `git clone https://github.com/Antidote-for-Tox/objcToxBot.git`
2. Install CocoaPods `pod install`
3. Open `objcToxBot.xcworkspace` file with Xcode 5+.

## Contribution

Before contributing please check [style guide](objective-c-style-guide.md).

objcToxBot is using [Uncrustify](http://uncrustify.sourceforge.net/) code beautifier. Before creating pull request please run it.

You can install it with [Homebrew](http://brew.sh/):

```
brew install uncrustify
```

After installing you can:

- check if there are any formatting issues with

```
./run-uncrustify.sh --check
```

- apply uncrustify to all sources with

```
./run-uncrustify.sh --apply
```

There is also git `pre-commit` hook. On committing if there are any it will gently propose you a patch to fix them. To install hook run

```
ln -s ../../pre-commit.sh .git/hooks/pre-commit
```

## Author

Dmytro Vorobiov, d@dvor.me

## License

objcToxBot is available under the MIT license. See the [LICENSE](LICENSE) file for more info.

