This experiment uses [Fluentd](https://docs.fluentd.org/output/elasticsearch) to replicate data between a MySQL database
and an [Elasticsearch](https://www.elastic.co/elasticsearch/) cluster. Inspired by:

Inspired by:

https://www.elastic.co/blog/how-to-keep-elasticsearch-synchronized-with-a-relational-database-using-logstash

---

### Sample data

This sets up a local database called `testing` with username `root` and
password `secret` on port `3600`.

(It imports the `schema.sql` file when the container is run.)

---

| Table | Column | Type |
| ------ | ------ | ------ |
| `foobars` | `id` | `BIGINT` |
| | `baz` | `VARCHAR(255)` |
| | `created_at` | `DATETIME` |
| | `updated_at` | `DATETIME` |

---

### Containers

1. `docker compose up mysql`
2. `docker compose up elasticsearch`
3. `docker compose up fluentd`

(Doing it manually this way is quick & dirty to avoid race conditions
between dependencies starting and Fluent trying to interact with them.)

---

### Fluentd

We install the (input) [fluent-plugin-sql](https://github.com/fluent/fluent-plugin-sql)
plugin and (output) [fluent-plugin-elasticsearch](https://github.com/uken/fluent-plugin-elasticsearch) plugin dependencies in our container and add an appropriate database adapter (mysql2).

They are configured here to run every 5 seconds, keeping track of the state of each run:

```sql
SELECT *
FROM foobars
WHERE updated_at > :last_update_column_value
ORDER BY updated_at ASC
LIMIT 5000
```

and then efficiently updates the documents in Elasticsearch via the Bulk API:

> By default, it creates records using bulk api which performs multiple indexing operations in a single API call.

---

### Elasticsearch

  * http://localhost:9200/foobars_index/_search?pretty
  * http://localhost:9200/foobars_index/_doc/3?pretty
