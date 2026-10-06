#include <iostream>
#include <vector>
using namespace std;
int main()
{
    int n, m;
    cin >> n >> m;
    vector<int> num(n + 1);
    vector<int> student(m + 1);
    for (int i = 1;i <= n;i++)
    {
        cin >> num[i];
    }
    for (int i = 1;i <= m;i++)
    {
        cin >> student[i];
        cout << num[student[i]] << endl;
    }


    return 0;
}