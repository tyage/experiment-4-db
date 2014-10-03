# 課題2

- 工学部情報学科3回
- {student-name}
- {student-id}

課題１で作成したER図について，関数従属性の集合および自明でない多値従属性の集合を求めなさい．

もしこれらの集合が存在しなければ，存在するようにER図を変更すること．

各従属性がなぜ成立するのかを文章で説明すること．

## 関数従属性の集合および自明でない多値従属性の集合

ER図を以下のように変更する

![](https://raw.githubusercontent.com/tyage/experiment-4/master/task2/er.png)

- 関数従属性の集合
    - buyer
        - id -> email, name, password
            - buyerはidをprimary keyに持つため
        - email -> id, name, password
            - buyerのemailはuniqueであるため
    - seller
        - id -> email, name, password
            - sellerはidをprimary keyに持つため
        - email -> id, name, password
            - sellerのemailはuniqueであるため
    - order
        - id -> buyer_id, product_id, created_at
            - orderはidをprimary keyに持つため
    - product_group
        - product_id -> product_seller_id, product_name, product_cost
            - 同一の商品idを持つ商品は販売者、商品名、金額が同一であるため
- 自明でない多値従属性の集合
    - product_group
        - group_name -> (product_id, product_seller_id, product_name, producut_cost) | (category)
            - 同一の商品グループの商品は、必ず同じカテゴリ群に所属するため
            - 例: マグロのグループに所属する商品A、商品Bはどちらも食べ物、魚介のカテゴリを持つ
