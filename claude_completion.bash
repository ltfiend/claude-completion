# Bash completion for Claude Code CLI
# https://claude.ai/code
#
# Installation:
#   source /path/to/claude_completion.bash
#
# Or copy to /etc/bash_completion.d/ or ~/.local/share/bash-completion/completions/

_claude_completion() {
    local cur prev words cword
    _init_completion || return

    # Build command chain for subcommand detection
    local cmd_chain=()
    local i
    for ((i = 1; i < cword; i++)); do
        case "${words[i]}" in
            -*) ;; # skip flags
            *)  cmd_chain+=("${words[i]}") ;;
        esac
    done

    local subcmd="${cmd_chain[0]:-}"
    local subcmd2="${cmd_chain[1]:-}"

    # ── Top-level subcommands ──
    local subcommands="agents auth auto-mode doctor install mcp plugin plugins remote-control setup-token update upgrade"

    # ── Top-level flags ──
    local top_flags="
        --add-dir
        --agent
        --agents
        --allow-dangerously-skip-permissions
        --allowedTools --allowed-tools
        --append-system-prompt
        --append-system-prompt-file
        --bare
        --betas
        --brief
        --chrome
        -c --continue
        --dangerously-skip-permissions
        -d --debug
        --debug-file
        --disable-slash-commands
        --disallowedTools --disallowed-tools
        --effort
        --fallback-model
        --file
        --fork-session
        --from-pr
        -h --help
        --ide
        --include-partial-messages
        --input-format
        --json-schema
        --max-budget-usd
        --max-turns
        --mcp-config
        --mcp-debug
        --model
        -n --name
        --no-chrome
        --no-session-persistence
        --output-format
        --permission-mode
        --plugin-dir
        -p --print
        --rc --remote-control
        --replay-user-messages
        -r --resume
        --session-id
        --setting-sources
        --settings
        --strict-mcp-config
        --system-prompt
        --system-prompt-file
        --tmux
        --tools
        --verbose
        -v --version
        -w --worktree
    "

    # ── Handle subcommand completions ──

    # auth
    if [[ "$subcmd" == "auth" ]]; then
        case "$subcmd2" in
            login)
                COMPREPLY=($(compgen -W "--claudeai --console --email --sso --help -h" -- "$cur"))
                return
                ;;
            logout)
                COMPREPLY=($(compgen -W "--help -h" -- "$cur"))
                return
                ;;
            status)
                COMPREPLY=($(compgen -W "--json --text --help -h" -- "$cur"))
                return
                ;;
            *)
                COMPREPLY=($(compgen -W "login logout status help" -- "$cur"))
                return
                ;;
        esac
    fi

    # auto-mode
    if [[ "$subcmd" == "auto-mode" ]]; then
        case "$subcmd2" in
            config|defaults)
                COMPREPLY=($(compgen -W "--help -h" -- "$cur"))
                return
                ;;
            critique)
                COMPREPLY=($(compgen -W "--help -h" -- "$cur"))
                return
                ;;
            *)
                COMPREPLY=($(compgen -W "config critique defaults help" -- "$cur"))
                return
                ;;
        esac
    fi

    # mcp
    if [[ "$subcmd" == "mcp" ]]; then
        case "$subcmd2" in
            add)
                COMPREPLY=($(compgen -W "--callback-port --client-id --client-secret -e --env -H --header -s --scope -t --transport --help -h" -- "$cur"))
                # Complete --scope and --transport values
                if [[ "$prev" == "--scope" || "$prev" == "-s" ]]; then
                    COMPREPLY=($(compgen -W "local user project" -- "$cur"))
                elif [[ "$prev" == "--transport" || "$prev" == "-t" ]]; then
                    COMPREPLY=($(compgen -W "stdio sse http" -- "$cur"))
                fi
                return
                ;;
            add-json)
                COMPREPLY=($(compgen -W "--client-secret -s --scope --help -h" -- "$cur"))
                if [[ "$prev" == "--scope" || "$prev" == "-s" ]]; then
                    COMPREPLY=($(compgen -W "local user project" -- "$cur"))
                fi
                return
                ;;
            add-from-claude-desktop)
                COMPREPLY=($(compgen -W "--help -h" -- "$cur"))
                return
                ;;
            get|list)
                COMPREPLY=($(compgen -W "--help -h" -- "$cur"))
                return
                ;;
            remove)
                COMPREPLY=($(compgen -W "-s --scope --help -h" -- "$cur"))
                if [[ "$prev" == "--scope" || "$prev" == "-s" ]]; then
                    COMPREPLY=($(compgen -W "local user project" -- "$cur"))
                fi
                return
                ;;
            reset-project-choices)
                COMPREPLY=($(compgen -W "--help -h" -- "$cur"))
                return
                ;;
            serve)
                COMPREPLY=($(compgen -W "-d --debug --verbose --help -h" -- "$cur"))
                return
                ;;
            *)
                COMPREPLY=($(compgen -W "add add-from-claude-desktop add-json get help list remove reset-project-choices serve" -- "$cur"))
                return
                ;;
        esac
    fi

    # plugin / plugins
    if [[ "$subcmd" == "plugin" || "$subcmd" == "plugins" ]]; then
        case "$subcmd2" in
            install|i)
                COMPREPLY=($(compgen -W "-s --scope --help -h" -- "$cur"))
                if [[ "$prev" == "--scope" || "$prev" == "-s" ]]; then
                    COMPREPLY=($(compgen -W "user project local" -- "$cur"))
                fi
                return
                ;;
            uninstall|remove)
                COMPREPLY=($(compgen -W "-s --scope --keep-data --help -h" -- "$cur"))
                if [[ "$prev" == "--scope" || "$prev" == "-s" ]]; then
                    COMPREPLY=($(compgen -W "user project local" -- "$cur"))
                fi
                return
                ;;
            enable)
                COMPREPLY=($(compgen -W "-s --scope --help -h" -- "$cur"))
                if [[ "$prev" == "--scope" || "$prev" == "-s" ]]; then
                    COMPREPLY=($(compgen -W "user project local" -- "$cur"))
                fi
                return
                ;;
            disable)
                COMPREPLY=($(compgen -W "-a --all -s --scope --help -h" -- "$cur"))
                if [[ "$prev" == "--scope" || "$prev" == "-s" ]]; then
                    COMPREPLY=($(compgen -W "user project local" -- "$cur"))
                fi
                return
                ;;
            update)
                COMPREPLY=($(compgen -W "-s --scope --help -h" -- "$cur"))
                if [[ "$prev" == "--scope" || "$prev" == "-s" ]]; then
                    COMPREPLY=($(compgen -W "user project local managed" -- "$cur"))
                fi
                return
                ;;
            list)
                COMPREPLY=($(compgen -W "--available --json --help -h" -- "$cur"))
                return
                ;;
            validate)
                _filedir
                return
                ;;
            marketplace)
                local mp_subcmd="${cmd_chain[2]:-}"
                case "$mp_subcmd" in
                    add)
                        COMPREPLY=($(compgen -W "--scope --sparse --help -h" -- "$cur"))
                        if [[ "$prev" == "--scope" ]]; then
                            COMPREPLY=($(compgen -W "user project local" -- "$cur"))
                        fi
                        return
                        ;;
                    remove|rm)
                        COMPREPLY=($(compgen -W "--help -h" -- "$cur"))
                        return
                        ;;
                    update)
                        COMPREPLY=($(compgen -W "--help -h" -- "$cur"))
                        return
                        ;;
                    list)
                        COMPREPLY=($(compgen -W "--json --help -h" -- "$cur"))
                        return
                        ;;
                    *)
                        COMPREPLY=($(compgen -W "add help list remove rm update" -- "$cur"))
                        return
                        ;;
                esac
                ;;
            *)
                COMPREPLY=($(compgen -W "disable enable help install i list marketplace uninstall remove update validate" -- "$cur"))
                return
                ;;
        esac
    fi

    # agents
    if [[ "$subcmd" == "agents" ]]; then
        COMPREPLY=($(compgen -W "--setting-sources --help -h" -- "$cur"))
        return
    fi

    # doctor
    if [[ "$subcmd" == "doctor" ]]; then
        COMPREPLY=($(compgen -W "--help -h" -- "$cur"))
        return
    fi

    # install
    if [[ "$subcmd" == "install" ]]; then
        if [[ "$cur" == -* ]]; then
            COMPREPLY=($(compgen -W "--force --help -h" -- "$cur"))
        else
            COMPREPLY=($(compgen -W "stable latest" -- "$cur"))
        fi
        return
    fi

    # update / upgrade
    if [[ "$subcmd" == "update" || "$subcmd" == "upgrade" ]]; then
        COMPREPLY=($(compgen -W "--help -h" -- "$cur"))
        return
    fi

    # remote-control
    if [[ "$subcmd" == "remote-control" ]]; then
        COMPREPLY=($(compgen -W "--capacity -n --name --sandbox --no-sandbox --spawn --verbose --help -h" -- "$cur"))
        if [[ "$prev" == "--spawn" ]]; then
            COMPREPLY=($(compgen -W "same-dir worktree" -- "$cur"))
        fi
        return
    fi

    # setup-token
    if [[ "$subcmd" == "setup-token" ]]; then
        COMPREPLY=($(compgen -W "--help -h" -- "$cur"))
        return
    fi

    # ── Handle flag value completions ──
    case "$prev" in
        --model|--fallback-model)
            COMPREPLY=($(compgen -W "sonnet opus haiku claude-sonnet-4-6 claude-opus-4-6 claude-haiku-4-5-20251001" -- "$cur"))
            return
            ;;
        --effort)
            COMPREPLY=($(compgen -W "low medium high max auto" -- "$cur"))
            return
            ;;
        --permission-mode)
            COMPREPLY=($(compgen -W "default acceptEdits plan auto bypassPermissions dontAsk" -- "$cur"))
            return
            ;;
        --output-format)
            COMPREPLY=($(compgen -W "text json stream-json" -- "$cur"))
            return
            ;;
        --input-format)
            COMPREPLY=($(compgen -W "text stream-json" -- "$cur"))
            return
            ;;
        --tools)
            COMPREPLY=($(compgen -W "default Bash Read Edit Write Glob Grep WebFetch WebSearch Agent NotebookEdit" -- "$cur"))
            return
            ;;
        --setting-sources)
            COMPREPLY=($(compgen -W "user project local user,project user,project,local user,local project,local" -- "$cur"))
            return
            ;;
        --add-dir|--plugin-dir)
            _filedir -d
            return
            ;;
        --mcp-config|--settings|--system-prompt-file|--append-system-prompt-file|--debug-file)
            _filedir
            return
            ;;
        --tmux)
            COMPREPLY=($(compgen -W "classic" -- "$cur"))
            return
            ;;
    esac

    # ── Complete flags or subcommands ──
    if [[ "$cur" == -* ]]; then
        COMPREPLY=($(compgen -W "$top_flags" -- "$cur"))
    elif [[ ${#cmd_chain[@]} -eq 0 ]]; then
        # No subcommand yet - offer both subcommands and flags
        COMPREPLY=($(compgen -W "$subcommands" -- "$cur"))
    fi
}

complete -o default -o bashdefault -F _claude_completion claude
