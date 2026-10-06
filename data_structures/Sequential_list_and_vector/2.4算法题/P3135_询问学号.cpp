// #include <iostream>

// #include <vector>

// using namespace std;

// int main()

// {

//     int n, m;

//     cin >> n >> m;

//     vector<int> num(n + 1);

//     vector<int> student(m + 1);

//     for (int i = 1;i <= n;i++)

//     {

//         cin >> num[i];

//     }

//     for (int i = 1;i <= m;i++)

//     {

//         cin >> student[i];

//         cout << num[student[i]] << endl;

//     }





//     return 0;

// }

//以上是初版，可OJ
//题目属于“离线查询也可当在线查询处理”的模型。
//由于每次查询的结果只依赖于输入的一个索引，并且立刻输出，你完全不需要把所有的查询要求都先存入 vector<int> student 中。
//修改方案：去除 student 数组，复用一个 int 变量边读边输出
//可将空间复杂度从 O(n + m) 降至 O(n)
//修改后代码：
#include <iostream>
#include <vector>

using namespace std;

int main()
{
    // 优化3：解除 I/O 同步，大幅提升 cin/cout 速度
    ios::sync_with_stdio(false);
    cin.tie(nullptr);

    int n, m;
    cin >> n >> m;

    vector<int> num(n + 1);
    for (int i = 1; i <= n; i++)
    {
        cin >> num[i];
    }

    int query;
    // 优化2：去除不必要的 student 数组，直接读取并输出
    for (int i = 1; i <= m; i++)
    {
        cin >> query;
        // 优化1：使用 '\n' 替代 endl，防止频繁清空缓冲区
        cout << num[query] << '\n';
    }

    return 0;
}