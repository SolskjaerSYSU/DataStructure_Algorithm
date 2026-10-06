#include <iostream>
#include <vector>
using namespace std;

const int N = 1e5 + 10;

int n, q;

vector <int> a[N]; //创建N个柜子（N个数组） 他们的格子多少为动态的


int main()
{
    cin >> n >> q;
    while (q--)  //执行q次操作的常用解法
    {
        int op, i, j, k;
        cin >> op >> i >> j;

        if (op == 1) // 存
        {
            cin >> k;
            if (a[i].size() <= j) //如果你要找的这个第i个柜子它的大小没有j个格子
            {
                //此时我们需要扩容
                a[i].resize(j + 1);
            }
            a[i][j] = k;  //存入：把k存入第i个柜子的第j个格子
        }
        else  //查
        {
            cout << a[i][j] << endl;
        }
    }

    return 0;
}