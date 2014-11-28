# 課題2

- 工学部情報学科3回
- {student-name}
- {student-id}

課題１で作成したER図について，関数従属性の集合および自明でない多値従属性の集合を求めなさい．

もしこれらの集合が存在しなければ，存在するようにER図を変更すること．

各従属性がなぜ成立するのかを文章で説明すること．

## 関数従属性の集合および自明でない多値従属性の集合

ER図を以下のように変更する

![](https://raw.githubusercontent.com/tyage/experiment-4-db/master/task2/er.png)

- 関数従属性の集合
    - buyer
        - id -> email, name, password
            - 購入者のメールアドレス、名前、パスワードは購入者のIDから導かれる
        - email -> id, name, password
            - 購入者のID、名前、パスワードは購入者のメールアドレスから導かれる
    - seller
        - id -> email, name, password
            - 販売者のメールアドレス、名前、パスワードは販売者のIDから導かれる
        - email -> id, name, password
            - 販売者のID、名前、パスワードは販売者のメールアドレスから導かれる
    - order
        - id -> buyer_id, product_id, created_at
            - 購入者、購入商品、購入時刻は購入IDから導かれる
    - category
        - id -> name
            - カテゴリ名はカテゴリIDから導かれる
    - product
        - id -> seller_id, name, cost
            - 商品販売者、商品名、商品の値段は商品IDから導かれる
- 自明でない多値従属性の集合
    - product_id ->-> (category_id) | (buyer_id, created_at)
        - 商品のIDからカテゴリIDの集合と、注文用の購入者IDと購入時刻の集合が導かれる
