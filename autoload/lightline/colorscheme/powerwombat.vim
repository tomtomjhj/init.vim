" powerline + wombat

" cache the result. lightline#colorscheme#fill is slow
let g:lightline#colorscheme#powerwombat#palette = {'inactive': {'right': [['#262626', '#606060', 235, 241], ['#8a8a8a', '#262626', 245, 235], ['#606060', '#121212', 241, 233]], 'left': [['#8a8a8a', '#262626', 245, 235], ['#606060', '#121212', 241, 233]]}, 'replace': {'right': [['#606060', '#d0d0d0', 241, 252], ['#bcbcbc', '#585858', 250, 240], ['#9e9e9e', '#303030', 247, 236]], 'middle': [['#8a8a8a', '#303030', 245, 236]], 'left': [['#ffffff', '#df0000', 231, 160, 'bold'], ['#ffffff', '#585858', 231, 240]]}, 'normal': {'right': [['#606060', '#d0d0d0', 241, 252], ['#bcbcbc', '#585858', 250, 240], ['#9e9e9e', '#303030', 247, 236]], 'middle': [['#8a8a8a', '#303030', 245, 236]], 'warning': [['#353535', '#d7af87', 236, 180]], 'left': [['#005f00', '#afdf00', 22, 148, 'bold'], ['#ffffff', '#585858', 231, 240]], 'error': [['#242424', '#ff5f5f', 235, 203]]}, 'tabline': {'right': [['#a8a8a8', '#666666', 248, 242]], 'middle': [['#a8a8a8', '#444444', 248, 238]], 'left': [['#d0d0d0', '#666666', 252, 242]], 'tabsel': [['#d0d0d0', '#262626', 252, 235]]}, 'visual': {'left': [['#870000', '#ff8700', 88, 208, 'bold'], ['#ffffff', '#585858', 231, 240]]}, 'insert': {'right': [['#005f5f', '#87dfff', 23, 117], ['#87dfff', '#0087af', 117, 31], ['#87dfff', '#005f87', 117, 24]], 'middle': [['#87dfff', '#005f87', 117, 24]], 'left': [['#005f5f', '#ffffff', 23, 231, 'bold'], ['#ffffff', '#0087af', 231, 31]]}, 'command': {'left': [['#005f5f', '#ffffff', 23, 231, 'bold'], ['#ffffff', '#585858', 231, 240]]}}
finish

let s:p = {'normal': {}, 'inactive': {}, 'command': {}, 'insert': {}, 'replace': {}, 'visual': {}, 'tabline': {}}
let s:p.normal.left = [ ['darkestgreen', 'brightgreen', 'bold'], ['white', 'gray4'] ]
let s:p.normal.right = [ ['gray5', 'gray10'], ['gray9', 'gray4'], ['gray8', 'gray2'] ]
let s:p.inactive.right = [ ['gray1', 'gray5'], ['gray7', 'gray1'], ['gray5', 'gray0'] ]
let s:p.inactive.left = s:p.inactive.right[1:]
let s:p.command.left = [ ['darkestcyan', 'white', 'bold'], ['white', 'gray4'] ]
let s:p.insert.left = [ ['darkestcyan', 'white', 'bold'], ['white', 'darkblue'] ]
let s:p.insert.right = [ [ 'darkestcyan', 'mediumcyan' ], [ 'mediumcyan', 'darkblue' ], [ 'mediumcyan', 'darkestblue' ] ]
let s:p.replace.left = [ ['white', 'brightred', 'bold'], ['white', 'gray4'] ]
let s:p.visual.left = [ ['darkred', 'brightorange', 'bold'], ['white', 'gray4'] ]
let s:p.normal.middle = [ [ 'gray7', 'gray2' ] ]
let s:p.insert.middle = [ [ 'mediumcyan', 'darkestblue' ] ]
let s:p.replace.middle = s:p.normal.middle
let s:p.replace.right = s:p.normal.right
let s:p.tabline.left = [ [ '#d0d0d0', '#666666', 252, 242 ] ]
let s:p.tabline.tabsel = [ [ 'gray10', 'gray1' ] ]
let s:p.tabline.middle = [ [ '#a8a8a8', '#444444', 248, 238 ] ]
let s:p.tabline.right = [ [ '#a8a8a8', '#666666', 248, 242 ] ]
let s:p.normal.error = [ [ '#242424', '#ff5f5f', 235, 203 ] ]
let s:p.normal.warning = [ [ '#353535', '#d7af87', 236, 180 ] ]

let g:lightline#colorscheme#powerwombat#palette = lightline#colorscheme#fill(s:p)
