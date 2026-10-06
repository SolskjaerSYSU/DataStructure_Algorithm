//解法1：利用一个辅助数组 但是这种方法在力扣里不允许
//解法2：利用双指针 
//数组分块 —— 数组分两块
//cur：标记非0元素的最后一个位置
//i：扫描数组
//当然我们这里是选择一个变量来充当指针

#include <iostream>
#include <string>
#include <utility>
using namespace std;
int main()
{
    class Solution
    {
    public:
        void moveZeroes(vector<int>& nums)
        {
            int cur = -1;
            for (int i = 0;i < nums.size();i++)
            {
                if (nums[i]) //如果非0
                {
                    swap(nums[++cur], nums[i]);
                }
            }
        }
    };
    return 0;
}