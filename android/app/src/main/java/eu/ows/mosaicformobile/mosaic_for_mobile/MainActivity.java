package eu.ows.mosaicformobile.mosaic_for_mobile;
import androidx.annotation.NonNull;

import org.apache.lucene.queryparser.classic.ParseException;

import java.io.IOException;
import java.sql.SQLException;

import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodChannel;


public class MainActivity extends FlutterActivity {

    private static final String CHANNEL = "eu.ows.mosaic";

    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine)
    {
        super.configureFlutterEngine(flutterEngine);

        new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), CHANNEL)
                .setMethodCallHandler(
                        (call, result) -> {
                            MosaicInterface.print("Received method channel request: " + call.method);
                            if(call.method.equalsIgnoreCase("search"))
                            {
                                try {
                                    String query_result = MosaicInterface.performSearch(call.argument("query"));
                                    result.success(query_result);
                                } catch (SQLException | IOException | ParseException e) {
                                    result.error("Error", e.toString(), null);
                                }
                            }
                            else if(call.method.equalsIgnoreCase("start")) {
                                MosaicInterface.startMosaic(this);
                                result.success("started mosaic service");
                            }
                            else if(call.method.equalsIgnoreCase("index-info")) {
                                try {
                                    String index_info = MosaicInterface.indexInfo();
                                    result.success(index_info);
                                } catch (SQLException | IOException e) {
                                    result.error("Error", e.toString(), null);
                                }
                                result.success("started mosaic service");
                            }
                            else if(call.method.equalsIgnoreCase("reset")) {
                                MosaicInterface.deleteAllFiles(this);
                                MosaicInterface.startMosaic(this);
                                result.success("reset mosaic service");
                            }


                        }
                );
    }
}
