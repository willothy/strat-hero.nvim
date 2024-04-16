# Changelog

## [1.0.1](https://github.com/willothy/strat-hero.nvim/compare/v1.0.0...v1.0.1) (2024-04-16)


### Bug Fixes

* add timeout before move keys restart the game ([1cc5a10](https://github.com/willothy/strat-hero.nvim/commit/1cc5a105cbb8c15996e241383d5bfc64a8445252))

## 1.0.0 (2024-04-02)


### Features

* add `StratHero` command ([a975ac6](https://github.com/willothy/strat-hero.nvim/commit/a975ac6e28701ac0a800fb85405f7c2bb604c9e8))
* add game over screen ([50f1089](https://github.com/willothy/strat-hero.nvim/commit/50f10893ed306989840a3d3df856204b7ab12b4b))
* add initial UI with progress bar ([34707bb](https://github.com/willothy/strat-hero.nvim/commit/34707bbb5744f378b0c328c339ef45f356285e64))
* add round end ui view ([75a5d35](https://github.com/willothy/strat-hero.nvim/commit/75a5d35440b957e9b5b24546f881c226bcb22d28))
* add rounds and transitions ([9ea3838](https://github.com/willothy/strat-hero.nvim/commit/9ea383823bd9f681c81c86dcc151bb2fe6925d91))
* add subcommands for for `StratHero` ([9b3c9c8](https://github.com/willothy/strat-hero.nvim/commit/9b3c9c8d693b1fe8c44524bea110a738464f1028))
* handle timeoutlen to prevent delays ([a131a85](https://github.com/willothy/strat-hero.nvim/commit/a131a8538112e01ed15d69e9b21a69316223c4f0))
* improve bonuses and round_end ui ([dc1bf53](https://github.com/willothy/strat-hero.nvim/commit/dc1bf537d7107521bb87c5331db62e9ee78f9ef2))
* initial commit ([2a0aaf2](https://github.com/willothy/strat-hero.nvim/commit/2a0aaf20edf523202ae2d72fa8c4931bd8bad3d8))
* main game loop, sequence rendering ([672f54a](https://github.com/willothy/strat-hero.nvim/commit/672f54afa33e099ba14983c6358c4eb0ff65e71c))
* more game-accurate scoring ([21c9e61](https://github.com/willothy/strat-hero.nvim/commit/21c9e61f2cde826eb1737db43ac7e9ff1ed5584c))
* red highlight for 300ms on mistake ([15d885a](https://github.com/willothy/strat-hero.nvim/commit/15d885ae8b7138ace7e243b3c79bfd3404122140))
* round-end view and bonus for time remaining ([4978678](https://github.com/willothy/strat-hero.nvim/commit/4978678238ebfa37b541c19b8233b301c84f4ada))
* starting state with countdown, reflect state in UI ([6b2372f](https://github.com/willothy/strat-hero.nvim/commit/6b2372f6eb2d4de10af15fadcf105b4bf1ef8a1a))
* timer abstraction for game loop ([6d871f5](https://github.com/willothy/strat-hero.nvim/commit/6d871f574056aa923b74bb0478a030809999df44))


### Bug Fixes

* possible infinite loop in `Game:pick_stratagem` ([3242371](https://github.com/willothy/strat-hero.nvim/commit/3242371b7696357bf895c9afb722edac9a38b6a3))
* reset `did_fail` in `Game:on_key` ([68d8efc](https://github.com/willothy/strat-hero.nvim/commit/68d8efc09290bb47d482d348c3e8d82244e61316))
* state-dependent command ([9d737e3](https://github.com/willothy/strat-hero.nvim/commit/9d737e36f1129b869600fb6774a963e07fc0c16d))
