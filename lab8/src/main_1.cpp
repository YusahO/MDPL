#include <iostream>
#include <chrono>

constexpr std::size_t REPS = 1e7;

template <typename T>
void measureAddTimeASM(T a, T b, std::size_t reps)
{
    T res;
    std::chrono::duration<double, std::milli> deltaTime;
    std::size_t cntr = reps;
    while (--cntr)
    {
        auto start = std::chrono::system_clock::now();
        __asm__ (
            "fld %1\n"
            "fld %2\n"
            "faddp %%ST(1), %%ST(0)\n"
            "fstp %0\n"
            : "=m"(res)
            : "m"(a),
              "m"(b)
        );
        auto end = std::chrono::system_clock::now();
        deltaTime += end - start;
    }

    deltaTime /= reps;

    std::cout << "Addition time for " << reps << " repetitions: " << deltaTime.count() << " ms\n";
}

template <typename T>
void measureMulTimeASM(T a, T b, std::size_t reps)
{
    T res;
    std::chrono::duration<double, std::milli> deltaTime;
    std::size_t cntr = reps;
    while (--cntr)
    {
        auto start = std::chrono::system_clock::now();
        __asm__ (
            "fld %1\n"
            "fld %2\n"
            "fmulp %%ST(1), %%ST(0)\n"
            "fstp %0\n"
            : "=m"(res)
            : "m"(a),
              "m"(b)
        );
        auto end = std::chrono::system_clock::now();
        deltaTime += end - start;
    }

    deltaTime /= reps;

    std::cout << "Multiplication time for " << reps << " repetitions: " << deltaTime.count() << " ms\n";
}

template <typename T>
void measureAddTimeCPP(T a, T b, std::size_t reps)
{
    T res;
    std::chrono::duration<double, std::milli> deltaTime;
    std::size_t cntr = reps;
    while (--cntr)
    {
        auto start = std::chrono::system_clock::now();
        res = a + b;
        auto end = std::chrono::system_clock::now();
        deltaTime += end - start;
    }

    deltaTime /= reps;

    std::cout << "Addition time for " << reps << " repetitions: " << deltaTime.count() << " ms\n";
}

template <typename T>
void measureMulTimeCPP(T a, T b, std::size_t reps)
{
    T res;
    std::chrono::duration<double, std::milli> deltaTime;
    std::size_t cntr = reps;
    while (--cntr)
    {
        auto start = std::chrono::system_clock::now();
        res = a * b;
        auto end = std::chrono::system_clock::now();
        deltaTime += end - start;
    }

    deltaTime /= reps;

    std::cout << "Multiplication time for " << reps << " repetitions: " << deltaTime.count() << " ms\n";
}

int main()
{
    float af = 10.1f, bf = 6.9f;
    double ad = 133.7, bd = 1.8;

    #ifndef ASM
    std::cout << "\nCPP-only operations performance\n";

    std::cout << "----- FLOAT -----\n";
    measureAddTimeCPP(af, bf, REPS);
    measureMulTimeCPP(af, bf, REPS);

    std::cout << "----- DOUBLE -----\n";
    measureAddTimeCPP(ad, bd, REPS);
    measureMulTimeCPP(ad, bd, REPS);

    #else
    std::cout << "\nCPP with ASM insert operations performance\n";

    std::cout << "----- FLOAT -----\n";
    measureAddTimeASM(af, bf, REPS);
    measureMulTimeASM(af, bf, REPS);

    std::cout << "----- DOUBLE -----\n";
    measureAddTimeASM(ad, bd, REPS);
    measureMulTimeASM(ad, bd, REPS);
    #endif

    return 0;
}
