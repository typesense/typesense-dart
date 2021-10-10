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