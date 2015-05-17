**CHANGE LOG**
===================

v1.0.1

* Changed the method to get a resource for `find` instead of an explicit `where` with the id, to make it more compatible with another gems like `FriendlyId`


v1.0.0

* New feature when using rails 4. You can add method called `permited_attributes` to your model to set the permited attributes of the `params_resource` options. This method most return an array.

* The `params_resource` options passed as symbol no longer calls a method on the controller when using rails 4, instead it calls the params key, and expects that the model has a method named `permited_attributes` that returns an array of permited attributes for the `strong_parameters` gem.
* Fixed alot of bugs when using rails 4
* Added Rspec to start to make specs in the future

v0.2.0

* Added compatibility with grape gem and fixed some minor bugs
