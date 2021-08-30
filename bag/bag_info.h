

// 背包信息
struct bag_info
{
    int m_role_id;      // 背包所属人物id       pk
    int m_row;          // 背包行数
    int m_col;          // 背包列数
    int m_cell_num;     // 格子数，实际就是 row*col，可以去掉这个
};

// 背包一个物品信息
struct bag_item
{
    uint64_t m_uid;     // 物品唯一id           pk
    int m_type_id;      // 物品类别
    int m_role_id;      // 物品所属人物id
    int m_num;          // 物品数量
    int m_row;            // 物品在背包里的行数
    int m_col;            // 物品在背包里的列数
};


struct role_info
{
    /* data */
};

