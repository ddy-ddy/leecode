'''
Author: ddy-ddy
Date: 2023-04-26 09:39:22
LastEditTime: 2023-04-26 09:55:37
Github: https://github.com/ddy-ddy
Website: https://ddy-ddy.com
'''
'''
解题思路：两个链表中同一位置的数字可以直接相加，如果大于10，则进位，将进位的值加到下一位的计算中。
'''
#
# @lc app=leetcode.cn id=2 lang=python3
#
# [2] 两数相加
#

# @lc code=start
# Definition for singly-linked list.
# class ListNode:
#     def __init__(self, val=0, next=None):
#         self.val = val
#         self.next = next
class Solution:
    def addTwoNumbers(self, l1: Optional[ListNode], l2: Optional[ListNode]) -> Optional[ListNode]:
            l3 = ListNode()
            cur = l3
            carry = 0
            while l1 or l2 or carry:
                x = l1.val if l1 else 0
                y = l2.val if l2 else 0
                sum = x+y+carry
                carry = sum//10
                cur.next=ListNode(sum%10)
                cur = cur.next
                l1=l1.next if l1 else None
                l2 = l2.next if l2 else None
            return l3.next
    
# @lc code=end