# v1.0.0.rc1

## Enhancements

* Started supporting Gora APIs. Thank you for your contribution @kamatama41 .[#29](https://github.com/rakuten-ws/rws-ruby-sdk/pull/29)
* Started supporting Recipe APIs.
* Updated versions of supported Rakuten Web Service APIs.

## Compatibility Changes

* Updated supported Ruby versions to 2.1.0 or later
* Any resource's `search` such as `RakutenWebService::Ichiba::Item` returns Enumerator which provides resources fetched at one page.
  It used to provide all resources by auto-pagerize. From this version provides methods for pagerizing. Please refer to [the sample in README](https://github.com/rakuten-ws/rws-ruby-sdk/blob/master/README.md#pagerizing).
* Deprecated calling `RakutenWebService.configuration` with a block, recommending to use `RakutenWebService.configure`.

# v0.6.3

* Update a gem dependency by @45deg
* Fix typo by @45deg
* Add new section for `Prerequisites` to explaing how to get new Application ID for Rakuten Web Service.
* `RakutenWebService::BaseGenre.[]` fetches the genre information of specified a given genrecode.
