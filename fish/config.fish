# Load pyenv automatically
status --is-interactive; and source (pyenv init - | psub)
status --is-interactive; and pyenv init - | source
status --is-interactive; and pyenv virtualenv-init | source

set -g theme_display_virtualenv yes

# Add back bash sudo !! functionality
function sudo
	if test "$argv" = !!
		eval command sudo $history[1]
	else
		command sudo $argv
	end
end
