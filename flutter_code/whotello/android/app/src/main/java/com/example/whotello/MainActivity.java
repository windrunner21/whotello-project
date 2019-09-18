package com.example.whotello;

import android.content.Context;
import android.hardware.ConsumerIrManager;
import android.os.Build;
import android.os.Bundle;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

import io.flutter.app.FlutterActivity;
import io.flutter.plugins.GeneratedPluginRegistrant;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;

public class MainActivity extends FlutterActivity {
    private static final String CHANNEL = "com.example.whotello/infrared";

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        GeneratedPluginRegistrant.registerWith(this);

        new MethodChannel(getFlutterView(), CHANNEL).setMethodCallHandler(new MethodCallHandler() {
            @Override
            public void onMethodCall(MethodCall call, Result result) {
                // Note: this method is invoked on the main thread.
                if (call.method.equals("sendTVIRPower")) {
                    sendTVIRPower();

                } else if (call.method.equals("sendTVIRVolumeUp")) {
                    sendTVIRVolumeUp();

                } else if (call.method.equals("sendTVIRVolumeDown")) {
                    sendTVIRVolumeDown();

                } else if (call.method.equals("sendTVIRChannelUp")) {
                    sendTVIRChannelUp();

                } else if (call.method.equals("sendTVIRChannelDown")) {
                    sendTVIRChannelDown();

                } else if (call.method.equals("sendACIRPower")) {
                    sendACIRPower();

                } else if (call.method.equals("sendACIRTempUp")) {
                    sendACIRVolumeUp();

                } else if (call.method.equals("sendACIRTempDown")) {
                    sendACIRVolumeDown();

                } else {
                    result.notImplemented();
                }

            }
        });
    }

    private void sendTVIRPower() {
        ConsumerIrManager mCIR = null;

        if (android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.KITKAT) {
            mCIR = (ConsumerIrManager) getSystemService(Context.CONSUMER_IR_SERVICE);
        }

        ConsumerIrManagerHelper consumerIrManagerHelper = new ConsumerIrManagerHelper(mCIR);
        consumerIrManagerHelper.transmitIRCommand(SamsungTvIRCommand.TV_POWER);
    }

    private void sendTVIRVolumeUp() {
        ConsumerIrManager mCIR = null;

        if (android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.KITKAT) {
            mCIR = (ConsumerIrManager) getSystemService(Context.CONSUMER_IR_SERVICE);
        }

        ConsumerIrManagerHelper consumerIrManagerHelper = new ConsumerIrManagerHelper(mCIR);
        consumerIrManagerHelper.transmitIRCommand(SamsungTvIRCommand.TV_VOLUME_UP);
    }

    private void sendTVIRVolumeDown() {
        ConsumerIrManager mCIR = null;

        if (android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.KITKAT) {
            mCIR = (ConsumerIrManager) getSystemService(Context.CONSUMER_IR_SERVICE);
        }

        ConsumerIrManagerHelper consumerIrManagerHelper = new ConsumerIrManagerHelper(mCIR);
        consumerIrManagerHelper.transmitIRCommand(SamsungTvIRCommand.TV_VOLUME_DOWN);
    }

    private void sendTVIRChannelUp() {
        ConsumerIrManager mCIR = null;

        if (android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.KITKAT) {
            mCIR = (ConsumerIrManager) getSystemService(Context.CONSUMER_IR_SERVICE);
        }

        ConsumerIrManagerHelper consumerIrManagerHelper = new ConsumerIrManagerHelper(mCIR);
        consumerIrManagerHelper.transmitIRCommand(SamsungTvIRCommand.TV_CHANNEL_UP);
    }

    private void sendTVIRChannelDown() {
        ConsumerIrManager mCIR = null;

        if (android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.KITKAT) {
            mCIR = (ConsumerIrManager) getSystemService(Context.CONSUMER_IR_SERVICE);
        }

        ConsumerIrManagerHelper consumerIrManagerHelper = new ConsumerIrManagerHelper(mCIR);
        consumerIrManagerHelper.transmitIRCommand(SamsungTvIRCommand.TV_CHANNEL_DOWN);
    }

    private void sendACIRPower() {
        ConsumerIrManager mCIR = null;

        if (android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.KITKAT) {
            mCIR = (ConsumerIrManager) getSystemService(Context.CONSUMER_IR_SERVICE);
        }

        ConsumerIrManagerHelper consumerIrManagerHelper = new ConsumerIrManagerHelper(mCIR);
        consumerIrManagerHelper.transmitIRCommand(ToshibaTvIRCommand.AC_POWER);
    }

    private void sendACIRVolumeUp() {
        ConsumerIrManager mCIR = null;

        if (android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.KITKAT) {
            mCIR = (ConsumerIrManager) getSystemService(Context.CONSUMER_IR_SERVICE);
        }

        ConsumerIrManagerHelper consumerIrManagerHelper = new ConsumerIrManagerHelper(mCIR);
        consumerIrManagerHelper.transmitIRCommand(ToshibaTvIRCommand.AC_VOLUME_UP);
    }

    private void sendACIRVolumeDown() {
        ConsumerIrManager mCIR = null;

        if (android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.KITKAT) {
            mCIR = (ConsumerIrManager) getSystemService(Context.CONSUMER_IR_SERVICE);
        }

        ConsumerIrManagerHelper consumerIrManagerHelper = new ConsumerIrManagerHelper(mCIR);
        consumerIrManagerHelper.transmitIRCommand(ToshibaTvIRCommand.AC_VOLUME_DOWN);
    }

}

abstract class IRCommand {
    private int frequency;
    private int[] pattern;

    IRCommand(final String irData) {
        List<String> list = new ArrayList<>(Arrays.asList(irData.split(" ")));
        list.remove(0);
        int frequency = Integer.parseInt(list.remove(0), 16); // frequency
        list.remove(0);
        list.remove(0);

        frequency = (int) (1000000 / (frequency * 0.241246));
        int pulses = 1000000 / frequency;
        int count;

        int[] pattern = new int[list.size()];
        for (int i = 0; i < list.size(); i++) {
            count = Integer.parseInt(list.get(i), 16);
            pattern[i] = count * pulses;
        }

        this.frequency = frequency;
        this.pattern = pattern;
    }

    int getFrequency() {
        return frequency;
    }

    int[] getPattern() {
        return pattern;
    }
}

class SamsungTvIRCommand extends IRCommand {
    private final static String TV_POWER_HEX = "0000 0067 0000 000d 0060 0018 0030 0018 0018 0018 0030 0018 0018 0018 0030 0018 0018 0018 0018 0018 0030 0018 0018 0018 0018 0018 0018 0018 0018 0407";
    private static final String TV_VOLUME_DOWN_HEX = "0000 0067 0000 000d 0060 0018 0030 0018 0030 0018 0018 0018 0018 0018 0030 0018 0018 0018 0018 0018 0030 0018 0018 0018 0018 0018 0018 0018 0018 0407";
    private final static String TV_VOLUME_UP_HEX = "0000 0067 0000 000d 0060 0018 0018 0018 0030 0018 0018 0018 0018 0018 0030 0018 0018 0018 0018 0018 0030 0018 0018 0018 0018 0018 0018 0018 0018 041f";
    private static final String TV_CHANNEL_DOWN_HEX = "0000 0067 0000 000d 0060 0018 0030 0018 0018 0018 0018 0018 0018 0018 0030 0018 0018 0018 0018 0018 0030 0018 0018 0018 0018 0018 0018 0018 0018 041f";
    private final static String TV_CHANNEL_UP_HEX = "0000 0067 0000 000d 0060 0018 0018 0018 0018 0018 0018 0018 0018 0018 0030 0018 0018 0018 0018 0018 0030 0018 0018 0018 0018 0018 0018 0018 0018 0438";

    public static final SamsungTvIRCommand TV_POWER = new SamsungTvIRCommand(TV_POWER_HEX);
    public static final SamsungTvIRCommand TV_VOLUME_DOWN = new SamsungTvIRCommand(TV_VOLUME_DOWN_HEX);
    public static final SamsungTvIRCommand TV_VOLUME_UP = new SamsungTvIRCommand(TV_VOLUME_UP_HEX);
    public static final SamsungTvIRCommand TV_CHANNEL_UP = new SamsungTvIRCommand(TV_CHANNEL_UP_HEX);
    public static final SamsungTvIRCommand TV_CHANNEL_DOWN = new SamsungTvIRCommand(TV_CHANNEL_DOWN_HEX);

    private SamsungTvIRCommand(String irData) {
        super(irData);
    }
}

class ToshibaTvIRCommand extends IRCommand {
    private final static String AC_POWER_HEX = "0479";
    private static final String AC_TEMP_DOWN_HEX = "0107 0108 0109 0110 0111 0112 0113 0114 0115 0116 0117";
    private final static String AC_TEMP_UP_HEX = "0493 0494 0495 0496 0497 0498 0499";

    public static final ToshibaTvIRCommand AC_POWER = new ToshibaTvIRCommand(AC_POWER_HEX);
    public static final ToshibaTvIRCommand AC_VOLUME_DOWN = new ToshibaTvIRCommand(AC_TEMP_DOWN_HEX);
    public static final ToshibaTvIRCommand AC_VOLUME_UP = new ToshibaTvIRCommand(AC_TEMP_UP_HEX);

    private ToshibaTvIRCommand(String irData) {
        super(irData);
    }
}

class ConsumerIrManagerHelper {
    private ConsumerIrManager consumerIrManager;

    public ConsumerIrManagerHelper(ConsumerIrManager consumerIrManager) {
        this.consumerIrManager = consumerIrManager;
    }

    public void transmitIRCommand(IRCommand irCommand) {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.KITKAT) {
            consumerIrManager.transmit(irCommand.getFrequency(), irCommand.getPattern());
        }
    }
}
