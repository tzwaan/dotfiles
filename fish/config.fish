# Load pyenv automatically
status --is-interactive; and source (pyenv init - | psub)
status --is-interactive; and pyenv init - | source
status --is-interactive; and source (pyenv virtualenv-init -|psub)


set -g theme_display_virtualenv yes

# Add back bash sudo !! functionality
function sudo
	if test "$argv" = !!
		eval command sudo $history[1]
	else
		command sudo $argv
	end
end


function vim
    if command -s nvim > /dev/null
        nvim $argv
    else
        command vim $argv
    end
end

function ovim
    command vim $argv
end
