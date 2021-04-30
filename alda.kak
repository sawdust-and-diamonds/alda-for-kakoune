# alda
# ----

# Detection
# ---------
hook global BufCreate .*[.]alda %{
    set-option buffer filetype alda
}

# Initialization
# --------------

hook global WinSetOption filetype=alda %{
    require-module alda
    set-option buffer extra_word_chars '_' '-'

    hook window ModeChange pop:insert:.* -group alda-trim-indent alda-trim-indent 
    hook window InsertChar '\n' -group alda-indent alda-insert-newline
}

hook -group alda-highlight global WinSetOption filetype=alda %{
    add-highlighter window/alda ref alda
    hook -once -always window WinSetOption filetype=.* %{ remove-highlighter window/alda }
}

provide-module alda %{

# Highlighting
# ------------

add-highlighter shared/alda regions
add-highlighter shared/alda/code default-region group
add-highlighter shared/alda/comment region '#' '\n' fill comment
# add-highlighter shared/alda region '"' '(?<!\\)"' fill string
# add-highlighter shared/alda region '(' ')' fill clojure

# Can an instument's alias have any number of characters?
# Is there a better way to write a-zA-Z0-9_-?
#  What does \w mean, is it file dependent?
add-highlighter shared/alda/code/ regex ([a-zA-Z]{2,}[a-zA-Z0-9_]*) 0:attribute
add-highlighter shared/alda/code/ regex (vol(?:ume)?|pan(?:ning)?|tempo|quant(?:iz(?:ation|e))?|track-vol(?:ume)?|transpose|key-sig(?:nature)?)!?(\s+(?:[-+]?\d+)|(?:\s+\[[^\n\]]*\]))? 1:attribute 2:value
add-highlighter shared/alda/code/ regex \((vol(?:ume)?|pan(?:ning)?|tempo|quant(?:iz(?:ation|e))?|track-vol(?:ume)?|transpose|key-sig(?:nature)?)!?(\s+(?:[-+]?\d+)|(?:\s+\[[^\n\]]*\]))?\) 1:attribute 2:value
add-highlighter shared/alda/code/ regex \b([a-gr][+-]*)(\d*\.*(?:~\d*\.*)*)\b 1:default 2:default
add-highlighter shared/alda/code/ regex ([a-zA-Z][a-zA-Z0-9_-]*(\s*"[a-zA-Z0-9_-]*")?:)) 0:keyword
add-highlighter shared/alda/code/ regex ([vV][0-9]+:) 0:module
add-highlighter shared/alda/code/ regex (\|) 0:comment
add-highlighter shared/alda/code/ regex (>|<) 0:function
add-highlighter shared/alda/code/ regex (o\d+) 0:function
add-highlighter shared/alda/code/ regex (\*\d+) 0:value

# Commands
# --------

define-command alda-trim-indent -hidden -override %{
    execute-keys -draft -itersel <a-x> s \h+$ <ret> d
}

define-command alda-insert-newline -hidden -override %{
    nop # I am a noop
}

# End
# ---

}
