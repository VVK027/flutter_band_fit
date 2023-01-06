package com.vk.flutter_band_fit.handler;

import android.content.Context;
import android.content.IntentFilter;

import androidx.localbroadcastmanager.content.LocalBroadcastManager;


import com.vk.flutter_band_fit.receiver.BandBroadcastReceiver;
import com.vk.flutter_band_fit.util.WatchConstants;
import io.flutter.plugin.common.EventChannel;

public class BandStreamHandler implements EventChannel.StreamHandler {

    private final Context mContext;
    private BandBroadcastReceiver broadcastReceiver;


    public BandStreamHandler(Context context){
        this.mContext = context;
    }

    @Override
    public void onListen(Object o, EventChannel.EventSink eventSink) {
        broadcastReceiver = new BandBroadcastReceiver(eventSink);
        LocalBroadcastManager.getInstance(mContext).registerReceiver(broadcastReceiver, new IntentFilter(WatchConstants.BROADCAST_ACTION_NAME));
    }

    @Override
    public void onCancel(Object o) {
        LocalBroadcastManager.getInstance(mContext).unregisterReceiver(broadcastReceiver);
        broadcastReceiver = null;
    }
}