import datetime
import locale
import pathlib
import subprocess


def record_dir() -> pathlib.Path:
    return pathlib.Path.home() / 'record'


def create_today_record() -> pathlib.Path:
    locale.setlocale(locale.LC_ALL, 'ja_JP')
    today = datetime.date.today()
    today_record = record_dir() / (today.strftime('%Y-%m') + '.md')
    separator = '----\n\n'
    headers = ""
    titles = ""
    contents = ""
    if today_record.exists():
        with today_record.open() as file:
            data = file.read()
            index = data.find(separator)
            if index < 0:
                contents = data
            else:
                headers = data[:index+len(separator)]
                contents = data[index+len(separator):]
    else:
        headers = '# ' + today.strftime('%Y-%m') + '\n\n' + separator
    current = today
    while current.month == today.month:
        if current.weekday() != 5 and current.weekday() != 6:
            title = '## ' + current.strftime('%Y-%m-%d %a') + '\n'
            if title not in contents:
                titles += title + '\n\n'
        current -= datetime.timedelta(days=1)
    today_record.write_text(headers + titles + contents)
    return today_record


def record():
    if record_dir().exists():
        today_diary = create_today_record()
        subprocess.check_call(['/opt/homebrew/bin/cursor', record_dir(), today_diary])
    else:
        exit(1)


if __name__ == '__main__':
    record()
