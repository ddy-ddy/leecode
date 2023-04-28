'''
Author: ddy-ddy
Date: 2023-04-28 09:34:46
LastEditTime: 2023-04-28 09:59:01
Github: https://github.com/ddy-ddy
Website: https://ddy-ddy.com
'''
#
# @lc app=leetcode.cn id=3 lang=python3
#
# [3] 无重复字符的最长子串
#

# @lc code=start

'''
解题思路：使用滑动窗口解决该问题
具体来说，我们使用两个指针 i 和 j 表示当前子串的左右边界，初始时均指向字符串的起始位置。我们使用一个哈希集合来存储当前子串中出现过的字符，初始时集合为空。
然后，我们向右移动右指针 j，如果当前字符 s[j] 不在哈希集合中，我们将其加入集合中，并更新最长子串的长度。
如果当前字符 s[j] 在哈希集合中，我们不断地向右移动左指针 i，直到当前子串中不再包含字符 s[j]，然后再将 s[j] 加入集合中。
如此循环，直到右指针 j 到达字符串的末尾。
具体实现时，我们可以使用 Python 的集合数据结构 set 来实现哈希集合，使用一个变量 ans 来记录最长子串的长度。
'''


class Solution:
    def lengthOfLongestSubstring(self, s: str) -> int:
        n = len(s)
        ans = 0
        i = j = 0
        hashset = set()
        while j < n:
            if s[j] not in hashset:
                hashset.add(s[j])
                j += 1
                ans = max(ans, j - i)
            else:
                hashset.remove(s[i])
                i += 1
        return ans

# @lc code=end

