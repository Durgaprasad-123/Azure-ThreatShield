FROM python:3.12-slim

WORKDIR /app

COPY requirements.txt .

RUN printf 'openssl_conf = openssl_init\n[openssl_init]\nssl_conf = ssl_sect\n[ssl_sect]\nsystem_default = system_default_sect\n[system_default_sect]\nGroups = X25519:secp256r1:x448:secp521r1:secp384r1\n' > /etc/ssl/no-pq.cnf

ENV OPENSSL_CONF=/etc/ssl/no-pq.cnf

RUN pip install --no-cache-dir --timeout 120 --retries 10 -r requirements.txt

COPY app/ ./app/

USER 10001

EXPOSE 8000

CMD [ "uvicorn","app.api.main:app","--host","0.0.0.0","--port","8000" ]
