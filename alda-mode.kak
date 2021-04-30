###############################################################################
#                              Alda for Kakoune                               #
###############################################################################
# v.0.0.1 - Very basic implementation!
# What would you like to see in this plugin? Let me know!

# TODO: Autocomplete / reference for midi instruments
#       Clojure in-line highlighting
#       Test all alda featuresd-do they survive the journey to the command line?

# Options
# -------

# We can set a custom path to the Alda binary with this option
declare-option -hidden str alda_binary_path alda

# Basic commands
# --------------

define-command alda-start-server -override -docstring %{
    Start an alda server for running your alda-mode commands in the background.
} %{ nop %sh{ $kak_opt_alda_binary_path up }}

define-command alda-restart -override -docstring %{
    Restart the background alda server, stopping playback and clearing any idle processes.
} %{ nop %sh{ $kak_opt_alda_binary_path downup }}

define-command alda-play-text -override -docstring %{
    Play the selected text in Alda. 
} %{ nop %sh{
    err=$(printf "$kak_selection" | $kak_opt_alda_binary_path play)
    err=$(echo "$err" | tail -n 1 | grep -i 'error')
    echo "echo '$err'"
}}

define-command alda-play-text-with-history -override -docstring %{
    Play the selected text in alda, passing (but not playing) any data from your history file. 
} %{
    eval -save-regs a %{
        exec -draft -buffer *alda-history* '% "ay'
        nop %sh{
            err=$(printf "$kak_selection" | $kak_opt_alda_binary_path play -i "$kak_reg_a")
            err=$(echo "$err" | tail -n 1 | grep -i 'error')
            echo "echo '$err'"
        }
    }
}

define-command alda-play-file -override -docstring %{
    Play the current file in a connected alda REPL.
} %{
    eval -save-regs a %{
        exec -draft '% "ay'
        eval %sh{
            # Clear out comments which break the interpreter
            buf_text=$(echo "$kak_reg_a" | sed -r -e 's/\#([^\(\{].*$)?//g')
            err=$(printf "$buf_text" | $kak_opt_alda_binary_path play)
            err=$(echo "$err" | tail -n 1 | grep -i 'error')
            echo "echo '$err'"
        }
    }
}}

define-command alda-stop -override -docstring %{
    Stop alda's current playback.
        } %{ nop %sh{ $kak_opt_alda_binary_path stop }}

# REPL commands
# -------------

define-command open-alda-repl -override -docstring %{
    Open an Alda REPL in a new window.
} %{
    eval %sh{
        [ -z "$TMUX" ] && exit;
        # If you're not using tmux, please repleace this and the above line with your preferred
        # means of opening a REPL window.
        echo "tmux-repl-horizontal"
        echo "repl-send-text '$kak_opt_alda_binary_path repl\n'"
    }
}

define-command run-in-alda-repl -override -docstring %{
    Run selected text as an alda command in a connected Alda REPL.
} %{
    eval %sh{
        sel=$(printf "$kak_selection") # Strip trailing newline
        echo "repl-send-text '$sel\n'" # Print with certain newline
    }
}

define-command edit-in-alda-repl -override -docstring %{
    Send selected text to the repl, without any newlines, for editing
} %{
    eval %sh{
        sel=$(printf "$kak_selection")   # Strip trailing newline
        sel=$(echo "$sel" | tr '\n' ' ') # Turn other newlines into spaces
        echo "repl-send-text '$sel'"     # Print without newline
    }
}

# History management
# ------------------

define-command alda-open-history -override -docstring %{
    Open the history buffer.
    Kakoune can save your command history as you work with alda. These will be sent using alda's '-i' option, along with your text any time you send a command to the background alda server. This means you can work with state without having to open a REPL.
} %{ e -scratch *alda-history*}

define-command alda-add-text-to-history -override -docstring %{
    Append the currently selected text to kak's saved alda history.
} %{
    try %{ eval -draft e -scratch *alda-history* }
    eval -itersel -save-regs a %{
        exec -draft '"ay'
        exec -buffer *alda-history* gj"ap
        alda-trim-history-buffer
    }
}

define-command alda-append-buffer-to-history -override -docstring %{
    Append text contents of the current buffer to kak's saved alda history.
} %{
    try %{ eval -draft e -scratch *alda-history* }
    eval -save-regs a %{
        exec -draft '% "ay'
        exec -buffer *alda-history* gj"ap
        alda-trim-history-buffer
    }
}

define-command alda-add-line-to-history -override -docstring %{
    Append the current line(s) to kak's saved alda history.
} %{
    try %{ eval -draft e -scratch *alda-history* }
    eval -itersel -save-regs a %{
        exec -draft '<a-x>"ay'
        exec -buffer *alda-history* gj"ap
        alda-trim-history-buffer
    }
}

define-command -hidden alda-trim-history-buffer -override -docstring %{
    Trim the history buffer of newlines from top and bottom
} %{
    try %{ exec -draft -buffer *alda-history* '% /\A\n+<ret><a-d>' }
    try %{ exec -draft -buffer *alda-history* '% /\n+\z<ret><a-d>' }
}

define-command alda-clear-history -override -docstring %{
    Clear the history contents.
} %{ exec -buffer *alda-history* '% <a-d>' }

# Key bindings for alda-mode
# --------------------------

declare-user-mode alda
map -docstring "Start alda server in background"     global alda a ':alda-start-server<ret>'
map -docstring "Stop alda"                           global alda s ':stop-alda<ret>'
map -docstring "Restart alda"                        global alda <c-a> ':alda-restart<ret>'
map -docstring "Play file in buffer"                 global alda f ':alda-play-file<ret>'
map -docstring "Play text with history"              global alda t ':alda-play-text-with-history<ret>'
map -docstring "Play text without history"           global alda T ':alda-play-text<ret>'
map -docstring "Open alda REPL"                      global alda A ':open-alda-repl<ret>'
map -docstring "Run in alda REPL"                    global alda r ':run-in-alda-repl<ret>'
map -docstring "Edit in alda REPL"                   global alda e ':edit-in-alda-repl<ret>'
map -docstring "Open the history buffer"             global alda h ':alda-open-history<ret>'
map -docstring "Append selection(s) to history"      global alda y ':alda-add-text-to-history<ret>'
map -docstring "Append line(s) to history"           global alda l ':alda-add-line-to-history<ret>'
map -docstring "Append buffer to history"            global alda b ':alda-append-buffer-to-history<ret>'
map -docstring "Clear history file"                  global alda <c-h> ':alda-clear-history<ret>'
