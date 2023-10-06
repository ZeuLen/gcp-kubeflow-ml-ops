import kfp
from google.cloud import aiplatform
from google_cloud_pipeline_components import aiplatform as gcc_aip

project_id = "cdp-developers-developer-8"
pipeline_root_path = "gs://vertex-model-pipeline-artefacts/developer-8"


# Define the workflow of the pipeline.
@kfp.dsl.pipeline(
    name="automl-image-training-v2",
    pipeline_root=pipeline_root_path)
def pipeline(project_id: str):


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
