#include "stdafx.h"

int main(int argc, char** argv) {
    ::testing::InitGoogleTest(&argc, argv);
    // In Release mode compiler tends to optimize result variable, and we can't break on return statement
    // to observe test results. Thus we should mark result as volatile
    volatile int result = RUN_ALL_TESTS();
    return result;
}