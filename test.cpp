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
