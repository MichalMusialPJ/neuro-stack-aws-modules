
Variants:

Replication 
- Simple
- Live replication 1:1
- Cross account possible
- Can't do that, need versioning for buckets - clickhouse probably cannot use bucket with versioning on

EventBridge + Lambda
- We can use aws s3 sync and it will make delta operation to copy only diff
- Daily backups automatic
- Harder to implement and maintain
- Probably very hard to implement, cuz lambda would need to assume role from different account - i think it's doable, we should talk about that with someone from cloud

BatchJob Replication 
- better than replication
- can do it daily adding lambda and event bridge
- need versioning or he will be copying every object every time.

CloudTrail data events - investigation of clickhouse operations
