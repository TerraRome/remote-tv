package com.example.remote

import android.os.Handler
import android.os.Looper
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodChannel
import java.io.InputStream
import java.security.SecureRandom
import java.security.cert.X509Certificate
import javax.net.ssl.SSLSocket
import javax.net.ssl.TrustManager
import javax.net.ssl.X509TrustManager
import javax.net.ssl.SSLContext

class MainActivity : FlutterActivity() {
  @Volatile private var sslSocket: SSLSocket? = null
  @Volatile private var running = false
  private var eventSink: EventChannel.EventSink? = null
  private val handler = Handler(Looper.getMainLooper())

  private val trustAllCerts = arrayOf<TrustManager>(
    object : X509TrustManager {
      override fun checkClientTrusted(chain: Array<out X509Certificate>?, authType: String?) {}
      override fun checkServerTrusted(chain: Array<out X509Certificate>?, authType: String?) {}
      override fun getAcceptedIssuers(): Array<X509Certificate> = arrayOf()
    }
  )

  override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
    super.configureFlutterEngine(flutterEngine)

    val messenger = flutterEngine.dartExecutor.binaryMessenger

    MethodChannel(messenger, "com.example.remote/tls").setMethodCallHandler { call, result ->
      when (call.method) {
        "connect" -> {
          val host = call.argument<String>("host") ?: ""
          val port = call.argument<Int>("port") ?: 6466
          connect(host, port, result)
        }
        "send" -> {
          val data = call.argument<ByteArray>("data")
          if (data != null) send(data, result) else result.error("NO_DATA", "No data", null)
        }
        "disconnect" -> disconnect(result)
        else -> result.notImplemented()
      }
    }

    EventChannel(messenger, "com.example.remote/tls_events").setStreamHandler(
        object : EventChannel.StreamHandler {
          override fun onListen(arguments: Any?, events: EventChannel.EventSink) {
            eventSink = events
          }

          override fun onCancel(arguments: Any?) {
            eventSink = null
          }
        }
      )
  }

  private fun connect(host: String, port: Int, result: MethodChannel.Result) {
    Thread {
      try {
        val sslContext = SSLContext.getInstance("TLS")
        sslContext.init(null, trustAllCerts, SecureRandom())
        val factory = sslContext.socketFactory
        val socket = factory.createSocket(host, port) as SSLSocket

        socket.enabledProtocols = socket.supportedProtocols
        socket.enabledCipherSuites = socket.supportedCipherSuites
        socket.useClientMode = true
        socket.startHandshake()

        sslSocket = socket
        running = true

        handler.post { result.success(true) }

        val inputStream: InputStream = socket.inputStream
        val buffer = ByteArray(4096)
        while (running) {
          val read = inputStream.read(buffer)
          if (read == -1) {
            handler.post {
              eventSink?.endOfStream()
            }
            break
          }
          val data = buffer.copyOf(read)
          handler.post { eventSink?.success(data) }
        }
      } catch (e: Exception) {
        running = false
        handler.post { result.error("TLS_ERROR", e.message ?: e.toString(), null) }
      }
    }.start()
  }

  private fun send(data: ByteArray, result: MethodChannel.Result) {
    try {
      val s = sslSocket
      if (s == null) {
        handler.post { result.error("SEND_ERROR", "socket null", null) }
        return
      }
      s.outputStream.write(data)
      s.outputStream.flush()
      handler.post { result.success(true) }
    } catch (e: Exception) {
      android.util.Log.e("TLS_SOCKET", "send error", e)
      handler.post {
        result.error(
          "SEND_ERROR",
          e.message ?: e.javaClass.name,
          android.util.Log.getStackTraceString(e),
        )
      }
    }
  }

  private fun disconnect(result: MethodChannel.Result? = null) {
    running = false
    try {
      sslSocket?.close()
    } catch (_: Exception) {}
    sslSocket = null
    eventSink = null
    handler.post { result?.success(true) }
  }
}
