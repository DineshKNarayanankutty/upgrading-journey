"""Push features to an online store (Redis example)."""
import redis, pandas as pd

r  = redis.Redis(host='localhost', port=6379)
df = pd.read_parquet('features/latest.parquet')

for _, row in df.iterrows():
    key = f"user:{row['user_id']}"
    r.hset(key, mapping=row.to_dict())
print(f'Pushed {len(df)} feature rows')
