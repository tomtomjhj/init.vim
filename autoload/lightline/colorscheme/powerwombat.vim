" powerline + wombat
let s:p = {'normal': {}, 'inactive': {}, 'insert': {}, 'replace': {}, 'visual': {}, 'tabline': {}}
let s:p.normal.left = [ ['darkestgreen', 'brightgreen', 'bold'], ['white', 'gray4'] ]
let s:p.normal.right = [ ['gray5', 'gray10'], ['gray9', 'gray4'], ['gray8', 'gray2'] ]
let s:p.inactive.right = [ ['gray1', 'gray5'], ['gray7', 'gray1'], ['gray5', 'gray0'] ]
let s:p.inactive.left = s:p.inactive.right[1:]
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
let s:p.normal.error = [ [ '#242424', '#e5786d', 235, 203 ] ]
let s:p.normal.warning = [ [ '#353535', '#cae682', 236, 180 ] ]

let g:lightline#colorscheme#powerwombat#palette = lightline#colorscheme#fill(s:p)
