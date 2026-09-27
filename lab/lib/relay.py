"""A tiny HTTP CONNECT relay for the vm labs.

Guest NAT traffic leaves through the host's raw interface, which on
vpn'd networks misses the tunnel entirely (github resets, dns trouble).
Proxied through this relay, connections originate from the HOST -- same
routes, same vpn, same dns as the machine you are sitting at.

Bound to the vz bridge address, so only guests can reach it. CONNECT
only: everything the labs care about (git, brew, curl) speaks https.
"""
import socket
import sys
import threading


def pump(src, dst):
    try:
        while True:
            data = src.recv(65536)
            if not data:
                break
            dst.sendall(data)
    except OSError:
        pass
    finally:
        for s in (src, dst):
            try:
                s.shutdown(socket.SHUT_RDWR)
            except OSError:
                pass


def handle(client):
    try:
        req = b""
        while b"\r\n\r\n" not in req:
            data = client.recv(65536)
            if not data:
                return
            req += data
        method, target = req.split(b"\r\n", 1)[0].decode().split()[:2]
        if method != "CONNECT":
            client.sendall(b"HTTP/1.1 501 Not Implemented\r\n\r\n")
            return
        host, _, port = target.rpartition(":")
        upstream = socket.create_connection((host, int(port)), timeout=20)
        client.sendall(b"HTTP/1.1 200 Connection Established\r\n\r\n")
        threading.Thread(target=pump, args=(upstream, client), daemon=True).start()
        pump(client, upstream)
    except Exception:
        pass
    finally:
        client.close()


server = socket.socket()
server.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
server.bind((sys.argv[1], int(sys.argv[2])))
server.listen(64)
while True:
    conn, _ = server.accept()
    threading.Thread(target=handle, args=(conn,), daemon=True).start()
