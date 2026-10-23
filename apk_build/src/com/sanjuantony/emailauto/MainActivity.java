package com.sanjuantony.emailauto;

import android.app.Activity;
import android.content.Intent;
import android.net.Uri;
import android.os.Bundle;
import android.view.View;
import android.view.Window;
import android.view.WindowManager;
import android.webkit.ConsoleMessage;
import android.webkit.DownloadListener;
import android.webkit.WebChromeClient;
import android.webkit.WebSettings;
import android.webkit.WebView;
import android.webkit.WebViewClient;
import android.widget.Toast;

import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.net.InetAddress;
import java.net.ServerSocket;
import java.net.Socket;
import java.net.HttpURLConnection;
import java.net.URL;

public class MainActivity extends Activity {

    private WebView webView;
    private ServerSocket serverSocket;
    private int serverPort = 8888;
    private boolean isServerRunning = false;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        requestWindowFeature(Window.FEATURE_NO_TITLE);
        getWindow().setFlags(WindowManager.LayoutParams.FLAG_FULLSCREEN, WindowManager.LayoutParams.FLAG_FULLSCREEN);

        startLocalAssetServer();

        webView = new WebView(this);
        setContentView(webView);

        WebSettings settings = webView.getSettings();
        settings.setJavaScriptEnabled(true);
        settings.setDomStorageEnabled(true);
        settings.setDatabaseEnabled(true);
        settings.setAllowFileAccess(true);
        settings.setAllowContentAccess(true);
        settings.setAllowFileAccessFromFileURLs(true);
        settings.setAllowUniversalAccessFromFileURLs(true);
        settings.setLoadWithOverviewMode(true);
        settings.setUseWideViewPort(true);
        settings.setSupportZoom(false);
        settings.setMixedContentMode(WebSettings.MIXED_CONTENT_ALWAYS_ALLOW);

        webView.setBackgroundColor(0xFF0F172A);

        webView.setWebChromeClient(new WebChromeClient() {
            @Override
            public boolean onConsoleMessage(ConsoleMessage consoleMessage) {
                return super.onConsoleMessage(consoleMessage);
            }
        });

        webView.setWebViewClient(new WebViewClient() {
            @Override
            public boolean shouldOverrideUrlLoading(WebView view, String url) {
                if (url.startsWith("http://127.0.0.1:" + serverPort)) {
                    return false;
                }
                try {
                    Intent intent = new Intent(Intent.ACTION_VIEW, Uri.parse(url));
                    startActivity(intent);
                    return true;
                } catch (Exception e) {
                    return false;
                }
            }
        });

        webView.setDownloadListener(new DownloadListener() {
            @Override
            public void onDownloadStart(String url, String userAgent, String contentDisposition, String mimetype, long contentLength) {
                try {
                    Intent intent = new Intent(Intent.ACTION_VIEW, Uri.parse(url));
                    startActivity(intent);
                } catch (Exception e) {
                    Toast.makeText(MainActivity.this, "Downloading " + url, Toast.LENGTH_SHORT).show();
                }
            }
        });

        webView.postDelayed(new Runnable() {
            @Override
            public void run() {
                webView.loadUrl("http://127.0.0.1:" + serverPort + "/index.html");
            }
        }, 300);
    }

    private void startLocalAssetServer() {
        new Thread(new Runnable() {
            @Override
            public void run() {
                try {
                    serverSocket = new ServerSocket(serverPort, 50, InetAddress.getByName("127.0.0.1"));
                    isServerRunning = true;
                    while (isServerRunning && !serverSocket.isClosed()) {
                        Socket socket = serverSocket.accept();
                        handleClient(socket);
                    }
                } catch (IOException e) {
                    // Server closed or port busy
                }
            }
        }).start();
    }

    private void handleClient(final Socket socket) {
        new Thread(new Runnable() {
            @Override
            public void run() {
                try {
                    InputStream in = socket.getInputStream();
                    OutputStream out = socket.getOutputStream();

                    byte[] buffer = new byte[8192];
                    int read = in.read(buffer);
                    if (read <= 0) {
                        socket.close();
                        return;
                    }

                    String header = new String(buffer, 0, read);
                    String[] lines = header.split("\r\n");
                    if (lines.length == 0) {
                        socket.close();
                        return;
                    }

                    String[] requestLine = lines[0].split(" ");
                    if (requestLine.length < 2) {
                        socket.close();
                        return;
                    }

                    String method = requestLine[0];
                    String rawPath = requestLine[1];
                    String path = rawPath.contains("?") ? rawPath.substring(0, rawPath.indexOf("?")) : rawPath;

                    if (path.equals("/") || path.isEmpty()) {
                        path = "/index.html";
                    }

                    // Proxy /api/ requests to local backend or host machine
                    if (path.startsWith("/api/")) {
                        handleApiProxy(method, path, header, buffer, read, in, out);
                        socket.close();
                        return;
                    }

                    String assetPath = "www" + path;
                    if (assetPath.startsWith("/")) {
                        assetPath = assetPath.substring(1);
                    }

                    try {
                        InputStream assetStream = getAssets().open(assetPath);
                        ByteArrayOutputStream byteOut = new ByteArrayOutputStream();
                        byte[] fileBuf = new byte[8192];
                        int n;
                        while ((n = assetStream.read(fileBuf)) != -1) {
                            byteOut.write(fileBuf, 0, n);
                        }
                        assetStream.close();

                        byte[] data = byteOut.toByteArray();
                        String mime = getMimeType(path);

                        String responseHeader = "HTTP/1.1 200 OK\r\n" +
                                "Content-Type: " + mime + "\r\n" +
                                "Content-Length: " + data.length + "\r\n" +
                                "Access-Control-Allow-Origin: *\r\n" +
                                "Connection: close\r\n\r\n";

                        out.write(responseHeader.getBytes("UTF-8"));
                        out.write(data);
                        out.flush();
                    } catch (IOException notFound) {
                        String notFoundResp = "HTTP/1.1 404 Not Found\r\nContent-Length: 0\r\nConnection: close\r\n\r\n";
                        out.write(notFoundResp.getBytes("UTF-8"));
                        out.flush();
                    }

                    socket.close();
                } catch (Exception e) {
                    try { socket.close(); } catch (Exception ignored) {}
                }
            }
        }).start();
    }

    private void handleApiProxy(String method, String path, String header, byte[] initialBuffer, int initialRead, InputStream clientIn, OutputStream clientOut) {
        // Try forwarding to local machine backend on port 3000
        // On BlueStacks emulator, 10.0.2.2 maps to host PC 127.0.0.1
        String[] targets = new String[] {
            "http://10.0.2.2:3000" + path,
            "http://127.0.0.1:3000" + path
        };

        for (String targetUrl : targets) {
            try {
                URL url = new URL(targetUrl);
                HttpURLConnection conn = (HttpURLConnection) url.openConnection();
                conn.setRequestMethod(method);
                conn.setConnectTimeout(3000);
                conn.setReadTimeout(15000);

                if ("POST".equalsIgnoreCase(method)) {
                    conn.setDoOutput(true);
                    conn.setRequestProperty("Content-Type", "application/json");

                    int headerEnd = findHeaderEnd(initialBuffer, initialRead);
                    if (headerEnd != -1 && initialRead > headerEnd) {
                        OutputStream connOut = conn.getOutputStream();
                        connOut.write(initialBuffer, headerEnd, initialRead - headerEnd);
                        connOut.flush();
                    }
                }

                int code = conn.getResponseCode();
                InputStream connIn = (code >= 200 && code < 400) ? conn.getInputStream() : conn.getErrorStream();

                ByteArrayOutputStream respOut = new ByteArrayOutputStream();
                if (connIn != null) {
                    byte[] temp = new byte[4096];
                    int r;
                    while ((r = connIn.read(temp)) != -1) {
                        respOut.write(temp, 0, r);
                    }
                    connIn.close();
                }

                byte[] respBytes = respOut.toByteArray();
                String respHeader = "HTTP/1.1 " + code + " OK\r\n" +
                        "Content-Type: application/json\r\n" +
                        "Content-Length: " + respBytes.length + "\r\n" +
                        "Access-Control-Allow-Origin: *\r\n" +
                        "Connection: close\r\n\r\n";

                clientOut.write(respHeader.getBytes("UTF-8"));
                clientOut.write(respBytes);
                clientOut.flush();
                return;
            } catch (Exception e) {
                // Try next target
            }
        }

        // If backend server not reachable
        String fallback = "{\"success\":false,\"error\":\"Backend server on port 3000 not reachable. Please start server.js or check connection.\"}";
        try {
            String errResp = "HTTP/1.1 502 Bad Gateway\r\n" +
                    "Content-Type: application/json\r\n" +
                    "Content-Length: " + fallback.getBytes("UTF-8").length + "\r\n" +
                    "Access-Control-Allow-Origin: *\r\n" +
                    "Connection: close\r\n\r\n" + fallback;
            clientOut.write(errResp.getBytes("UTF-8"));
            clientOut.flush();
        } catch (Exception ignored) {}
    }

    private int findHeaderEnd(byte[] buf, int len) {
        for (int i = 0; i < len - 3; i++) {
            if (buf[i] == '\r' && buf[i + 1] == '\n' && buf[i + 2] == '\r' && buf[i + 3] == '\n') {
                return i + 4;
            }
        }
        return -1;
    }

    private String getMimeType(String path) {
        String lower = path.toLowerCase();
        if (lower.endsWith(".html") || lower.endsWith(".htm")) return "text/html; charset=utf-8";
        if (lower.endsWith(".js") || lower.endsWith(".mjs")) return "application/javascript; charset=utf-8";
        if (lower.endsWith(".css")) return "text/css; charset=utf-8";
        if (lower.endsWith(".svg")) return "image/svg+xml";
        if (lower.endsWith(".png")) return "image/png";
        if (lower.endsWith(".jpg") || lower.endsWith(".jpeg")) return "image/jpeg";
        if (lower.endsWith(".pdf")) return "application/pdf";
        if (lower.endsWith(".json")) return "application/json";
        return "application/octet-stream";
    }

    @Override
    public void onBackPressed() {
        if (webView != null && webView.canGoBack()) {
            webView.goBack();
        } else {
            super.onBackPressed();
        }
    }

    @Override
    protected void onDestroy() {
        isServerRunning = false;
        if (serverSocket != null) {
            try { serverSocket.close(); } catch (Exception ignored) {}
        }
        if (webView != null) {
            webView.destroy();
        }
        super.onDestroy();
    }
}
