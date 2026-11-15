# Hand edits layered over the wizard style, which the tide run_onchange
# script sets as universals. Globals shadow them, so these survive a
# rerun of `tide configure`.

set -g tide_context_always_display true
# jj (functions/_tide_item_jj.fish) replaces git.
set -g tide_left_prompt_items pwd newline character
set -g tide_right_prompt_items jj status cmd_duration context jobs direnv bun node python java php pulumi ruby go gcloud kubectl distrobox toolbox terraform aws nix_shell crystal elixir zig
set -g tide_jj_bg_color 444444
set -g tide_jj_color white
set -g tide_jj_icon
