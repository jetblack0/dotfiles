user_pref("zen.pinned-tab-manager.close-shortcut-behavior", "unload-switch");
user_pref("zen.theme.hide-tab-throbber", false);
user_pref("zen.themes.disable-all", true);
user_pref("zen.view.compact.enable-at-startup", true);
user_pref("zen.welcome-screen.seen", true);

user_pref("zen.keyboard.shortcuts.version", 20);

// Every new tab opens next to the current one, not at the end.
user_pref("browser.tabs.insertAfterCurrent", true);

// Hand .onion names to DNS instead of rejecting them.
user_pref("network.dns.blockDotOnion", false);

// History: keep none, and clear history and form data when Zen closes.
// Cookies and cache stay, so logins survive a restart.
user_pref("places.history.enabled", false);
user_pref("privacy.sanitize.sanitizeOnShutdown", true);
user_pref("privacy.clearOnShutdown_v2.formdata", true);
user_pref("privacy.clearOnShutdown_v2.cookiesAndStorage", false);
user_pref("privacy.clearOnShutdown_v2.cache", false);

// The toolbar layout.
user_pref("browser.uiCustomization.state", "{\"placements\":{\"widget-overflow-fixed-list\":[],\"unified-extensions-area\":[\"vimium-c_gdh1995_cn-browser-action\",\"_762f9885-5a13-4abd-9c77-433dcd38b8fd_-browser-action\"],\"nav-bar\":[\"back-button\",\"forward-button\",\"stop-reload-button\",\"customizableui-special-spring1\",\"vertical-spacer\",\"urlbar-container\",\"customizableui-special-spring2\",\"unified-extensions-button\",\"ublock0_raymondhill_net-browser-action\",\"_d7742d87-e61d-4b78-b8a1-b469842139fa_-browser-action\",\"reset-pbm-toolbar-button\"],\"TabsToolbar\":[\"tabbrowser-tabs\",\"ai-window-toggle\"],\"vertical-tabs\":[],\"PersonalToolbar\":[\"import-button\",\"personal-bookmarks\"],\"zen-sidebar-top-buttons\":[\"zen-toggle-compact-mode\"],\"zen-sidebar-foot-buttons\":[\"downloads-button\",\"preferences-button\",\"zen-workspaces-button\",\"zen-create-new-button\"]},\"seen\":[\"developer-button\",\"screenshot-button\",\"ublock0_raymondhill_net-browser-action\",\"_d7742d87-e61d-4b78-b8a1-b469842139fa_-browser-action\",\"vimium-c_gdh1995_cn-browser-action\",\"_762f9885-5a13-4abd-9c77-433dcd38b8fd_-browser-action\",\"reset-pbm-toolbar-button\",\"ai-window-toggle\"],\"dirtyAreaCache\":[\"nav-bar\",\"vertical-tabs\",\"zen-sidebar-foot-buttons\",\"PersonalToolbar\",\"TabsToolbar\",\"zen-sidebar-top-buttons\",\"unified-extensions-area\"],\"currentVersion\":25,\"newElementCount\":4}");
