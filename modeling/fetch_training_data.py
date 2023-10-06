import pandas as pd
from google.cloud import storage


def fetch_training_data_from_gcs(bucket_name, file_name):
    client = storage.Client()
    bucket = client.bucket(bucket_name)
    blob = bucket.blob(file_name)

    try:
        data = blob.download_as_text()
        df = pd.read_csv(pd.compat.StringIO(data))
        return df

    except Exception as e:
        print(f"Error fetching CSV from GCS: {e}")
        return None
