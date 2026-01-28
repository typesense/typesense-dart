# 0.6.0

* Added support for Synonym Sets (v30.0+)
* Added support for Curation Sets (v30.0+)
* Added support for Refactored Analytics (v30.0+)
* Added support for Stopwords
* Added support for Conversations & Conversational Models
* Added support for Natural Language Search Models
* Added support for Stemming Dictionaries
* Updated dependencies

# 0.5.2

* Fixed dart analyze issues.
* Updated dependencies.

# 0.5.1

* Added `reference` property in `Field` class.

# 0.5.0

* Added support for nested object fields.
* Updated dependencies.

# 0.4.0

* Requires Dart 3.0 or later.
* Added `Presets` support.
* Updated dependencies.

# 0.3.1

* Added `dimensions` field to support creating a vector field in schema.

# 0.3.0+1

* Update README.

# 0.3.0

* Added support for collection update ([#118](https://github.com/typesense/typesense-dart/issues/118)).
* Updated models ([#120](https://github.com/typesense/typesense-dart/issues/120), [#125](https://github.com/typesense/typesense-dart/issues/125)).
* **Breaking Changes**
  * `Field.type` is an optional field now.

# 0.2.0

* Migrated to null safety.
* **Breaking Changes**
  * `apiKey` in `Configuration` constructor is a required parameter now.
  * `protocol` and `host` in `Node`'s default constructor are required parameters now.

# 0.1.1

* Made changes to support Typsense 0.21 [#89](https://github.com/typesense/typesense-dart/issues/89)
  * New field type `Type.geopoint` added.
  * `exportJSONL` now provides fine-grain control for exporting documents using `queryParams`.

# 0.1.0

* Initial development release.
