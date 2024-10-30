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

        MosaicTest.startMosaic(this);
        new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), CHANNEL)
                .setMethodCallHandler(
                        (call, result) -> {
                            MosaicTest.print("invoked method channel");
                            try {
                                String query_result = MosaicTest.performSearch(call.method);
                                result.success(query_result);
                            } catch (SQLException | IOException | ParseException e) {
                                result.error("Error", e.toString(), null);
                            }
                        }
                );
    }
}
