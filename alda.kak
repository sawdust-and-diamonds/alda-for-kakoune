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
}

hook -group alda-highlight global WinSetOption filetype=alda %{
    add-highlighter window/alda ref alda
    hook -once -always window WinSetOption filetype=.* %{ remove-highlighter window/alda }
}

provide-module alda %{

# Highlighting
# ------------

# There's not a lot going on here, partly because I don't have the full specification for
# the alda language. I've asked the author for more details, but otherwise this is stuff
# to be worked on iteratively.

# Alda 2.0 is coming soon!
# So when that's released, there'll no doubt be better information, and I'll have to really
# get this plugin polished...

add-highlighter shared/alda regions
add-highlighter shared/alda/code default-region group
add-highlighter shared/alda/comment region '#' '\n' fill comment

# Todo: Inline clojure
# add-highlighter shared/alda region '(' ')' fill clojure

# Any valid alda named parameters 
add-highlighter shared/alda/code/ regex ([a-zA-Z]{2,}[a-zA-Z0-9_]*) 0:attribute
# Built-inattributes
add-highlighter shared/alda/code/ regex (vol(?:ume)?|pan(?:ning)?|tempo|quant(?:iz(?:ation|e))?|track-vol(?:ume)?|transpose|key-sig(?:nature)?)!?(\s+(?:[-+]?\d+)|(?:\s+\[[^\n\]]*\]))? 1:attribute 2:value
# Global attributes
add-highlighter shared/alda/code/ regex \((vol(?:ume)?|pan(?:ning)?|tempo|quant(?:iz(?:ation|e))?|track-vol(?:ume)?|transpose|key-sig(?:nature)?)!?(\s+(?:[-+]?\d+)|(?:\s+\[[^\n\]]*\]))?\) 1:attribute 2:value
# Notes
add-highlighter shared/alda/code/ regex \b([a-gr][+-]*)(\d*\.*(?:~\d*\.*)*)\b 1:default 2:default
# Instruments
add-highlighter shared/alda/code/ regex ([a-zA-Z][a-zA-Z0-9_-]*(\s*"[a-zA-Z0-9_-]*")?:)) 0:keyword
# Voices
add-highlighter shared/alda/code/ regex ([vV][0-9]+:) 0:module
# Bar lines
add-highlighter shared/alda/code/ regex (\|) 0:comment
# Octaves
add-highlighter shared/alda/code/ regex (>|<) 0:function
add-highlighter shared/alda/code/ regex (o\d+) 0:function
# Repetitions
add-highlighter shared/alda/code/ regex (\*\d+) 0:value

# Commands
# --------

# TODO: As I'm not aware if alda requires indentation, I'm leaving this empty for now.
#       An interesting idea from the Emacs plugin is to allow formatting alda, into, for
#		example, rows and columns.

# define-command alda-trim-indent -hidden -override %{
#     nop
# }

# define-command alda-insert-newline -hidden -override %{
#     nop
# }

}
