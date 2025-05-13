FROM cgr.dev/chainguard/python:latest-dev AS dev
LABEL maintainer="yohrannes@gmail.com"
WORKDIR /app

RUN python -m venv venv
ENV PATH="/app/venv/bin":$PATH
COPY requirements.txt .
RUN pip install -qr requirements.txt --no-cache
#RUN pip install --upgrade --upgrade-strategy <JUST_PACKAGE_NAMES> <JUST_PACKAGE_NAMES> <..> --no-cache

FROM cgr.dev/chainguard/python:latest

WORKDIR /app
ENV PATH="/app/venv/bin:$PATH"
ENV PYTHONUNBUFFERED=1

COPY --from=dev /app/venv /app/venv
COPY app.py .
COPY healthcheck.py .
COPY templates/ templates/
COPY static/ static/
COPY fonts/ fonts/
#ENV FLASK_ENV=development

#ENTRYPOINT ["python3", "app.py"]
ENTRYPOINT ["gunicorn", "--bind", "0.0.0.0:5000", "--workers", "2", "--threads", "4", "app:app"]
HEALTHCHECK --interval=30s --timeout=5s --start-period=10s --retries=3 CMD ["python3", "/app/healthcheck.py"]