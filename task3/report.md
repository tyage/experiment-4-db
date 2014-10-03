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
- category (id, name)
- product_category (id, product_id, category_id)

## 正規形

### 第二正規形

- buyer
    - email, name, passwordはidに完全関数従属している
- seller
    - email, name, passwordはidに完全関数従属している
- category
    - nameはidに完全関数従属している

### 第三正規形

- order
    - buyer_idからbuyerが、product_idからproductが導出できる
- product
    - seller_idからsellerが導出できる

### 第四正規形

- product_category, order
    - 自明でない多値従属性 product_id ->-> (category_id) | (buyer_id, creted_at) はキーの関数従属性から導かれるものである。
