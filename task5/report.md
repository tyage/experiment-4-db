# 課題５

- 工学部情報学科3回
- {student-name}
- {student-id}

質問および更新を実行するSQL文を作成する．

上記で構築したデータベースに対して，以下の各内容のSQL文を作成して，実行してください．

レポートでは，各項目について，SQL文，その説明および実行結果を示しなさい．

また，各SQL文は可能な限り実用的に意味があるものにするようにしてください．

注意：各SQL文は実際に利用される状況を考慮し，現実的に利用可能であるよう心がけること．

1. 関係代数の射影および選択に対応するSQL文
2. 関係代数の自然結合に対応するSQL文
3. UNIONを含むSQL文
4. EXCEPTを含むSQL文
5. DISTINCTを含むSQL文
6. 集合関数(COUNT,SUM,AVG,MAX,MIN)を用いたSQL文
7. 副質問(sub query)を含むSQL文
8. UPDATEを含むSQL文
9. ORDRE BYを含むSQL文
10. Create Viewを含むSQL文

## 1. 関係代数の射影および選択に対応するSQL文

```sql
select id from buyer;
```

```
1
```

# 2. 関係代数の自然結合に対応するSQL文

```sql
select * from product natural left join seller;
```

```
1|1|鮭の切り身|100||
2|1|鮭のムニエル|200||
3|1|鮭のおにぎり|100||
```

# 3. UNIONを含むSQL文

```sql
select * from buyer union all select * from seller;
```

```
1|example@example.com|test|*****
1|seller1@example.com|seller1|********
```

# 4. EXCEPTを含むSQL文

```sql
```

```
```

# 5. DISTINCTを含むSQL文

```sql
```

```
```

# 6. 集合関数(COUNT,SUM,AVG,MAX,MIN)を用いたSQL文

```sql
```

```
```

# 7. 副質問(sub query)を含むSQL文

```sql
```

```
```

# 8. UPDATEを含むSQL文

```sql
```

```
```

# 9. ORDRE BYを含むSQL文

```sql
```

```
```

# 10. Create Viewを含むSQL文

```sql
```

```
```
