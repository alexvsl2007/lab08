## Laboratory work V

Данная лабораторная работа посвещена изучению фреймворков для тестирования на примере **GTest**

```sh
$ open https://github.com/google/googletest
```

## Tasks

- [ ] 1. Создать публичный репозиторий с названием **lab05** на сервисе **GitHub**
- [ ] 2. Выполнить инструкцию учебного материала
- [ ] 3. Ознакомиться со ссылками учебного материала
- [ ] 4. Составить отчет и отправить ссылку личным сообщением в **Slack**

## Tutorial

```sh
$ export GITHUB_USERNAME=<имя_пользователя>
$ alias gsed=sed # for *-nix system
```

```sh
$ cd ${GITHUB_USERNAME}/workspace
$ pushd .
$ source scripts/activate
```

```sh
$ git clone https://github.com/${GITHUB_USERNAME}/lab04 projects/lab05
$ cd projects/lab05
$ git remote remove origin
$ git remote add origin https://github.com/${GITHUB_USERNAME}/lab05
```

```sh
$ mkdir third-party
$ git submodule add https://github.com/google/googletest third-party/gtest
$ cd third-party/gtest && git checkout release-1.8.1 && cd ../..
$ git add third-party/gtest
$ git commit -m"added gtest framework"
```

```sh
$ gsed -i '/option(BUILD_EXAMPLES "Build examples" OFF)/a\
option(BUILD_TESTS "Build tests" OFF)
' CMakeLists.txt
$ cat >> CMakeLists.txt <<EOF

if(BUILD_TESTS)
  enable_testing()
  add_subdirectory(third-party/gtest)
  file(GLOB \${PROJECT_NAME}_TEST_SOURCES tests/*.cpp)
  add_executable(check \${\${PROJECT_NAME}_TEST_SOURCES})
  target_link_libraries(check \${PROJECT_NAME} gtest_main)
  add_test(NAME check COMMAND check)
endif()
EOF
```

```sh
$ mkdir tests
$ cat > tests/test1.cpp <<EOF
#include <print.hpp>

#include <gtest/gtest.h>

TEST(Print, InFileStream)
{
  std::string filepath = "file.txt";
  std::string text = "hello";
  std::ofstream out{filepath};

  print(text, out);
  out.close();

  std::string result;
  std::ifstream in{filepath};
  in >> result;

  EXPECT_EQ(result, text);
}
EOF
```

```sh
$ cmake -H. -B_build -DBUILD_TESTS=ON
$ cmake --build _build
$ cmake --build _build --target test
```

```sh
$ _build/check
$ cmake --build _build --target test -- ARGS=--verbose
```

```sh
$ gsed -i 's/lab04/lab05/g' README.md
$ gsed -i 's/\(DCMAKE_INSTALL_PREFIX=_install\)/\1 -DBUILD_TESTS=ON/' .travis.yml
$ gsed -i '/cmake --build _build --target install/a\
- cmake --build _build --target test -- ARGS=--verbose
' .travis.yml
```

```sh
$ travis lint
```

```sh
$ git add .travis.yml
$ git add tests
$ git add -p
$ git commit -m"added tests"
$ git push origin master
```

```sh
$ travis login --auto
$ travis enable
```

```sh
$ mkdir artifacts
$ sleep 20s && gnome-screenshot --file artifacts/screenshot.png
# for macOS: $ screencapture -T 20 artifacts/screenshot.png
# open https://github.com/${GITHUB_USERNAME}/lab05
```

## Report

```sh
$ popd
$ export LAB_NUMBER=05
$ git clone https://github.com/tp-labs/lab${LAB_NUMBER} tasks/lab${LAB_NUMBER}
$ mkdir reports/lab${LAB_NUMBER}
$ cp tasks/lab${LAB_NUMBER}/README.md reports/lab${LAB_NUMBER}/REPORT.md
$ cd reports/lab${LAB_NUMBER}
$ edit REPORT.md
$ gist REPORT.md
```

## Homework

### Задание
1. Создайте `CMakeList.txt` для библиотеки *banking*.
```sh
(mordecai㉿kali)-[~/workspace/projects]
└─$ git clone https://github.com/tp-labs/lab05.git lab05             
Клонирование в «lab05»...
remote: Enumerating objects: 137, done.
remote: Counting objects: 100% (25/25), done.
remote: Compressing objects: 100% (9/9), done.
remote: Total 137 (delta 18), reused 16 (delta 16), pack-reused 112 (from 1)
Получение объектов: 100% (137/137), 918.92 КиБ | 518.00 КиБ/с, готово.
Определение изменений: 100% (60/60), готово.
                                                                                                                                          
┌──(mordecai㉿kali)-[~/workspace/projects]
└─$ cd lab05/banking
                                                                                                                                          
┌──(mordecai㉿kali)-[~/workspace/projects/lab05/banking]
└─$ touch CMakeLists.txt
CMakeLists.txt:
'''
cmake_minimum_required(VERSION 3.16.3)
set(CMAKE_TRY_COMPILE_TARGET_TYPE "STATIC_LIBRARY")

project(banking)
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

add_library(banking STATIC 
    Account.cpp Account.h 
    Transaction.cpp Transaction.h
)
'''                                                                                                                                       
┌──(mordecai㉿kali)-[~/workspace/projects/lab05/banking]
└─$ ls                                       
Account.cpp  Account.h  CMakeLists.txt  CMakeList.txt  Transaction.cpp  Transaction.h
                                                                                                                                          
┌──(mordecai㉿kali)-[~/workspace/projects/lab05/banking]
└─$ rm CMakeList.txt

(mordecai㉿kali)-[~/workspace/projects/lab05/banking]
└─$ cd ..                       
                                                                                                                                 
┌──(mordecai㉿kali)-[~/workspace/projects/lab05]
└─$ touch CMakeLists.txt

CMakeLists.txt:
'''
cmake_minimum_required(VERSION 3.4)

set(COVERAGE OFF CACHE BOOL "Coverage")
set(CMAKE_CXX_COMPILER "/usr/bin/g++")

project(TestRunning)

add_subdirectory("${CMAKE_CURRENT_SOURCE_DIR}/googletest" "gtest")
add_subdirectory(${CMAKE_CURRENT_SOURCE_DIR}/banking)

add_executable(RunTest ${CMAKE_CURRENT_SOURCE_DIR}/test.cpp)

if(COVERAGE)
    target_compile_options(RunTest PRIVATE --coverage)
    target_link_libraries(RunTest PRIVATE --coverage)
endif()

target_include_directories(RunTest PRIVATE ${CMAKE_CURRENT_SOURCE_DIR}/banking)
target_link_libraries(RunTest PRIVATE gtest gtest_main gmock_main banking)
'''

```
2. Создайте модульные тесты на классы `Transaction` и `Account`.
    * Используйте mock-объекты.
    * Покрытие кода должно составлять 100%.
```sh
(mordecai㉿kali)-[~/workspace/projects/lab05]
└─$ git submodule add https://github.com/google/googletest.git
Клонирование в «/home/mordecai/workspace/projects/lab05/googletest»...
remote: Enumerating objects: 28085, done.
remote: Counting objects: 100% (303/303), done.
remote: Compressing objects: 100% (194/194), done.
remote: Total 28085 (delta 194), reused 114 (delta 106), pack-reused 27782 (from 4)
Получение объектов: 100% (28085/28085), 13.57 МиБ | 1.75 МиБ/с, готово.
Определение изменений: 100% (20802/20802), готово.
                                                                                                                                 
┌──(mordecai㉿kali)-[~/workspace/projects/lab05]
└─$ touch test.cpp
test.cpp:
'''
#include <iostream>
#include <Account.h>
#include <Transaction.h>
#include <gtest/gtest.h>
#include <gmock/gmock.h>

// Mock-класс для Account
class MockAccount : public Account {
public:
    MockAccount(int id, int balance) : Account(id, balance) {}
    MOCK_METHOD(void, Unlock, ());
    MOCK_METHOD(void, Lock, ());
    MOCK_METHOD(int, id, (), (const));
    MOCK_METHOD(void, ChangeBalance, (int diff));
    MOCK_METHOD(int, GetBalance, ());
};

// Mock-класс для Transaction
class MockTransaction : public Transaction {
public:
    MOCK_METHOD(bool, Make, (Account& from, Account& to, int sum));
    MOCK_METHOD(void, set_fee, (int fee));
    MOCK_METHOD(int, fee, ());
};

// Тесты для Account
TEST(Account, Balance_ID_Change) {
    MockAccount acc(1, 100);
    // Проверки вызовов методов
    acc.GetBalance();
    acc.id();
    acc.Unlock();
    acc.ChangeBalance(1000);
    acc.GetBalance();
    acc.ChangeBalance(2);
    acc.GetBalance();
    acc.Lock();
}

TEST(Account, Balance_ID_Change_2) {
    Account acc(0, 100);
    EXPECT_THROW(acc.ChangeBalance(50), std::runtime_error);
    acc.Lock();
    acc.ChangeBalance(50);
    EXPECT_EQ(acc.GetBalance(), 150);
    EXPECT_THROW(acc.Lock(), std::runtime_error);
    acc.Unlock();
}

// Тесты для Transaction
TEST(Transaction, TransTest) {
    MockTransaction trans;
    MockAccount first(1, 100), second(2, 250);
    MockAccount flat_org(3, 10000), org(4, 5000);
    
    trans.set_fee(300);
    trans.Make(first, second, 2000);
    trans.fee();
    first.GetBalance();
    second.GetBalance();
    trans.Make(org, first, 1000);
}
'''
```
3. Настройте сборочную процедуру на **TravisCI**.
```sh
─(mordecai㉿kali)-[~/workspace/projects/lab05]
└─$ mkdir -p .github/workflows
                                                                                                                                 
┌──(mordecai㉿kali)-[~/workspace/projects/lab05]
└─$ touch .github/workflows/main.yml
main.yml:
'''
name: bank

on:
  push:
    branches: [main]
  workflow_dispatch:

jobs:
  BuildProject:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      - name: Build banking library
        run: |
          cd banking
          cmake -H. -B_build
          cmake --build _build

  Testing:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      - name: Setup environment
        run: |
          git submodule update --init
          sudo apt install lcov g++-9
      - name: Run tests
        run: |
          mkdir _build && cd _build
          CXX=/usr/bin/g++-9 cmake -DCOVERAGE=1 ..
          cmake --build .
          ./RunTest
          lcov -t "banking" -o lcov.info -c -d .
      - name: Upload coverage (initial)
        uses: coverallsapp/github-action@master
        with:
          github-token: ${{ secrets.github_token }}
          path-to-lcov: ./_build/lcov.info
      - name: Upload coverage (final)
        uses: coverallsapp/github-action@master
        with:
          github-token: ${{ secrets.github_token }}
'''
```
4. Настройте [Coveralls.io](https://coveralls.io/).

## Links

- [C++ CI: Travis, CMake, GTest, Coveralls & Appveyor](http://david-grs.github.io/cpp-clang-travis-cmake-gtest-coveralls-appveyor/)
- [Boost.Tests](http://www.boost.org/doc/libs/1_63_0/libs/test/doc/html/)
- [Catch](https://github.com/catchorg/Catch2)

```
Copyright (c) 2015-2021 The ISC Authors
```
