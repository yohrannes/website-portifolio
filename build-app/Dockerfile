FROM cgr.dev/chainguard/python:latest-dev as dev
LABEL maintainer="yohrannes@gmail.com"
WORKDIR /app

RUN python -m venv venv
ENV PATH="/app/venv/bin":$PATH
COPY requirements.txt .
RUN pip install -r requirements.txt

FROM cgr.dev/chainguard/python:latest
COPY --from=dev /app/venv /app/venv

WORKDIR /app

COPY app.py .
COPY templates/ templates/
COPY static/ static/
COPY fonts/ fonts/
ENV PATH="/app/venv/bin:$PATH"
ENV PYTHONUNBUFFERED=1
ENV FLASK_ENV=development

ENTRYPOINT ["flask", "run", "--host=0.0.0.0"]
HEALTHCHECK --timeout=2s CMD curl -f localhost:5000 || exit 1