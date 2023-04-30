'''
Author: ddy-ddy
Date: 2023-04-30 21:58:44
LastEditTime: 2023-04-30 22:09:49
Github: https://github.com/ddy-ddy
Website: https://ddy-ddy.com
'''
#
# @lc app=leetcode.cn id=9 lang=python3
#
# [9] 回文数
#

# @lc code=start
class Solution:
    def isPalindrome(self, x: int) -> bool:
        if x<0:
            return False
        elif x==0:
            return True
        else:
            x=str(x)
            if x==x[::-1]:
                return True
            else:
                return False
# @lc code=end

