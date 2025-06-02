## 更改root用户密码
```shell
sudo mysql
```
```sql
ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY 'xmlxzl';
FLUSH PRIVILEGES;
```
