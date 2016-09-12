# v1.1.0 (2016/09/12)

## Enhancements

* Remove the dependency on faraday, using `Net::HTTP`. [#39](https://github.com/rakuten-ws/rws-ruby-sdk/pull/39)
* Allows users to rescue any exception with `RakutenWebService::Error` which is a superclass of all the error class like `RakutenWebService::NotFound`. [#41](https://github.com/rakuten-ws/rws-ruby-sdk/pull/41)

# v1.0.0 (2016/07/29)

## Enhancements

* Upgrade the version of RSpec and refactoring the configuration. [#36](https://github.com/rakuten-ws/rws-ruby-sdk/pull/36) and [#37](https://github.com/rakuten-ws/rws-ruby-sdk/pull/36)

# v1.0.0.rc1

## Enhancements

* Started supporting Gora APIs by @kamatama41 .[#29](https://github.com/rakuten-ws/rws-ruby-sdk/pull/29)
* Started supporting Recipe APIs. [#31](https://github.com/rakuten-ws/rws-ruby-sdk/pull/31)
* Updated versions of supported Rakuten Web Service APIs.

## Compatibility Changes

* Updated supported Ruby versions to 2.1.0 or later
* Any resource's `search` such as `RakutenWebService::Ichiba::Item` returns Enumerator which provides resources fetched at one page.
  It used to provide all resources by auto-pagerize. From this version provides methods for pagerizing. Please refer to [the sample in README](https://github.com/rakuten-ws/rws-ruby-sdk/blob/master/README.md#pagerizing).
* Deprecated calling `RakutenWebService.configuration` with a block, recommending to use `RakutenWebService.configure`.

## Thanks

At first, I should appreciate all users of the gems.
One of the enhancements, supporting Gora APIs, is realized by @kamatama41 's seminal work.
Thank you for your contribution!

# v0.6.3 (2015/07/03)

* Update a gem dependency by @45deg
* Fix typo by @45deg
* Add new section for `Prerequisites` to explaing how to get new Application ID for Rakuten Web Service.
* `RakutenWebService::BaseGenre.[]` fetches the genre information of specified a given genrecode.
