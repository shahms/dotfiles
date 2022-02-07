if [[ -d ~/.bash_completion.d ]]; then
	for file in "$(find ~/.bash_completion.d -type f)"; do
		source "$file"
	done
fi
