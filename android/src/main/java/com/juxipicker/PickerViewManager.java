package com.juxipicker;

import static android.graphics.Color.argb;

import android.util.Log;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import com.facebook.react.bridge.Arguments;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContext;
import com.facebook.react.bridge.ReadableArray;
import com.facebook.react.bridge.WritableMap;
import com.facebook.react.common.MapBuilder;
import com.facebook.react.modules.core.DeviceEventManagerModule;
import com.facebook.react.uimanager.SimpleViewManager;
import com.facebook.react.uimanager.ThemedReactContext;
import com.facebook.react.uimanager.annotations.ReactProp;
import com.facebook.react.uimanager.events.RCTEventEmitter;
import com.facebook.react.uimanager.events.RCTModernEventEmitter;
import com.juxipicker.view.OnSelectedListener;
import com.juxipicker.view.PickerViewLinkage;
import com.juxipicker.view.ReturnData;

import java.util.ArrayList;
import java.util.Map;
import java.util.function.Consumer;

public class PickerViewManager extends SimpleViewManager<PickerViewLinkage> {
  public static final String REACT_CLASS = "PickerView";

  public static final String TAG = "PickerViewManager";


  private static final String PICKER_EVENT_NAME = "PickerViewEvent";

  public PickerViewManager() {
    super();
  }

  @Override
  @NonNull
  public String getName() {
    return REACT_CLASS;
  }

  PickerViewLinkage linkageView;

  @Override
  @NonNull
  public PickerViewLinkage createViewInstance(ThemedReactContext reactContext) {
    if (linkageView != null) {
      return linkageView;
    }
    linkageView = new PickerViewLinkage(reactContext);
    linkageView.setOnSelectListener(new OnSelectedListener() {
      @Override
      public void onSelected(ArrayList<ReturnData> selectedList) {
        int index = 0;
        for (ReturnData returnData : selectedList) {
          WritableMap event = Arguments.createMap();
          event.putInt("row", returnData.getIndex());
          event.putInt("column", index);
          ReactContext reactContext = (ReactContext) linkageView.getContext();
          reactContext.getJSModule(RCTEventEmitter.class).receiveEvent(linkageView.getId(), PICKER_EVENT_NAME, event);
          index += 1;
        }
      }
    });
    return linkageView;
  }

  @ReactProp(name = "numColumns")
  public void setNumColumns(PickerViewLinkage view, int numColumns) {
    view.setRow(numColumns);
  }

  @ReactProp(name = "data")
  public void setData(PickerViewLinkage view, ReadableArray data) {
    if (data != null) {
      view.setPickerData(data, null);
    }
  }

  @ReactProp(name = "textColor")
  public void setTextColor(PickerViewLinkage view, ReadableArray textColor) {
    if (textColor != null) {
      view.setTextColor(getColor(textColor));
    }
  }
  
  @ReactProp(name = "textFontSize")
  public void setTextFontSize(PickerViewLinkage view, int textFontSize) {
    Log.i(TAG, String.valueOf(textFontSize));
    Log.i(TAG, "setTextFontSize");
      view.setTextFontSize(textFontSize);
  }

  @ReactProp(name = "textSelectColor")
  public void setTextSelectColor(PickerViewLinkage view, ReadableArray textSelectColor) {
    if (textSelectColor != null) {
      view.setTextSelectedColor(getColor(textSelectColor));
    }
  }

  @Nullable
  @Override
  public Map<String, Object> getExportedCustomBubblingEventTypeConstants() {
    return MapBuilder.<String, Object>builder().put(
      PICKER_EVENT_NAME,
      MapBuilder.of(
        "phasedRegistrationNames",
        MapBuilder.of("bubbled", "onSelectCallback")
      )
    ).build();
  }

  private int getColor(ReadableArray array) {
    int[] colors = new int[4];
    for (int i = 0; i < array.size(); i++) {
      switch (i) {
        case 0:
        case 1:
        case 2:
          colors[i] = array.getInt(i);
          break;
        case 3:
          colors[i] = (int) (array.getDouble(i) * 255);
          break;
        default:
          break;
      }
    }
    return argb(colors[3], colors[0], colors[1], colors[2]);
  }
}
