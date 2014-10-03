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
        - id -> buyer_id, product_id, created_at
            - orderはidをprimary keyに持つため
    - product
        - id -> seller_id, name, cost
            - productはidをprimary keyに持つため
        - seller_id, name -> id, cost
            - seller_idとnameが同じproductは複数存在しないため
- 自明でない多値従属性の集合
