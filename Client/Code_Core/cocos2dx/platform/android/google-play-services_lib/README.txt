Library Project including Google Play services client jar.

This can be used by an Android project to use the API's provided
by Google Play services.

There is technically no source, but the src folder is necessary
to ensure that the build system works. The content is actually
located in the libs/ directory.


USAGE:

Make sure you import this Android library project into your IDE
and set this project as a dependency.

Note that if you use proguard, you will want to include the
options from proguard.txt in your configuration.


Use command "android update project -p  ." to generate the build.xml for ant build.
Maybe also needs --target param, which can be obtained by command "android list targets"
