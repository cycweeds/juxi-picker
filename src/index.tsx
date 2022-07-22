import {
  requireNativeComponent,
  UIManager,
  Platform,
} from 'react-native';
import React from 'react';

const LINKING_ERROR =
  `The package '@juxi/picker' doesn't seem to be linked. Make sure: \n\n` +
  Platform.select({ ios: "- You have run 'pod install'\n", default: '' }) +
  '- You rebuilt the app after installing the package\n' +
  '- You are not using Expo managed workflow\n';

type PickerProps = {
  numColumns: number
  data: any

  textColor?: Array<number> | undefined
  textFontSize?: number | undefined
  textFontWeight?: 'normal' | 'bold' | '100' | '200' | '300' | '400' | '500' | '600' | '700' | '800' | '900' | undefined;
  textFontFamily?: string | undefined

  textSelectColor?: Array<number> | undefined
  textSelectFontSize?: number | undefined
  textSelectFontWeight?: 'normal' | 'bold' | '100' | '200' | '300' | '400' | '500' | '600' | '700' | '800' | '900' | undefined;
  textSelectFontFamily?: string | undefined

  onSelectCallback: (event: any) => void
};


const ComponentName = 'PickerView';

const RCTPickerView =
  UIManager.getViewManagerConfig(ComponentName) != null
    ? requireNativeComponent<PickerProps>(ComponentName)
    : () => {
        throw new Error(LINKING_ERROR);
      };




export class PickerView extends React.Component {
  constructor(props) {
    super(props);
    this._onSelectCallback = this._onSelectCallback.bind(this);
  }

  _onSelectCallback(event: Event) {
    this.props.onSelectCallback && this.props.onSelectCallback(event.nativeEvent);
  }

  render() {
    return (
      <RCTPickerView
        {...this.props}
        onSelectCallback={this._onSelectCallback}
      />
    );
  }
}
