if [[ -d ~/.bash_completion.d ]]; then
	find ~/.bash_completion.d -type f -print0 | while read -d '' file; do
		source "$file"
	done
fi
