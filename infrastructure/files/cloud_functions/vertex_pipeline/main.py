import os
import logging
import json
import base64
import google.cloud.logging
from google.cloud import aiplatform

logging_client: google.cloud.logging.Client | None = None

# Retrieve Cloud Function Env Variables
SERVICE_ACCOUNT_NAME = os.getenv("service_account_name")
REGION = os.getenv("region")


def create_vertex_pipeline_run(event: dict, context: object):
    """
    Creates a Vertex AI Pipeline run based on the provided variables passed in form of environment variables within the
     cloud function. The cloud function is triggered by a pubsub + cloud scheduler.

    Args:
        event (Dict[str, Any]): The event payload.
        context (Any): The event context.

    Returns:
        str: A message indicating that the job has been submitted.
    """
    setup_logging()
    logging.info("Starting creation of Vertex AI Pipeline creation..")

    # Access the JSON payload
    payload = base64.b64decode(event['data']).decode('utf-8')
    data = json.loads(payload)
    project_id = data['project_id']
    pipeline_name = data['pipeline_name']
    pipeline_path = data['pipeline_path']

    print(project_id)
    print(pipeline_name)
    print(pipeline_path)

    try:
        # initialize Vertex AI platform
        aiplatform.init(
            project=project_id,
            location=REGION,
        )

        # Define Pipeline Job Config
        job = aiplatform.PipelineJob(
            display_name=pipeline_name,
            template_path=pipeline_path,
            enable_caching=False,
            project=project_id,
            parameter_values={"project_id": project_id}
        )

        # Submit Vertex AI Pipeline Job
        job.submit(service_account=SERVICE_ACCOUNT_NAME)
        logging.info("Vertex Ai pipeline run job was successfully submitted..")
        return "Job submitted"
    except Exception as e:
        logging.error(e)
        return e, 500


def setup_logging() -> None:
    """
    Set up the logging client for GCP cloud logging and assign it to a global variable. This lazy initialization allows
    the reuse of an existing logging_client in future invocations of this Cloud Function.
    """
    global logging_client
    if logging_client is not None:
        return

    logging_client = google.cloud.logging.Client()
    logging_client.setup_logging()
