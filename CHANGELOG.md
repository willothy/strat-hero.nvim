# Changelog

## 1.0.0 (2024-03-08)


### Features

* add game over screen ([50f1089](https://github.com/willothy/strat-hero.nvim/commit/50f10893ed306989840a3d3df856204b7ab12b4b))
* add initial UI with progress bar ([34707bb](https://github.com/willothy/strat-hero.nvim/commit/34707bbb5744f378b0c328c339ef45f356285e64))
* add rounds and transitions ([9ea3838](https://github.com/willothy/strat-hero.nvim/commit/9ea383823bd9f681c81c86dcc151bb2fe6925d91))
* handle timeoutlen to prevent delays ([a131a85](https://github.com/willothy/strat-hero.nvim/commit/a131a8538112e01ed15d69e9b21a69316223c4f0))
* initial commit ([2a0aaf2](https://github.com/willothy/strat-hero.nvim/commit/2a0aaf20edf523202ae2d72fa8c4931bd8bad3d8))
* main game loop, sequence rendering ([672f54a](https://github.com/willothy/strat-hero.nvim/commit/672f54afa33e099ba14983c6358c4eb0ff65e71c))
* more game-accurate scoring ([21c9e61](https://github.com/willothy/strat-hero.nvim/commit/21c9e61f2cde826eb1737db43ac7e9ff1ed5584c))
* red highlight for 300ms on mistake ([15d885a](https://github.com/willothy/strat-hero.nvim/commit/15d885ae8b7138ace7e243b3c79bfd3404122140))
* starting state with countdown, reflect state in UI ([6b2372f](https://github.com/willothy/strat-hero.nvim/commit/6b2372f6eb2d4de10af15fadcf105b4bf1ef8a1a))
* timer abstraction for game loop ([6d871f5](https://github.com/willothy/strat-hero.nvim/commit/6d871f574056aa923b74bb0478a030809999df44))


### Bug Fixes

* possible infinite loop in `Game:pick_stratagem` ([3242371](https://github.com/willothy/strat-hero.nvim/commit/3242371b7696357bf895c9afb722edac9a38b6a3))
* reset `did_fail` in `Game:on_key` ([68d8efc](https://github.com/willothy/strat-hero.nvim/commit/68d8efc09290bb47d482d348c3e8d82244e61316))
