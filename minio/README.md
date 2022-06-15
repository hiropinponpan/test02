- minio deploy using kustomize

```
bash minio.sh dev 1
```

# minio mcコマンドのサンプル

## エイリアス登録例(エイリアス名：minio、ユーザ名:minio、パスワード：minio-secret)
```
$ mc alias set minio http://localhost:9000 minio minio-secret
```

## ユーザ作成例(エイリアス名：minio、ユーザ名：user01、パスワード：P@ssw0rd)
```
$ mc admin user add minio user01 P@ssw0rd
Added user `user01` successfully.
```

## ポリシー一覧の確認(エイリアス名:minio)
```
$ mc admin policy list minio
writeonly
diagnostics
readonly
readwrite
```

## ポリシー内容の確認(エイリアス名：minio、ポリシー名：readwrite)
```
$ mc admin policy info minio readwrite | jq
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "s3:*"
      ],
      "Resource": [
        "arn:aws:s3:::*"
      ]
    }
  ]
}
```

## ユーザへのポリシー適用例(エイリアス名：minio、適用ポリシー名：readwrite、適用するユーザ名：user01)
```
$ mc admin policy set minio readwrite user=user01
Policy `readwrite` is set on user `user01`
```

## バケットへのライクサイクルポリシー設定例(エイリアス名：minio、バケット名：bucket01、ファイルの有効期限：20日)
```
$ mc ilm add --expiry-days 20 minio/bucket01
Lifecycle configuration rule added with ID `c9fb0qdj0kketq130mf0` to minio/bucket01.
```

## バケットへのライクサイクルポリシーの確認(エイリアス名：minio、バケット名：bucket01)
```
$ mc ilm ls minio/bucket01
          ID          |     Prefix     |  Enabled   | Expiry |  Date/Days   |  Transition  |    Date/Days     |  Storage-Class   |          Tags
----------------------|----------------|------------|--------|--------------|--------------|------------------|------------------|------------------------
 c9fb0qdj0kketq130mf0 |                |    ?       |  ?     |  20 day(s)   |     ?        |                  |                  |
----------------------|----------------|------------|--------|--------------|--------------|------------------|------------------|------------------------
```

