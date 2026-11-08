# zed-teal

A [Teal](https://github.com/teal-language/tl) (a typed dialect of Lua) extension for [Zed](https://zed.dev).

> [!NOTE]
> This is an unofficial extension, not affiliated with the Teal project. I built it with AI assistance for my own use and maintain it in my spare time. Bug reports and PRs are welcome. If you'd like to help maintain it, open an issue.

## Features

Works out of the box, with nothing else to install:

- Syntax highlighting for `.tl` files, using the highlight queries from [tree-sitter-teal](https://github.com/euclidianAce/tree-sitter-teal), adapted to Zed's capture names

Requires [teal-language-server](https://github.com/teal-language/teal-language-server) (see [Language server](#language-server)):

- Diagnostics (type errors and warnings)
- Completion
- Hover
- Go to definition

## Language server

Language features need `teal-language-server`, which you install yourself. The extension does **not** download it. It uses, in order:

1. The path set in your Zed settings (`lsp.teal-language-server.binary.path`)
2. `teal-language-server` on your `PATH`

To install it, follow the [teal-language-server installation instructions](https://github.com/teal-language/teal-language-server#installation). It also installs the Teal compiler (`tl`) it uses, so you don't need to install Teal separately.

The extension looks for the server on the `PATH` of the project's shell environment; for remote projects (SSH, WSL) that's the remote machine. If Zed doesn't find a server you just installed, restart Zed.

To use a specific executable, or to pass arguments, add this to your Zed `settings.json`:

```jsonc
{
  "lsp": {
    "teal-language-server": {
      "binary": {
        "path": "/path/to/teal-language-server",
        "arguments": []
      }
    }
  }
}
```

If you only want highlighting and don't want Zed to report that the server is missing, turn it off:

```jsonc
{
  "languages": {
    "Teal": {
      "language_servers": ["!teal-language-server", "..."]
    }
  }
}
```

## Indentation

Teal files default to 3-space indentation, the style used by Teal itself. This overrides your global `tab_size`. To change it:

```jsonc
{
  "languages": {
    "Teal": {
      "tab_size": 4
    }
  }
}
```

## Development

To develop this extension, see the [Developing Extensions](https://zed.dev/docs/extensions/developing-extensions) section of the Zed docs.

## Credits

- Grammar and highlight queries: [euclidianAce/tree-sitter-teal](https://github.com/euclidianAce/tree-sitter-teal) (MIT)

## License

[MIT](LICENSE). Files taken from tree-sitter-teal keep their original license; see [THIRD_PARTY_NOTICES.md](THIRD_PARTY_NOTICES.md).
