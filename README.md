# Mosaic4Mobile

This is a proof of concept version of MOSAIC that runs on an android smartphone.

We use a modified version of MOSAIC and its dependences that run natively on Android. For the user interface we use Flutter. The data between native Android code and Flutter code is transmitted using JSON over Native Method Channels.

## dependencies

To compile this project, we need the following dependencies:
- a modified version of mosaic that supports the android run time.
- a DuckDB JDBC driver that supports android

Lucene uses `java.lang.ClassValue`. This was available in Java since version 7. In the Android Runtime, it was added with API level 34 (i.e. Android 14). Make sure that the `minSdkVersion` is set to `34` in `app/build.gradle`.

### modifying MOSAIC for android

For Android we don't need the web api. Since this is provided by the quarkus library, we can remove this dependency and all classes that use quarkus. This just leaves us the with the Java methods for performing a search, thats just what we need.

Additionally, the Android Runtime only supports features of Java version 8. The latest lucene version that runs on Java 8 is Lucene 8. We need to downgrade from Lucene 9 to Lucene 8 to make it run on the Android Runtime. This requires a few little changes in the source code, but nothing major.

Finally, we need to build DuckDB using the Android NDK for arm64-v8a. Using this version we need to build the DuckDB-Java wrapper to use as a JDBC driver.

See commit a1e1b793b8c55b0fe6ce8d3eff73967c7d863ebc [link](https://opencode.it4i.eu/openwebsearcheu-public/mosaic-android/-/tree/a1e1b793b8c55b0fe6ce8d3eff73967c7d863ebc) for the exact changes made to the MOSAIC source code.

This modified version of MOSAIC is then built, packaged and installed in the local maven repository. By adding `mavenLocal()` to our repositories in `build.gradle` we can include MOSAIC as a dependency in our Android project:
```
implementation ('eu.ows.mosaic:core:1.0-SNAPSHOT')  
implementation ('eu.ows.mosaic:analyzer:1.0-SNAPSHOT')  
implementation ('eu.ows.mosaic:query:1.0-SNAPSHOT')  
implementation ('eu.ows.mosaic:geo:1.0-SNAPSHOT')  
implementation ('eu.ows.mosaic:keywords:1.0-SNAPSHOT')
```

#### building DuckDB for android

We modify the CMakeLists.txt and the Makefile to build DuckDB with the android NDK. See [commit](https://github.com/NeXTormer/duckdb-java/commit/45fdac6f864b12d6a5dfa4380fb3cd129f0f1531) for details. Make sure to replace the paths to the Android NDK to your own paths.

Make sure to include the generated `duckdb_jdbc.jar` in the `app/build.gradle` as a dependency. Simply setting it as a dependency of the MOSAIC maven project will not work.

## running the app

Since MOSAIC uses plain java to read the required files, we need to put the files into a directory that plain java can read as well.
This involves copying the necessary files (bundled in the APK) to local storage. See [this file](https://opencode.it4i.eu/openwebsearcheu-public/mosaic4mobile/-/blob/master/android/app/src/main/java/eu/ows/mosaicformobile/mosaic_for_mobile/MosaicInterface.java?ref_type=heads) for implementation details.

Most of the pre-built Lucene indices only support Lucene 9. To support Lucene 8, we need to modify the `lucene-ciff` importer. This involves changing the dependencies to Lucene 8 instead of 9, [updating the source code accordingly](https://github.com/NeXTormer/lucene-ciff/commit/bc1fcaa51bde7290ec2778bdec12b0549341e7f7#diff-aa57f8188ee9692668dd34ea4f6e8d0274bb5576307c2a132ec004c3b4a51e12) and compiling the project. Be sure to correctly include the dependencies `anserini` and `ciff tools` as stated in the `lucene-ciff` readme, otherwise it will not work.

We can now modify MOSAICs build.sh script to use the custom lucene-ciff importer and re-import our desired indices. These indices will now work with Lucene 8.
