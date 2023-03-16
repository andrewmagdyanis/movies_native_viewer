package com.flasherCheetah.movies_native_viewer.movies_native_viewer

import android.os.StrictMode
import android.os.StrictMode.ThreadPolicy
import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.io.BufferedReader
import java.io.InputStreamReader
import java.net.HttpURLConnection
import java.net.URL
import java.net.URLEncoder

class MainActivity : FlutterActivity() {
    private val CHANNEL = "test.flutter.methodchannel/android"

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        val policy = ThreadPolicy.Builder().permitAll().build()

        StrictMode.setThreadPolicy(policy)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler {
            // This method is invoked on the main thread.
            call, result ->
           if (call.method == "getFilmsList") {
               val api_key = call.argument("api_key") ?: ""
               val language = call.argument("language") ?: "en-US"
               val sort_by = call.argument("sort_by") ?: ""
               val include_adult = call.argument("include_adult") ?: false
               val include_video = call.argument("include_video") ?: false
               val page = call.argument("page") ?: "1"
               val with_watch_monetization_types = call.argument("with_watch_monetization_types")?:""

                val filmsList = getFilmsList(
                        url = "https://api.themoviedb.org/3/discover/movie",
                        api_key = api_key,
                        language = language,
                        sort_by = sort_by,
                        include_adult = include_adult,
                        include_video = include_video,
                        page = page,
                        with_watch_monetization_types = with_watch_monetization_types)
                result.success(filmsList)
           } else {
                result.notImplemented()
           }
        }
    }

    private fun getFilmsList(url: String, api_key: String, language: String, sort_by: String, include_adult: Boolean, include_video: Boolean, page: String, with_watch_monetization_types: String): String {
        var reqParam = URLEncoder.encode("api_key", "UTF-8") + "=" + URLEncoder.encode(api_key, "UTF-8")
        reqParam += "&" + URLEncoder.encode("language", "UTF-8") + "=" + URLEncoder.encode(language, "UTF-8")
        reqParam += "&" + URLEncoder.encode("sort_by", "UTF-8") + "=" + URLEncoder.encode(sort_by, "UTF-8")
        reqParam += "&" + URLEncoder.encode("include_adult", "UTF-8") + "=" + URLEncoder.encode(include_adult.toString(), "UTF-8")
        reqParam += "&" + URLEncoder.encode("include_video", "UTF-8") + "=" + URLEncoder.encode(include_video.toString(), "UTF-8")
        reqParam += "&" + URLEncoder.encode("page", "UTF-8") + "=" + URLEncoder.encode(page.toString(), "UTF-8")
        reqParam += "&" + URLEncoder.encode("with_watch_monetization_types", "UTF-8") + "=" + URLEncoder.encode(with_watch_monetization_types.toString(), "UTF-8")

        val mURL = URL(url + "?" + reqParam)
        var finalResponse = ""

        with(mURL.openConnection() as HttpURLConnection) {
            requestMethod = "GET"

            println("URL : $url")
            println("Response Code : $responseCode")

            BufferedReader(InputStreamReader(inputStream)).use {
                val response = StringBuffer()

                var inputLine = it.readLine()
                while (inputLine != null) {
                    response.append(inputLine)
                    inputLine = it.readLine()
                }
                it.close()
                finalResponse = response.toString()
                println("Response : $response")
            }
        }
        return finalResponse
    }
}
