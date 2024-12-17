#!/opt/homebrew/bin/fish

# -*- tab-width: 2; encoding: utf-8 -*-

#= file: $HOME/.config/fish/conf.d/fish-abbrfile.fish


#= Create abbreviations for every entry in `abbreviations`.
#= [github/jabirali/ fish-abbrfile](https://github.com/jabirali/fish-abbrfile)
#= > [github/jabirali/ fish-abbrfile](https://github.com/LaurentFough/fish-abbrfile)

set -q MY_ABBRS_INITIALIZED; and return

if test -f $FDOTDIR/abbr.d/__abbreviations.fconf;
	for abbrLine in ( sed '/^#/d' $FDOTDIR/abbr.d/__abbreviations.fconf )
		set --local abbrDict ( string split ' ' -- $abbrLine )

		if [ ( count $abbrDict ) -ge 2 ];
			#= Abbreviation that should trigger expansion.
				set --local abbrKey ( string trim -- $abbrDict[1] )

			#= Command to run when the triggering happens.
				set --local abbrVal ( string trim -- (string join ' ' -- $abbrDict[2..-1]) )

			#= Only define abbreviation if the command is valid. This makes it
			#= possible to e.g. abbreviate `vi` to `vim` on systems where `vim`
			#= is available, but use the real `vi` if `vim` is not installed.
			set --local abbrCmd ( string split --no-empty ' ' -- $abbrVal )

			if [ $abbrCmd[1] = "sudo" ];
			#= Sudo detected. Check the next argument to see how to proceed.
				if type -q $abbrCmd[2];
					abbr -a -g $abbrKey $abbrVal
				end
			else

				#= Sudo not detected. Just check the first argument of the command.
				if type -q $abbrCmd[1]
					abbr -a -g $abbrKey $abbrVal
				end
			end

		else if [ -n "$abbrLine" ];
			echo "[abbrfile] Could not parse \"$abbrLine\"."

		end
	end
end

#= no need to run over-and-over
set -g MY_ABBRS_INITIALIZED true


# vim:ft=fish
