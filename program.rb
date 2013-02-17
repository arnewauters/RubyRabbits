require_relative 'world'
STDOUT.sync = true

require "curses"
include Curses

def onsig(sig)
  close_screen
  exit sig
end

# main #
for i in 1 .. 15  # SIGHUP .. SIGTERM
  if trap(i, "SIG_IGN") != 0 then  # 0 for SIG_IGN
    trap(i) {|sig| onsig(sig) }
  end
end

init_screen

unless has_colors?
		endwin
		print("Your terminal does not support color\n");
		exit(1);
end

start_color
init_pair(COLOR_WHITE,COLOR_WHITE,COLOR_BLACK)
init_pair(COLOR_RED,COLOR_RED,COLOR_BLACK)
init_pair(COLOR_GREEN,COLOR_GREEN,COLOR_BLACK)

nl
noecho

World.new()
