#import "themeBootlin.typ": *
// Linux Elixir commands
#let kfunc(body) = [
  [
  #codelink([#link("https://elixir.bootlin.com/linux/latest/ident/"+ body) ])
  ]
]


#let kfunc2(body) = [
  #codelink([#link("https://elixir.bootlin.com/linux/latest/ident/"+ body)])
]

#let kfunc3(body) = [
  #codelink(#link)
]