/**
 * Sample React Native App
 * https://github.com/facebook/react-native
 *
 * @format
 */

import React, {useCallback, useEffect, useState} from 'react';
import type {PropsWithChildren} from 'react';
import {
  SafeAreaView,
  ScrollView,
  StatusBar,
  StyleSheet,
  Text,
  TouchableOpacity,
  useColorScheme,
  View,
} from 'react-native';

import {
  Colors,
  DebugInstructions,
  Header,
  LearnMoreLinks,
  ReloadInstructions,
} from 'react-native/Libraries/NewAppScreen';

type Todo = {
  id: number;
  isCompleted: boolean;
  text: string;
};

type TodoProps = Todo & {
  onPress: (id: number) => void;
};

function Todo({isCompleted, text, id, onPress}: TodoProps): JSX.Element {
  const isDarkMode = useColorScheme() === 'dark';
  return (
    <TouchableOpacity onPress={() => onPress(id)}>
      <View
        style={{
          width: '100%',
          paddingHorizontal: 20,
          paddingVertical: 12,
          display: 'flex',
          flexDirection: 'row',
          alignItems: 'center',
        }}>
        <View
          style={{
            width: 20,
            height: 20,
            borderWidth: 2,
            borderColor: 'black',
            backgroundColor: isCompleted ? 'black' : Colors.lighter,
          }}
        />

        <Text
          style={{
            color: isDarkMode ? Colors.white : Colors.black,
            fontSize: 24,
            fontWeight: '600',
            marginLeft: 8,
          }}>
          {text}
        </Text>
      </View>
    </TouchableOpacity>
  );
}

function App(): JSX.Element {
  const isDarkMode = useColorScheme() === 'dark';

  const backgroundStyle = {
    backgroundColor: isDarkMode ? Colors.darker : Colors.lighter,
    paddingTop: 40,
    flex: 1,
  };

  const [todos, setTodos] = useState<Todo[]>([
    {
      id: 1,
      text: 'First Todo',
      isCompleted: false,
    },
    {
      id: 2,
      text: 'Second Todo',
      isCompleted: false,
    },
    {
      id: 3,
      text: 'Third Todo',
      isCompleted: false,
    },
    {
      id: 4,
      text: 'Fourth Todo',
      isCompleted: false,
    },
  ]);

  const handlePress = (id: number) => {
    setTodos(prev =>
      prev.map(i => (i.id === id ? {...i, isCompleted: !i.isCompleted} : i)),
    );
  };

  useEffect(() => {
    //TODO userDefault
  }, []);

  return (
    <SafeAreaView style={backgroundStyle}>
      <StatusBar
        barStyle={isDarkMode ? 'light-content' : 'dark-content'}
        backgroundColor={backgroundStyle.backgroundColor}
      />
      <ScrollView
        contentInsetAdjustmentBehavior="automatic"
        style={backgroundStyle}>
        {todos.map(t => (
          <Todo key={t.id} {...t} onPress={handlePress} />
        ))}
      </ScrollView>
    </SafeAreaView>
  );
}

export default App;
