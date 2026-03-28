# claude-completion

Bash tab-completion for the [Claude Code](https://claude.ai/code) CLI.

## Features

- Completes top-level flags (`--model`, `--permission-mode`, `--output-format`, etc.)
- Completes subcommands: `auth`, `auto-mode`, `mcp`, `plugin`, `agents`, `doctor`, `install`, `update`, and more
- Completes nested subcommands (e.g. `claude mcp add --transport`)
- Completes flag values where applicable (model names, permission modes, output formats, etc.)
- File/directory completion for path-based flags
- Works with both `claude` and `cc` commands

## Installation

### Quick

```bash
source /path/to/claude_completion.bash
```

Add the line above to your `~/.bashrc` to load it on every shell session.

### System-wide

```bash
sudo cp claude_completion.bash /etc/bash_completion.d/claude
```

### Per-user

```bash
cp claude_completion.bash ~/.local/share/bash-completion/completions/claude
```

## Usage

Type `claude` followed by <kbd>Tab</kbd> to see available completions:

```bash
claude --m<Tab>        # completes --model, --max-turns, etc.
claude mcp <Tab>       # shows: add add-json get list remove serve ...
claude auth lo<Tab>    # completes: login logout
claude --model <Tab>   # shows: sonnet opus haiku ...
```

## Requirements

- Bash with `bash-completion` loaded (`_init_completion` must be available)

## License

MIT
