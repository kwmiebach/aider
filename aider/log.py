def _get_path():
    # get the full path from the environment variable
    import os
    return os.environ.get('AIDER_DEBUG_FILE')


def debug_nobreak(data):
    fullpath = _get_path()
    if fullpath is None:
        return
    # if data is a string, just write it to the file
    if isinstance(data, str):
        full_message = data
    elif data is None:
        full_message = ''
    else:
        import pprint
        full_message = pprint.pformat(data)
    with open(fullpath, 'a') as f:
        f.write(full_message)


def debug(data, title=None):
    fullpath = _get_path()
    if fullpath is None:
        return

    # if data is a string, just write it to the file
    if isinstance(data, str):
        full_message = data
    elif data is None:
        full_message = ''
    else:
        import pprint
        full_message = pprint.pformat(data)
    with open(fullpath, 'a') as f:
        import datetime
        dt_iso = str(datetime.datetime.now())[:20]
        if title is not None:
            f.write('*** ' + title + ' ' + dt_iso + ' ***\n')
        else:
            f.write('***' + dt_iso + '***\n')
        f.write('\n')
        f.write(full_message + '\n')
        f.write('\n')

def log_codeblock_md(data, filename, header=None):
    # Log as markdown.
    # Header and a code block.
    from pprint import pformat as pf
    output = pf(data)
    with open(filename, 'a') as f:
        f.write('\n')
        if header is not None:
            f.write('##### ' + header)
            f.write('\n\n')
        f.write('```\n')
        f.write(output)
        f.write('\n```')
        f.write('\n\n')
