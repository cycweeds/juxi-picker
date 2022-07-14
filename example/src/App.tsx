import * as React from 'react';

import { useState } from 'react';

import { StyleSheet, View, Text, TouchableOpacity } from 'react-native';
import { PickerView } from '@juxi/picker';

export default function App() {

  let [number, setNumber] = useState(0)

  let [column, setColumn] = useState(0)
  let data = [{
    "浙江": [
      { "杭州": ["萧山", "余杭"] },
      { "徐州": ["萧山", "余杭", "上海", "北京"] },
      { "贵州": ["萧山", "余杭", "天津", "大连"] }]

  }, {
    "北京": [
      { "郑州": ["萧山", "余杭"] },
      { "天津": ["萧山", "余杭", "大连", "广州"] }]

  }]



  return (
    <View
      style={styles.container}
      onPress={() => {
        setNumber(3)
      }}>
      <PickerView

        data={data}
        numColumns={3}
        textFontSize={23}
        textColor={[134, 222, 144, 1]}
        textFontWeight='400'
        textSelectFontWeight='800'
        textSelectColor={[253, 124, 22, 1]}
        textSelectFontSize={23}
        style={styles.box}
        onSelectCallback={(event) => {
          setNumber(event.nativeEvent.row)
          setColumn(event.nativeEvent.column)
        }}

      />

      <Text>SelectCallback: row：{number}  column：{column}</Text>
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    alignItems: 'center',
    justifyContent: 'center',
    // backgroundColor: 'red',

  },
  box: {
    // backgroundColor: 'white',
    width: 360,
    height: 360,
  },
});
