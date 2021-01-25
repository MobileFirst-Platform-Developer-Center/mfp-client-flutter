package com.ibm.mobile.mobilefoundation;

import android.app.Activity;
import android.content.Context;

import androidx.annotation.NonNull;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.embedding.engine.plugins.activity.ActivityAware;
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.PluginRegistry.Registrar;
import io.flutter.plugin.common.BinaryMessenger;

/**
 * MobilefoundationPlugin
 */
public class MobilefoundationPlugin implements FlutterPlugin, ActivityAware {

    private static final String CHANNEL_WL_CLIENT = "wlclient";
    private static final String CHANNEL_WL_AUTHORIZATION_MANAGER = "wlauthorizationmanager";
    private static final String CHANNEL_WL_RESOURCE_REQUEST = "wlresourcerequest";
    private static final String CHANNEL_LOGGER = "logger";
    private static Context activeContext;
    private static Activity activity;
    private static BinaryMessenger messenger ;
    private static MethodChannel wlClientChannel, wlAuthorizationManagerChannel, wlresourcerequestChannel, loggerChannel;


    // This static function is optional and equivalent to onAttachedToEngine. It supports the old
    // pre-Flutter-1.12 Android projects. You are encouraged to continue supporting
    // plugin registration via this function while apps migrate to use the new Android APIs
    // post-flutter-1.12 via https://flutter.dev/go/android-project-migration.
    //
    // It is encouraged to share logic between onAttachedToEngine and registerWith to keep
    // them functionally equivalent. Only one of onAttachedToEngine or registerWith will be called
    // depending on the user's project. onAttachedToEngine or registerWith must both be defined
    // in the same class.
    public static void registerWith(Registrar registrar) {
        wlClientChannel = new MethodChannel(registrar.messenger(), CHANNEL_WL_CLIENT);
        wlAuthorizationManagerChannel = new MethodChannel(registrar.messenger(), CHANNEL_WL_AUTHORIZATION_MANAGER);
        wlresourcerequestChannel = new MethodChannel(registrar.messenger(), CHANNEL_WL_RESOURCE_REQUEST);
        loggerChannel = new MethodChannel(registrar.messenger(), CHANNEL_LOGGER);
        
        activeContext = registrar.context();

        wlClientChannel.setMethodCallHandler(WLClientMethodHandler.getInstance());
        wlAuthorizationManagerChannel.setMethodCallHandler(WLAuthorizationManagerMethodHandler.getInstance());
        wlresourcerequestChannel.setMethodCallHandler(WLResourceRequestMethodHandler.getInstance());
        loggerChannel.setMethodCallHandler(LoggerMethodHandler.getInstance());
    }

    public static Context getContext() {
        return activeContext;
    }

    public static Activity getActivity() {
        return activity;
    }

    public static BinaryMessenger getBinaryMessenger(){
        return  messenger;
    }

    @Override
    public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
        wlClientChannel = new MethodChannel(flutterPluginBinding.getBinaryMessenger(), CHANNEL_WL_CLIENT);
        wlAuthorizationManagerChannel = new MethodChannel(flutterPluginBinding.getBinaryMessenger(), CHANNEL_WL_AUTHORIZATION_MANAGER);
        wlresourcerequestChannel = new MethodChannel(flutterPluginBinding.getBinaryMessenger(), CHANNEL_WL_RESOURCE_REQUEST);
        loggerChannel = new MethodChannel(flutterPluginBinding.getBinaryMessenger(), CHANNEL_LOGGER);

        activeContext = flutterPluginBinding.getApplicationContext();
        messenger = flutterPluginBinding.getBinaryMessenger();

        wlClientChannel.setMethodCallHandler(WLClientMethodHandler.getInstance());
        wlAuthorizationManagerChannel.setMethodCallHandler(WLAuthorizationManagerMethodHandler.getInstance());
        wlresourcerequestChannel.setMethodCallHandler(WLResourceRequestMethodHandler.getInstance());
        loggerChannel.setMethodCallHandler(LoggerMethodHandler.getInstance());
    }

    @Override
    public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
        wlClientChannel.setMethodCallHandler(null);
        wlAuthorizationManagerChannel.setMethodCallHandler(null);
        wlresourcerequestChannel.setMethodCallHandler(null);
        loggerChannel.setMethodCallHandler(null);
    }

    @Override
    public void onAttachedToActivity(@NonNull ActivityPluginBinding binding) {
        activity = binding.getActivity();
    }

    @Override
    public void onDetachedFromActivityForConfigChanges() {
        // Do nothing
    }

    @Override
    public void onReattachedToActivityForConfigChanges(@NonNull ActivityPluginBinding binding) {
        // Do nothing
    }

    @Override
    public void onDetachedFromActivity() {
        // Do nothing
    }
}
