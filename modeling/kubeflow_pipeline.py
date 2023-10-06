import kfp
from google.cloud import aiplatform
from google_cloud_pipeline_components import aiplatform as gcc_aip

project_id = "cdp-developers-developer-8"
pipeline_root_path = "gs://vertex-model-pipeline-artefacts/developer-8"
BASE_IMAGE = "Test"


# @component(base_image=BASE_IMAGE)

@component(base_image=BASE_IMAGE)
def fetch_data(input_target_categories_csv: Input[Dataset]) -> list:
    from lib import fetch_data
    from fetch_training_data import fetch_training_data_from_gcs

    bucket_name = "test"
    file_name = "test"
    fetch_training_data_from_gcs(bucket_name, file_name)


@component()
def preprocessing(input_target_categories_csv: Input[Dataset]) -> list:
    bucket_name = "test"
    file_name = "test"
    fetch_training_data_from_gcs(bucket_name, file_name)


@component()
def train(input_target_categories_csv: Input[Dataset]) -> list:
    bucket_name = "test"
    file_name = "test"
    fetch_training_data_from_gcs(bucket_name, file_name)


@component()
def predict(input_target_categories_csv: Input[Dataset]) -> list:
    bucket_name = "test"
    file_name = "test"
    fetch_training_data_from_gcs(bucket_name, file_name)


# Define the workflow of the pipeline.
@kfp.dsl.pipeline(
    name="automl-image-training-v2",
    pipeline_root=pipeline_root_path)
def pipeline(project_id: str):
    input_data = fetch_data()
    preprocessing = preprocessing()
    input_data = train()
    input_data = predict()


if __name__ == '__main__':
    from kfp.v2 import compiler
    import argparse

    # Setup terminal argument parsing
    parser = argparse.ArgumentParser()
    parser.add_argument('--path', help='Path for the package output')
    args = parser.parse_args()
    path = args.path

    # Call the compile_pipeline function with the updated path
    compiler.Compiler().compile(pipeline_func=pipeline, package_path=path)

    DISPLAY_NAME = "test_gam_modeling" + TIMESTAMP

    job = aip.PipelineJob(
        display_name=DISPLAY_NAME,
        template_path="lightweight_pipeline.json",
        pipeline_root=PIPELINE_ROOT,
        parameter_values={'project_id': PROJECT_ID,
                          'date': DATE,
                          'interval': INTERVAL,
                          'n_training': N_TRAINING,
                          'path_categories_csv': PATH_CATEGORIES_CSV,
                          'path_stopwords_csv': PATH_STOPWORDS_CSV,
                          'gcs_gam_bucket': GCS_GAM_BUCKET},
    )

    job.run(service_account=SERVICE_ACCOUNT)
