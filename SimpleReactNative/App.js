import React, {useState} from 'react';
import {requireNativeComponent, SafeAreaView, Text, View, Button} from 'react-native';

const SwiftUIButton = requireNativeComponent('SwiftUIButton');

const App: () => React$Node = () => {
  const [count, updateCount] = React.useState(0);
  return (
    
    <SafeAreaView>
      <View style={styles.container}>
        <Text>"Hi There</Text>
      </View>
      <View style={styles.container}>
      <SwiftUIButton
      style={styles.container}
      count={count}
      onCountChange={e => updateCount(e.nativeEvent.count)}
    />
      </View>
    </SafeAreaView>
  );
};

const styles = {
  container: {
    flex: 1,
    alignItems: 'center',
    justifyContent: 'center',
  },
};

export default App;