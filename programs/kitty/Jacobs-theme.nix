{config, ...}:
with config.colorScheme.colors; ''
# name: Jacobs Nix Theme
# author: Jacob Pyke

foreground                      #${base06}
background                      #${base00}
# selection_foreground            #000000
# selection_background            #fffacd


#: Cursor colors

cursor                          #${base06}
cursor_text_color               #${base06}


#: URL underline color when hovering with mouse

# url_color                       #0087bd


#: kitty window border colors and terminal bell colors

# active_border_color             #00ff00
# inactive_border_color           #cccccc
# bell_border_color               #ff5a00
# visual_bell_color               none


#: OS Window titlebar colors

wayland_titlebar_color          #${base00}
macos_titlebar_color            #${base00}


#: Tab bar colors

# active_tab_foreground           #000
# active_tab_background           #eee
# inactive_tab_foreground         #444
# inactive_tab_background         #999
# tab_bar_background              none
# tab_bar_margin_color            none


#: Colors for marks (marked text in the terminal)

# mark1_foreground black
# mark1_background #98d3cb
# mark2_foreground black
# mark2_background #f2dcd3
# mark3_foreground black
# mark3_background #f274bc


#: The basic 16 colors

#: black
color0 #${base00}
color8 #${base02}

#: red
color1 #${base08}
color9 #${base08}

#: green
color2  #${base0B}
color10 #${base0B}

#: yellow
color3  #${base0A}
color11 #${base0A}

#: blue
color4  #${base0D}
color12 #${base0D}

#: magenta
color5  #${base0E}
color13 #${base0E}

#: cyan
color6  #${base0C}
color14 #${base0C}

#: white
color7  #${base05}
color15 #${base07}
''
