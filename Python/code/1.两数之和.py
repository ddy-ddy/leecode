'''
Author: ddy-ddy
Date: 2023-04-26 09:31:10
LastEditTime: 2023-04-26 09:38:09
Github: https://github.com/ddy-ddy
Website: https://ddy-ddy.com
'''
#
# @lc app=leetcode.cn id=1 lang=python3
#
# [1] 两数之和
#

# @lc code=start
class Solution:
    def twoSum(self, nums: List[int], target: int) -> List[int]:
        for i,data in enumerate(nums):
            for j in range(i+1,len(nums)):
                if data+nums[j]==target:
                    return [i,j]
# @lc code=end

