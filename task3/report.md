# 課題3

- 工学部情報学科3回
- {student-name}
- {student-id}

課題２で求めた従属性集合に基づいて，関係スキーマを設計しなさい．どのような正規形が得られたかを説明すること．

## 関係スキーマ

- buyer (id, email, name, password)
- seller (id, email, name, password)
- order (id, buyer_id, product_id, created_at)
- product (id, seller_id, name, cost)
- group (id, name)
- category (id, name)
- group_product (id, group_id, product_id)
- group_category (id, group_id, category_id)

## 正規形

### 第二正規形

- buyer
    - email, name, passwordはidに完全関数従属している
- seller
    - email, name, passwordはidに完全関数従属している
- group
    - nameはidに完全関数従属している
- category
    - nameはidに完全関数従属している

### 第三正規形

- order
    - buyer_idからbuyerが、product_idからproductが導出できる
- product
    - seller_idからsellerが導出できる

### 第四正規形

- group_product
    - 自明でない多値従属性は、group_id, product_idのキーの関係従属性から導かれるものである
- group_category
    - 自明でない多値従属性は、group_id, category_idのキーの関係従属性から導かれるものである
