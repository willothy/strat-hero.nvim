<!-- panvimdoc-ignore-start -->
<h1 align='center'>
  strat-hero.nvim
</h1>

<p align='center'>
  Practice your Helldivers 2 stratagems in Neovim. For Super Earth!
</p>

https://github.com/willothy/strat-hero.nvim/assets/38540736/016b6d41-63c2-4c0d-9d97-cfe166e2fecc


<!-- panvimdoc-ignore-end -->

## Installation

With [`folke/lazy.nvim`](https://github.com/folke/lazy.nvim):

```lua
require("lazy").setup({
  {
    "willothy/strat-hero.nvim",
    config = true,
    lazy = true,
    cmd = "StratHero"
  }
})
```

## Commands

#### `:StratHero[!]`

Opens the game UI if it is not already open. Does nothing if the UI is open or the game is running.

When `:h <bang>` is provided, toggles the game UI, regardless of whether the game is running. Interrupts game progress.

#### `:StratHero open`

Starts the game if it has not already been started. Does nothing if the game is running.

#### `:StratHero start`

Starts the game if it has not already been started. Does nothing if the game is running.

#### `:StratHero stop`

Stops an in-progress game, but does not close the UI.

#### `:StratHero close`

Stops any in-progress game and closes the UI.

## Mappings

You may play the game using `wasd`, `hjkl`, or the arrow keys. Motions to lock users into one input mode will be added in the future.

To start the game from the UI, press any motion key (`wasd`, `hjkl`, or the arrow keys) while the game is not running.

When a game is not running, either `q` or `<Esc>` will close the UI. If the game is running, only `<Esc>` will close the UI to prevent from accidentally quitting the game.

When you make a mistake and see the red highlight, you can *immediately* start the stratagem over. The delay is only visual and will be interrupted when
you enter a correct motion.

## Contributing

I would love to hear your feedback and ideas! I would also welcome contributions, especially ones helping to keep the stratagem list up-to-date with Helldivers 2.
