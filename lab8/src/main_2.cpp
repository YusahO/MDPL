#include <iostream>

#define _USE_MATH_DEFINES
#include <math.h>

double sinAsm() {

    double res;

    __asm__ (
        "fldpi\n"
        "fsin\n"
        "fstp %0\n"
        : "=m"(res)
    );

    return res;
}

double sinAsmHalf() {

    double res;
    double half = 2;

    __asm__ (
        "fld %1\n"
        "fldpi\n"
        "fdiv %%ST(0), %%ST(1)\n"
        "fsin\n"
        "fstp %0\n"
        : "=m"(res)
        : "m"(half)
    );

    return res;
}

void sinPi() {
    std::cout << "\n_______PI______\n" << std::endl;
    std::cout << "sin(3.14): " << sin(3.14) << std::endl;
    std::cout << "sin(3.141596): " << sin(3.141596) << std::endl;
    std::cout << "sin(M_PI): " << sin(M_PI) << std::endl;
    std::cout << "sinAsm(): " << sinAsm() << std::endl;
}

void sinPiHalf() {
    std::cout << "\n_______PI / 2______\n" << std::endl;
    std::cout << "sin(3.14 / 2): " << sin(3.14 / 2) << std::endl;
    std::cout << "sin(3.141596): " << sin(3.141596 / 2) << std::endl;
    std::cout << "sin(M_PI / 2): " << sin(M_PI / 2) << std::endl;
    std::cout << "sinAsmHalf(): " << sinAsmHalf() << std::endl;
}

int main()
{
    sinPi();
    sinPiHalf();

    return 0;
}
