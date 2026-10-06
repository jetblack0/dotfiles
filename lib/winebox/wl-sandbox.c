// wl-sandbox: open a Wayland socket whose clients the compositor treats as
// sandboxed (wp-security-context-v1). Hyprland hides its privileged globals
// (screencopy, virtual keyboard, data-control, layer-shell, toplevel lists)
// from them.
//
// usage: wl-sandbox <socket-path> <app-id>
// Prints "ready" once the socket works, then keeps it alive until stdin
// closes.
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <sys/socket.h>
#include <sys/un.h>
#include <wayland-client.h>
#include "security-context-v1-client-protocol.h"

static struct wp_security_context_manager_v1 *manager;

static void global(void *data, struct wl_registry *registry, uint32_t name,
		   const char *interface, uint32_t version) {
	if (strcmp(interface, wp_security_context_manager_v1_interface.name) == 0)
		manager = wl_registry_bind(registry, name,
					   &wp_security_context_manager_v1_interface, 1);
}

static void global_remove(void *data, struct wl_registry *registry, uint32_t name) {}

static const struct wl_registry_listener registry_listener = { global, global_remove };

int main(int argc, char **argv) {
	if (argc != 3) {
		fprintf(stderr, "usage: %s <socket-path> <app-id>\n", argv[0]);
		return 2;
	}

	struct wl_display *display = wl_display_connect(NULL);
	if (!display) {
		fprintf(stderr, "wl-sandbox: no wayland display\n");
		return 1;
	}
	struct wl_registry *registry = wl_display_get_registry(display);
	wl_registry_add_listener(registry, &registry_listener, NULL);
	wl_display_roundtrip(display);
	if (!manager) {
		fprintf(stderr, "wl-sandbox: compositor lacks wp_security_context_manager_v1\n");
		return 1;
	}

	int listen_fd = socket(AF_UNIX, SOCK_STREAM | SOCK_CLOEXEC, 0);
	struct sockaddr_un addr = { .sun_family = AF_UNIX };
	snprintf(addr.sun_path, sizeof addr.sun_path, "%s", argv[1]);
	unlink(argv[1]);
	if (bind(listen_fd, (struct sockaddr *)&addr, sizeof addr) || listen(listen_fd, 16)) {
		perror("wl-sandbox: socket");
		return 1;
	}

	// the compositor serves the socket until the write end of this pipe
	// closes, i.e. until we exit
	int close_fds[2];
	if (pipe(close_fds)) {
		perror("wl-sandbox: pipe");
		return 1;
	}

	struct wp_security_context_v1 *ctx =
		wp_security_context_manager_v1_create_listener(manager, listen_fd, close_fds[0]);
	wp_security_context_v1_set_sandbox_engine(ctx, "winebox");
	wp_security_context_v1_set_app_id(ctx, argv[2]);
	wp_security_context_v1_commit(ctx);
	wp_security_context_v1_destroy(ctx);
	if (wl_display_roundtrip(display) < 0) {
		fprintf(stderr, "wl-sandbox: compositor refused the security context\n");
		return 1;
	}
	close(listen_fd);
	close(close_fds[0]);
	wl_display_disconnect(display);

	printf("ready\n");
	fflush(stdout);

	char buf[64];
	while (read(STDIN_FILENO, buf, sizeof buf) > 0)
		;
	unlink(argv[1]);
	return 0;
}
