import redis
r = redis.Redis(
    host='redis-12248.c265.us-east-1-2.ec2.redis-cloud.com',
    port=12248,
    password='26zpqrINI3sLhRq5rfyC3LkDzz863gpO',
    ssl=True,
    decode_responses=True
)
r.set("hello", "world")
print(r.get("hello"))
