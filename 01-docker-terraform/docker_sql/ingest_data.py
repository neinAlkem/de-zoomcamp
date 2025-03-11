
import pandas as pd
import pyarrow.parquet as pq 
from sqlalchemy import create_engine
import psycopg2
import argparse
import os
import pyarrow

def ingest_data(params):
    user = params.user
    password = params.password
    host = params.host
    port = params.port
    database_name = params.db
    table_name = params.tb
    url = params.url
    parquet_name = 'output.parquet'
    
    os.system(f"curl -o {parquet_name} {url}")

    yellow_trips = pq.read_table('output.parquet')
    df = yellow_trips.to_pandas()

    engine = create_engine(f'postgresql://{user}:{password}@{host}:{port}/{database_name}')

    df.head(n=0).to_sql(name=table_name,con=engine,if_exists='replace',index=False)
    
    chunk_size = 10000
    for start in range(0, len(df), chunk_size):
        df_chunk = df.iloc[start:start+chunk_size]
        df_chunk.to_sql(name=table_name, con=engine, if_exists='append', index=False)

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description='Ingest Parquet Data to Postgres')

    parser.add_argument('--user', required=True, help='User name for PostgreSQL')
    parser.add_argument('--password', required=True, help='Password for PostgreSQL')
    parser.add_argument('--host', required=True, help='Host for PostgreSQL')
    parser.add_argument('--port', required=True, help='Port for PostgreSQL')
    parser.add_argument('--db', required=True, help='Database name for PostgreSQL')
    parser.add_argument('--tb', required=True, help='Table name for the file to be ingested')
    parser.add_argument('--url', required=True, help='URL for the parquet file')

    args = parser.parse_args()
    ingest_data(args)




