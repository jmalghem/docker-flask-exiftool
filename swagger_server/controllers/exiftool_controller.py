import connexion
import six
import uuid
import os
import exiftool
import shutil

from swagger_server.models.api_response import ApiResponse  # noqa: E501
from swagger_server import util


def add_exiftool(upfile=None):  # noqa: E501
    """Examine a file with Exiftool

     # noqa: E501

    :param upfile: The file to upload
    :type upfile: werkzeug.datastructures.FileStorage

    :rtype: ApiResponse

    """
    uniqueId = uuid.uuid4()
    filepath = '{}/exiftool'.format(str(uniqueId))
    os.makedirs(os.path.dirname('./submitted/{}'.format(filepath)), exist_ok=True)
    try:
        uploaded_file = connexion.request.files['upfile']
        uploaded_file.save('./submitted/{}'.format(filepath))
        files = [ 'submitted/{}'.format(filepath) ]
        with exiftool.ExifTool() as et:
            metadata = et.get_metadata_batch(files)
        try:
            shutil.rmtree(os.path.dirname('./submitted/{}'.format(filepath)))
        except OSError as e:
            return { "code": 500, "type": "error", "message": e.strerror }
    except:
        return { "code": 500, "type": "error", "message": "Error during process"}
    return { "code": 200, "type": uniqueId, "message": metadata }

