# CHANGELOG

## v1.13.2 (2023/03/26)

### Improvements

- Fixes broken links in README for Japanese [#140](https://github.com/rakuten-ws/rws-ruby-sdk/pull/140)
- Fixes broken links in README [#141](https://github.com/rakuten-ws/rws-ruby-sdk/pull/141)

### Thanks

@ryosuke-endo gave the pull-request #140. This realized me that some links in README had been broken.
Thanks :tada:

## v1.13.1 (2021/09/02)

### Improvements

- Fixed the issue when item can't be found by specifying elements [#132](https://github.com/rakuten-ws/rws-ruby-sdk/pull/132)
- Removed abolished methods from sample codes in README [#131](https://github.com/rakuten-ws/rws-ruby-sdk/pull/131)
- Migrated CI for this repo from Travis CI to GitHub Actions [#130](https://github.com/rakuten-ws/rws-ruby-sdk/pull/130)
- Add ruby 3.0 support [#129](https://github.com/rakuten-ws/rws-ruby-sdk/pull/129)

## v1.13.0 (2020/10/15)

### Enhancements

- Adds `RakutenWebService::Ichiba::Tab.search` [#112](https://github.com/rakuten-ws/rws-ruby-sdk/pull/112)

### Improvements

- Adds `rexml` to development dependencies to run tests in ruby 3.0 [#127](https://github.com/rakuten-ws/rws-ruby-sdk/pull/127)
- Abolishes integration spec [#126](https://github.com/rakuten-ws/rws-ruby-sdk/pull/126)
- Suppresses deprecation warning for bundle install's option [#125](https://github.com/rakuten-ws/rws-ruby-sdk/pull/125)
- Updates README.ja.md by fuyuton [#124](https://github.com/rakuten-ws/rws-ruby-sdk/pull/124)
- Removes comment out by 4geru [#123](https://github.com/rakuten-ws/rws-ruby-sdk/pull/123)
- Use instance variable in ichiba item example code by 4geru [#122](https://github.com/rakuten-ws/rws-ruby-sdk/pull/122)
- Updates .travis.yml by 4geru [#121](https://github.com/rakuten-ws/rws-ruby-sdk/pull/121)
- Adds recipe example code by @4geru [#119](https://github.com/rakuten-ws/rws-ruby-sdk/pull/119) [#120](https://github.com/rakuten-ws/rws-ruby-sdk/pull/120)
- Drop v2.4 from supported ruby versions [#118](https://github.com/rakuten-ws/rws-ruby-sdk/pull/118)
- Update supported ruby versions: welcome ruby 2.7 [#117](https://github.com/rakuten-ws/rws-ruby-sdk/pull/117)
- Inserts frozen string literal comments to travel api codes [#113](https://github.com/rakuten-ws/rws-ruby-sdk/pull/113)
- Refactoring: Extract process from `Travel::Areaclass::Base` constructor [#114](https://github.com/rakuten-ws/rws-ruby-sdk/pull/114)
- Refactoring: decompose `RakutenWebService::Resource.attribute` to reduce its complexity [#115](https://github.com/rakuten-ws/rws-ruby-sdk/pull/115)
- Refactoring: fix some style issues [#116](https://github.com/rakuten-ws/rws-ruby-sdk/pull/116)

### Thanks

We are pleased to say thanks to @4geru and @fuyuton. This release includes their seminal works.
Thanks :tada:

## v1.12.0 (2019/09/09)

### Enhancements

- Starts Support Ichiba Tag API. [#110](https://github.com/rakuten-ws/rws-ruby-sdk/pull/110)

### Thanks

We are pleased to say thanks to @keisukeponpoko. This release is made by their seminal work.

## v1.11.0 (2019/07/11)

### Improvements

* Drop ruby 2.3 from supported ruby versions. [#104](https://github.com/rakuten-ws/rws-ruby-sdk/pull/104)
* Fixes some issues reported by CoceClimate [#108](https://github.com/rakuten-ws/rws-ruby-sdk/pull/108)
* `RWS.configuration` no longer accepsts block [#107](https://github.com/rakuten-ws/rws-ruby-sdk/pull/107)

## v1.10.0 (2019/03/11)

### Enhancements

* Starts Support of two Travel APIs: SimpleHotelSearch and GetAreaClass. [#91](https://github.com/rakuten-ws/rws-ruby-sdk/pull/91)

## v1.9.2 (2018/12/28)

### Enhancements

* Ruby 2.6 has been released :tada: this version joined the supported versions! [#100](https://github.com/rakuten-ws/rws-ruby-sdk/pull/100)

## v1.9.1 (2018/03/30)

### Improvements

* Use the magic comment to frozen all string literals.[#93](https://github.com/rakuten-ws/rws-ruby-sdk/pull/93)
* Drop ruby 2.2 from supported ruby versions since it goes to the EOL. [#95](https://github.com/rakuten-ws/rws-ruby-sdk/pull/95)

## v1.9.0 (2018/01/04)

### Enhancements

* Update supported API versions. [#87](https://github.com/rakuten-ws/rws-ruby-sdk/pull/87)

## v1.8.0 (2017/12/30)

### Enhancements

* Add `RWS::Resource#attributes` method. [#85](https://github.com/rakuten-ws/rws-ruby-sdk/pull/85)

### Improvements

* Start supporting Ruby 2.5 and drop 2.1 from supported versions. [#83](https://github.com/rakuten-ws/rws-ruby-sdk/pull/83)
* Update outdated gems. [#84](https://github.com/rakuten-ws/rws-ruby-sdk/pull/84)

## v1.7.0 (2017/09/17)

### Enhancements

* Add Helpers for pagination. [#78](https://github.com/rakuten-ws/rws-ruby-sdk/pull/78)

### Improvements

* Minor fix for README.ja.md [#77](https://github.com/rakuten-ws/rws-ruby-sdk/pull/77)
* Suppressing installing gems required for debugging with VSCode in CI. [#79](https://github.com/rakuten-ws/rws-ruby-sdk/pull/79)

### Thanks

I'm pleasured to say thanks to @jinco13. He fixed wrong method names and links in README.ja.md.

## v1.6.1 (2017/08/21)

### Bug Fix

* `RakutenWebService::Ichiba::Genre#brothers` always returns an empty array. [#75](https://github.com/rakuten-ws/rws-ruby-sdk/pull/75)

## v1.6.0 (2017/08/16)

### Improvements

* Added `RakutenWebService::BaseGenre#brothers`. [#74](https://github.com/rakuten-ws/rws-ruby-sdk/pull/74)

## v1.5.0 (2017/03/31)

### Improvements

* Allows to call `RakutenWebService::Recipe.ranking` without `category_id`. [#70](https://github.com/rakuten-ws/rws-ruby-sdk/pull/70)

### Thanks

I'm pleasured to say thanks to @kakakakakku. His work has made the usage of `RWS::Recipe.raning` easy to get the ranking in all genres.
Thanks!

## v1.4.2 (2017/01/22)

### Bug Fixes

* `Net::HTTP` is NOT `reuquire`d anywhere in the codebase. [#67](https://github.com/rakuten-ws/rws-ruby-sdk/pull/67)

   The version 1.4.1 or earlier of this gem doesn't `require 'net/http'` by itself.
   @gouf found the bug report in [teratail](https://teratail.com/questions/62804) and made a pull-request to fix it. Thanks!

### Improvements

* `debug_mode` has come again! if you want to see responses from Rakuten Web Service APIs, you can see the ones by set `debug_mode` `true`. [#56](https://github.com/rakuten-ws/rws-ruby-sdk/pull/56)
* Refactoring: use new Hash syntax as supporting ruby 1.9 series has been stopped already. [#60](https://github.com/rakuten-ws/rws-ruby-sdk/pull/60)

## v1.4.1 (2016/11/22)

### Bug Fix

* Fixed: `WrongParameter` raises when giving any `sort` option to `RakutenWebService::Resource.serch`. [#54](https://github.com/rakuten-ws/rws-ruby-sdk/pull/54)

### Thanks

I'm pleased to say thanks to @sho-yamane since he reported the bug #53. If he didn't do it, I would find the bug much later.
Thanks, @sho-yamane.

## v1.4.0 (2016/11/11)

### Enhancements

* Raise RuntimeError if required option `application_id` is not set when generating parameters. [#51](https://github.com/rakuten-ws/rws-ruby-sdk/pull/51)

## v1.3.0 (2016/11/08)

### Enhancements

* Loads Application ID and Affiliate ID from environment varaibles `RWS_APPLICATION_ID` and `RWS_AFFILIATE_ID` respectively. [#47](https://github.com/rakuten-ws/rws-ruby-sdk/pull/47)

### Improvements

* Upgraded `codeclimate-test-reporter`. [#48](https://github.com/rakuten-ws/rws-ruby-sdk/pull/48)

## v1.2.0 (2016/10/25)

### Ehancements

* Started supporting GenreInformation. [#45](https://github.com/rakuten-ws/rws-ruby-sdk/pull/45)
* `RakutenWebService::BaseGenre#parent` returns Genre object of the parent genre. [#44](https://github.com/rakuten-ws/rws-ruby-sdk/pull/44)

## v1.1.1 (2016/09/12)

### Bug Fix

* Fixed `RakutenWebService::Ichiba::Genre#ranking` ignores given options to be passed to Ichiba Ranking API. [#43](https://github.com/rakuten-ws/rws-ruby-sdk/pull/43)

## v1.1.0 (2016/09/12)

### Enhancements

* Remove the dependency on faraday, using `Net::HTTP`. [#39](https://github.com/rakuten-ws/rws-ruby-sdk/pull/39)
* Allows users to rescue any exception with `RakutenWebService::Error` which is a superclass of all the error class like `RakutenWebService::NotFound`. [#41](https://github.com/rakuten-ws/rws-ruby-sdk/pull/41)

## v1.0.0 (2016/07/29)

### Enhancements

* Upgrade the version of RSpec and refactoring the configuration. [#36](https://github.com/rakuten-ws/rws-ruby-sdk/pull/36) and [#37](https://github.com/rakuten-ws/rws-ruby-sdk/pull/36)

## v1.0.0.rc1

### Enhancements

* Started supporting Gora APIs by @kamatama41 .[#29](https://github.com/rakuten-ws/rws-ruby-sdk/pull/29)
* Started supporting Recipe APIs. [#31](https://github.com/rakuten-ws/rws-ruby-sdk/pull/31)
* Updated versions of supported Rakuten Web Service APIs.

### Compatibility Changes

* Updated supported Ruby versions to 2.1.0 or later
* Any resource's `search` such as `RakutenWebService::Ichiba::Item` returns Enumerator which provides resources fetched at one page.
  It used to provide all resources by auto-pagerize. From this version provides methods for pagerizing. Please refer to [the sample in README](https://github.com/rakuten-ws/rws-ruby-sdk/blob/master/README.md#pagerizing).
* Deprecated calling `RakutenWebService.configuration` with a block, recommending to use `RakutenWebService.configure`.

### Thanks

At first, I should appreciate all users of the gems.
One of the enhancements, supporting Gora APIs, is realized by @kamatama41 's seminal work.
Thank you for your contribution!

## v0.6.3 (2015/07/03)

* Update a gem dependency by @45deg
* Fix typo by @45deg
* Add new section for `Prerequisites` to explaing how to get new Application ID for Rakuten Web Service.
* `RakutenWebService::BaseGenre.[]` fetches the genre information of specified a given genrecode.
