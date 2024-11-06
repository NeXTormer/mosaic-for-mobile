package eu.ows.mosaicformobile.mosaic_for_mobile;

import android.content.Context;
import android.content.res.AssetManager;
import android.os.Build;
import android.util.Log;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import com.google.gson.JsonArray;
import com.google.gson.JsonObject;

import org.apache.lucene.index.DirectoryReader;
import org.apache.lucene.index.IndexReader;
import org.apache.lucene.queryparser.classic.ParseException;
import org.apache.lucene.store.FSDirectory;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import eu.ows.mosaic.CoreUtils;
import eu.ows.mosaic.DbConnection;
import eu.ows.mosaic.PluginManager;
import eu.ows.mosaic.ResourceManager;
import eu.ows.mosaic.SearchUtils;

public class MosaicInterface {


    public static void print(String text) {
        Log.d("M4M", text);
    }


    public static void startMosaic(Context context) {
        logAndroidRuntimeVersion();
        print("Starting MOSAIC....");
        print("copying assets...");
        copyAssets(context);
        print("finished copying assets");

        String pathPrefix = context.getFilesDir().getAbsolutePath();
        print("Path Prefix: " + pathPrefix);

        CoreUtils.setIndexDirPath(pathPrefix + "/lucene/");
        CoreUtils.setParquetDirPath(pathPrefix + "/resources/");
        CoreUtils.setIdColumn(CoreUtils.DEFAULT_ID_COLUMN);
        CoreUtils.setConfigFilePath(pathPrefix + "/config/config.json");
        CoreUtils.setDatabaseFilePath(pathPrefix + "/tmp/mosaic_db");

        PluginManager.getInstance().loadComponents();
        PluginManager.getInstance().loadModules();


        print("Creating db....");
        DbConnection dbConn = null;
        try {
            dbConn = new DbConnection(false);
            dbConn.createTables(200L);
        } catch (SQLException e) {
            print(e.toString());
            throw new RuntimeException(e);
        }
        dbConn.closeConnection();

        print("SUCCESSFULLY created DB");
        print("MOSAIC search service started. Waiting for requests...");
    }

    public static String performSearch(String query) throws SQLException, ParseException, IOException {
        Map<String, String> queryParams = new HashMap<>();
        queryParams.put("q", query);

        return SearchUtils.searchJson(queryParams);
    }

    public static String indexInfo() throws SQLException, IOException {
        ResourceManager resourceManager = ResourceManager.getInstance();
        Map<String, FSDirectory> indexes;

        indexes = resourceManager.getIndexes();

        JsonArray resultsPerIndex = new JsonArray();

        // Iterate over all indexes and retrieve the document count and languages
        for (String indexName : indexes.keySet()) {
            JsonObject indexObject = new JsonObject();

            // Retrieve the document count
            FSDirectory indexDir = indexes.get(indexName);
            IndexReader reader = DirectoryReader.open(indexDir);
            int documentCount = reader.maxDoc();
            indexObject.addProperty("documentCount", documentCount);

            // Retrieve the languages
            DbConnection dbConn = new DbConnection();
            List<String> languages = new ArrayList<>();
            if (dbConn.retrieveMetadataColumns(indexName).contains("language")) {
                languages = dbConn.retrieveIndexInfo(indexName);
            }
            dbConn.closeConnection();
            Gson gson = new GsonBuilder().create();
            indexObject.add("languages", gson.toJsonTree(languages).getAsJsonArray());

            // Add the index object to the results
            JsonObject indexResultsObject = new JsonObject();
            indexResultsObject.add(indexName, indexObject);
            resultsPerIndex.add(indexResultsObject);
        }

        JsonObject resultsObject = new JsonObject();
        resultsObject.add("results", resultsPerIndex);

        return resultsObject.toString();
    }


    public static void queryTest() {
        print("Start query test");

        Map<String, String> queryParams = new HashMap<>();
        queryParams.put("q", "werner");

        try {
            String response = SearchUtils.searchJson(queryParams);
            print("Received query response:");
            print(response);
        } catch (ParseException e) {
            throw new RuntimeException(e);
        } catch (IOException e) {
            throw new RuntimeException(e);
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }


    public static void copyAssets(Context context) {
        AssetManager assetManager = context.getAssets();
        copyAssetDirToStorage(context, assetManager, "", context.getFilesDir());

    }

    private static void copyAssetDirToStorage(Context context, AssetManager assetManager, String path, File outDir) {
        String[] files = null;
        try {
            // List all files and folders in the current asset path
            files = assetManager.list(path);
        } catch (IOException e) {
            e.printStackTrace();
        }

        if (files != null) {
            for (String filename : files) {

                String assetPath = path.isEmpty() ? filename : path + "/" + filename;
                try {
                    // Check if it's a directory or a file
                    String[] subFiles = assetManager.list(assetPath);
                    if (subFiles.length > 0) {
                        // It's a directory, so create it in the local storage and recurse into it
                        File dir = new File(outDir, filename);
                        if (!dir.exists()) {
                            dir.mkdirs();  // Create directory in local storage
                        }
                        copyAssetDirToStorage(context, assetManager, assetPath, dir);  // Recursive call
                    } else {
                        // It's a file, so copy it to the local storage
                        InputStream in = assetManager.open(assetPath);
                        File outFile = new File(outDir, filename);

                        if(!outFile.exists())
                        {
                            print("Copying " + filename + " to " + outFile.getAbsolutePath() + "...");

                            OutputStream out = new FileOutputStream(outFile);
                            copyFile(in, out);
                            out.close();
                        }
                        else
                        {
                            print(outFile.getAbsolutePath() + " already exists");
                        }
                        in.close();
                    }
                } catch (IOException e) {
                    e.printStackTrace();
                }
            }
        }
    }

    private static void copyFile(InputStream in, OutputStream out) throws IOException {
        byte[] buffer = new byte[1024];
        int read;
        while ((read = in.read(buffer)) != -1) {
            out.write(buffer, 0, read);
        }
    }


    public static void deleteAllFiles(Context context) {
        File dir = context.getFilesDir();
        deleteRecursive(dir);
    }

    private static void deleteRecursive(File fileOrDirectory) {
        if (fileOrDirectory.isDirectory()) {
            for (File child : fileOrDirectory.listFiles()) {
                deleteRecursive(child);
            }
        }
        fileOrDirectory.delete();
    }

    public static void logAndroidRuntimeVersion() {
        // The Android version
        String androidVersion = Build.VERSION.RELEASE;
        // The API level
        int apiLevel = Build.VERSION.SDK_INT;
        // Java VM version
        String javaVersion = System.getProperty("java.version");
        // Java vendor
        String javaVendor = System.getProperty("java.vendor");

        Log.d("VersionChecker", "Android version: " + androidVersion);
        Log.d("VersionChecker", "API level: " + apiLevel);
        Log.d("VersionChecker", "Java version: " + javaVersion);
        Log.d("VersionChecker", "Java vendor: " + javaVendor);
    }



}
