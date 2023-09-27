import google.cloud.aiplatform as aip
from datetime import datetime, timedelta
import logging

STATES = ["PIPELINE_STATE_UNSPECIFIED",
          "PIPELINE_STATE_QUEUED",
          "PIPELINE_STATE_PENDING",
          "PIPELINE_STATE_RUNNING",
          "PIPELINE_STATE_CANCELLING",
          "PIPELINE_STATE_PAUSED"]

MAX_DURATION = timedelta(hours=8, minutes=0, seconds=0, microseconds=0)


def check_pipeline_jobs(event, context):
    """
    Entry point for checking pipeline jobs.
    """
    try:
        pipelines = aip.PipelineJob.list()
        current_datetime = datetime.now()

        for pipeline in pipelines:
            pipeline_creation_time = datetime.fromtimestamp(pipeline.create_time.timestamp())

            is_state_failure = pipeline.state in STATES
            is_duration_failure = (current_datetime - pipeline_creation_time) > MAX_DURATION
            if is_duration_failure and is_state_failure:
                logging.info(f"{pipeline} has been running for more than 8 hours and is currently in the state: {pipeline.state}.")
    except Exception as e:
        logging.error(e)
