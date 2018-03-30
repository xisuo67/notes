using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace BinarySearch
{
    public static class SearchMehtod
    {
        /// <summary>
        /// 二分查找方法实现
        /// </summary>
        /// <param name="Array">数组对象</param>
        /// <param name="key">查询对象</param>
        /// <returns></returns>
        public static int BinarySearchs(this int[] array, int? start,int? end, int key)
        {
            //开始索引与结束索引
            int index = 0;
            int endIndex = array.Length - 1;
            int low = start ?? index;
            int hight = end ?? endIndex;
            int mid = (low+hight) / 2;
            if (index>end)
                return -1;
            else
            {
                if (array[mid]==key)
                    return mid;
                else if(array[mid]>key)
                    return BinarySearchs(array,low, mid - 1,key);
                else
                    return BinarySearchs(array,mid + 1,null ,key);
            }
        }
    }
}
