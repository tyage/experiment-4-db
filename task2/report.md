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

- 関係従属性の集合
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
        - id -> buyer_id, created_at
            - orderはidをprimary keyに持つため
- 自明でない多値従属性の集合
    - product_group
        - group_name -> (product_name) | (category)
            - 同一の商品グループの商品は、必ず同じカテゴリ群に所属するため
            - 例: マグロのグループに所属する商品A、商品Bはどちらも食べ物、魚介のカテゴリを持つ
