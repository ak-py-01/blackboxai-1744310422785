import os
import subprocess
import tempfile
from fastapi import HTTPException, status
from typing import Any, Dict
import pandas as pd

def execute_insight_script(script_content: str, data: Dict[str, Any]) -> Any:
    """Execute a user-uploaded Python script and return the results."""
    try:
        # Create a temporary directory to store the script
        with tempfile.TemporaryDirectory() as temp_dir:
            script_path = os.path.join(temp_dir, "insight_script.py")

            # Write the script content to a file
            with open(script_path, "w") as script_file:
                script_file.write(script_content)

            # Prepare the data for the script
            data_file_path = os.path.join(temp_dir, "data.json")
            with open(data_file_path, "w") as data_file:
                pd.DataFrame(data).to_json(data_file, orient="records")

            # Execute the script
            result = subprocess.run(
                ["python", script_path, data_file_path],
                capture_output=True,
                text=True
            )

            if result.returncode != 0:
                raise HTTPException(
                    status_code=status.HTTP_400_BAD_REQUEST,
                    detail=f"Script execution failed: {result.stderr}"
                )

            # Return the output of the script
            return result.stdout
    except Exception as e:
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail=f"Error executing script: {str(e)}"
        )
