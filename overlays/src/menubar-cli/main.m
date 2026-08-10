#include <Carbon/Carbon.h>
#include <CoreFoundation/CFBase.h>
#include <Foundation/Foundation.h>
#include <libproc.h>
#include <stdbool.h>
#include <stddef.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#import <AppKit/NSRunningApplication.h>
#import <Cocoa/Cocoa.h>

#define APP_VERSION "2.2"

extern int SLSMainConnectionID();
extern void _SLPSGetFrontProcess(ProcessSerialNumber* psn);
extern void SLSGetConnectionIDForPSN(int cid, ProcessSerialNumber* psn, int* cid_out);
extern void SLSConnectionGetPID(int cid, pid_t* pid_out);

BOOL verbose = true;

pid_t get_pid_from_bundle_id(const char* bundle_id) {
  NSArray* apps = [NSRunningApplication runningApplicationsWithBundleIdentifier:
                                            [NSString stringWithUTF8String:bundle_id]];
  return apps.count > 0 ? ((NSRunningApplication*)apps[0]).processIdentifier : -1;
}

void get_bundle_id_from_ax(AXUIElementRef app, char* bundle_id, size_t str_size) {
  pid_t pid;
  AXUIElementGetPid(app, &pid);
  NSRunningApplication* running_app = [NSRunningApplication runningApplicationWithProcessIdentifier:pid];
  strncpy(bundle_id, [running_app.bundleIdentifier UTF8String], str_size - 1);
  BOOL hosted_view = (strcmp(bundle_id, "com.apple.MenuBarAgent") == 0);
};

void ax_init() {
  const void* keys[] = {kAXTrustedCheckOptionPrompt};
  const void* values[] = {kCFBooleanTrue};

  CFDictionaryRef options;
  options = CFDictionaryCreate(kCFAllocatorDefault,
                               keys,
                               values,
                               sizeof(keys) / sizeof(*keys),
                               &kCFCopyStringDictionaryKeyCallBacks,
                               &kCFTypeDictionaryValueCallBacks);

  bool trusted = AXIsProcessTrustedWithOptions(options);
  CFRelease(options);
  if (!trusted) {
    fprintf(stderr, "Accessibilty Permissions Needed.\n");
    exit(EXIT_FAILURE);
  }
}

void ax_perform_click(AXUIElementRef element) {
  if (!element) return;
  AXUIElementPerformAction(element, kAXPressAction);
}

AXUIElementRef ax_get_front_app() {
  ProcessSerialNumber psn;
  _SLPSGetFrontProcess(&psn);
  int target_cid;
  SLSGetConnectionIDForPSN(SLSMainConnectionID(), &psn, &target_cid);

  pid_t pid;
  SLSConnectionGetPID(target_cid, &pid);
  return AXUIElementCreateApplication(pid);
}

CFArrayRef ax_get_menu_options_child_ref(AXUIElementRef app) {
  AXUIElementRef menubars_ref = NULL;
  CFArrayRef children_ref = NULL;

  AXError error = AXUIElementCopyAttributeValue(app,
                                                kAXMenuBarAttribute,
                                                (CFTypeRef*)&menubars_ref);
  if (error != kAXErrorSuccess) return NULL;
  error = AXUIElementCopyAttributeValue(menubars_ref,
                                        kAXVisibleChildrenAttribute,
                                        (CFTypeRef*)&children_ref);

  if (menubars_ref) CFRelease(menubars_ref);
  if (error != kAXErrorSuccess) return NULL;
  return children_ref;
}

CFArrayRef ax_get_menu_extras_child_ref(AXUIElementRef app) {
  AXUIElementRef menuextras_ref = NULL;
  CFArrayRef children_ref = NULL;

  AXError error = AXUIElementCopyAttributeValue(app,
                                                kAXExtrasMenuBarAttribute,
                                                (CFTypeRef*)&menuextras_ref);
  if (error != kAXErrorSuccess) return NULL;
  error = AXUIElementCopyAttributeValue(menuextras_ref,
                                        kAXChildrenAttribute,
                                        (CFTypeRef*)&children_ref);

  if (menuextras_ref) CFRelease(menuextras_ref);
  if (error != kAXErrorSuccess) return NULL;
  return children_ref;
}

int select_menu_option_index(AXUIElementRef app, int index) {
  if (@available(macOS 15.0, *)) {
    CFArrayRef children_ref = ax_get_menu_options_child_ref(app);
    if (!children_ref) return EXIT_FAILURE;

    if (index < CFArrayGetCount(children_ref)) {
      AXUIElementRef item = CFArrayGetValueAtIndex(children_ref, index);
      ax_perform_click(item);
      CFRelease(children_ref);
    } else {
      CFRelease(children_ref);
      fprintf(stderr, "No menu item at index: %d\n", index);
      return EXIT_FAILURE;
    }
  } else {
    fprintf(stderr, "Only available on macOS 15 and higher.\n");
    return EXIT_FAILURE;
  }
  return EXIT_SUCCESS;
}

int select_menu_extra_index(AXUIElementRef app, uint32_t index) {
  if (@available(macOS 15.0, *)) {
    CFArrayRef hosted_children_ref = NULL;
    CFArrayRef children_ref = ax_get_menu_extras_child_ref(app);
    if (!children_ref) return EXIT_FAILURE;

    char bundle_id[255];
    get_bundle_id_from_ax(app, bundle_id, sizeof(bundle_id));
    BOOL hosted_view = (strcmp(bundle_id, "com.apple.MenuBarAgent") == 0);

    if (index < CFArrayGetCount(children_ref)) {
      AXUIElementRef item = CFArrayGetValueAtIndex(children_ref, index);

      if (hosted_view) {
        if (AXUIElementCopyAttributeValue(item, kAXChildrenAttribute, (CFTypeRef*)&hosted_children_ref) != kAXErrorSuccess) return EXIT_FAILURE;
        item = CFArrayGetValueAtIndex(hosted_children_ref, 0);
      }

      ax_perform_click(item);

      if (hosted_children_ref) CFRelease(hosted_children_ref);
      CFRelease(children_ref);

    } else {
      if (hosted_children_ref) CFRelease(hosted_children_ref);
      CFRelease(children_ref);
      fprintf(stderr, "No menu item at index: %d\n", index);
      return EXIT_FAILURE;
    }
  } else {
    fprintf(stderr, "Only available on macOS 15 and higher.\n");
    return EXIT_FAILURE;
  }
  return EXIT_SUCCESS;
}

int select_menu_extra_id(AXUIElementRef app, char* id) {
  if (@available(macOS 15.0, *)) {
    CFArrayRef children_ref = ax_get_menu_extras_child_ref(app);
    if (!children_ref) return EXIT_FAILURE;

    char bundle_id[255];
    get_bundle_id_from_ax(app, bundle_id, sizeof(bundle_id));
    BOOL hosted_view = (strcmp(bundle_id, "com.apple.MenuBarAgent") == 0);

    uint32_t count = CFArrayGetCount(children_ref);
    for (uint32_t i = 0; i < count; i++) {
      CFStringRef identifier_ref = NULL;
      CFArrayRef hosted_children_ref = NULL;
      AXUIElementRef item_ref = CFArrayGetValueAtIndex(children_ref, i);

      if (hosted_view) {
        if (AXUIElementCopyAttributeValue(item_ref, kAXChildrenAttribute, (CFTypeRef*)&hosted_children_ref) != kAXErrorSuccess) continue;
        item_ref = CFArrayGetValueAtIndex(hosted_children_ref, 0);
      }

      AXUIElementCopyAttributeValue(item_ref, kAXIdentifierAttribute, (CFTypeRef*)&identifier_ref);

      if (identifier_ref && strcmp(id, CFStringGetCStringPtr(identifier_ref, kCFStringEncodingUTF8)) == 0) {
        ax_perform_click(item_ref);
        CFRelease(identifier_ref);
        if (hosted_children_ref) CFRelease(hosted_children_ref);
        CFRelease(children_ref);
        return EXIT_SUCCESS;
      }
      if (identifier_ref) CFRelease(identifier_ref);
      if (hosted_children_ref) CFRelease(hosted_children_ref);
    }
    CFRelease(children_ref);
    fprintf(stderr, "No menu item with id: \"%s\"\n", id);
    return EXIT_FAILURE;
  } else {
    fprintf(stderr, "Only available on macOS 15 and higher.\n");
    return EXIT_FAILURE;
  }
  return EXIT_SUCCESS;
}

int print_menu_options(AXUIElementRef app) {
  if (@available(macOS 15.0, *)) {
    CFArrayRef children_ref = ax_get_menu_options_child_ref(app);
    if (!children_ref) return EXIT_FAILURE;

    uint32_t count = CFArrayGetCount(children_ref);
    for (uint32_t i = 0; i < count; i++) {
      AXUIElementRef item_ref = CFArrayGetValueAtIndex(children_ref, i);
      CFStringRef title_ref = NULL;

      AXError error = AXUIElementCopyAttributeValue(item_ref,
                                                    kAXTitleAttribute,
                                                    (CFTypeRef*)&title_ref);

      if (error != kAXErrorSuccess || !title_ref) continue;

      uint32_t buffer_len = 2 * CFStringGetLength(title_ref);
      char buffer[2 * CFStringGetLength(title_ref)];
      CFStringGetCString(title_ref, buffer, buffer_len, kCFStringEncodingUTF8);
      CFRelease(title_ref);

      printf(verbose ? "title: \"%s\"\n" : "%s\n", buffer);
    }

    CFRelease(children_ref);
  } else {
    fprintf(stderr, "Only available on macOS 15 and higher.\n");
    return EXIT_FAILURE;
  }
  return EXIT_SUCCESS;
}

int print_menu_extras() {
  if (@available(macOS 15.0, *)) {
    NSWorkspace* workspace = [NSWorkspace sharedWorkspace];
    for (NSRunningApplication* app in workspace.runningApplications) {
      CFArrayRef children_ref = ax_get_menu_extras_child_ref(AXUIElementCreateApplication(app.processIdentifier));
      if (!children_ref) continue;

      uint32_t count = CFArrayGetCount(children_ref);
      for (uint32_t i = 0; i < count; i++) {
        AXUIElementRef item_ref = CFArrayGetValueAtIndex(children_ref, i);
        CFArrayRef hosted_children_ref = NULL;
        CFStringRef identifier_ref = NULL;

        if ([app.bundleIdentifier isEqualToString:@"com.apple.MenuBarAgent"]) {
          if (AXUIElementCopyAttributeValue(item_ref, kAXChildrenAttribute, (CFTypeRef*)&hosted_children_ref) != kAXErrorSuccess) continue;
          if (!hosted_children_ref || CFArrayGetCount(hosted_children_ref) <= 0) continue;
          item_ref = CFArrayGetValueAtIndex(hosted_children_ref, 0);
        }

        AXUIElementCopyAttributeValue(item_ref, kAXIdentifierAttribute, (CFTypeRef*)&identifier_ref);

        if (identifier_ref) {
          printf(verbose ? "app: \"%s\", id: \"%s\"\n" : "%s,%s\n", [app.bundleIdentifier UTF8String], CFStringGetCStringPtr(identifier_ref, kCFStringEncodingUTF8));
          CFRelease(identifier_ref);
        } else
          printf(verbose ? "app: \"%s\", index: %u\n" : "%s,%d\n", [app.bundleIdentifier UTF8String], i);

        if (hosted_children_ref) CFRelease(hosted_children_ref);
      };
      CFRelease(children_ref);
    }
  } else {
    fprintf(stderr, "Only available on macOS 15 and higher.\n");
    return EXIT_FAILURE;
  }
  return EXIT_SUCCESS;
};

void display_help_exit() {
  fprintf(stderr, "Usage: \n\
	menubar [menu|item] list {-m} \n\
	menubar menu select <index> \n\
	menubar item select <pid|bundle> <index|identifier>\n");
  exit(EXIT_FAILURE);
}

int main(int argc, char** argv) {
  ax_init();

  if (argc >= 3 && strcmp(argv[1], "menu") == 0) { // MenuOption
    if (strcmp(argv[2], "list") == 0) {            // List
      verbose = (argc >= 4 && strcmp(argv[3], "-m") == 0) ? false : true;
      exit(print_menu_options(ax_get_front_app()));

    } else if (strcmp(argv[2], "select") == 0) { // Select
      if (argc < 4) display_help_exit();
      int index;
      if (sscanf(argv[3], "%d", &index) == 0) display_help_exit();
      exit(select_menu_option_index(ax_get_front_app(), index));

    } else display_help_exit();

  } else if (argc >= 3 && strcmp(argv[1], "item") == 0) { // MenuExtra
    if (strcmp(argv[2], "list") == 0) {                   // List
      verbose = (argc >= 4 && strcmp(argv[3], "-m") == 0) ? false : true;
      exit(print_menu_extras());

    } else if (strcmp(argv[2], "select") == 0) { // Select
      if (argc < 5) display_help_exit();
      char app_bundle[255], identifier[255];
      int pid, index;
      AXUIElementRef app = NULL;

      if (sscanf(argv[3], "%d", &pid) == 1) {
        if (kill(pid, 0) != -1)
          app = AXUIElementCreateApplication(pid);
      } else if (sscanf(argv[3], "%s", app_bundle) == 1) {
        if ((pid = get_pid_from_bundle_id(app_bundle)) != -1)
          app = AXUIElementCreateApplication(pid);
      } else display_help_exit();

      if (!app) {
        fprintf(stderr, "App not running.\n");
        exit(EXIT_FAILURE);
      }

      if (sscanf(argv[4], "%d", &index) == 1)
        exit(select_menu_extra_index(app, index));
      else if (sscanf(argv[4], "%s", identifier) == 1)
        exit(select_menu_extra_id(app, identifier));
      else display_help_exit();
    } else display_help_exit();

  } else if (argc >= 2 && strcmp(argv[1], "version") == 0) {
    printf("menubar version: %s\n", APP_VERSION);

  } else display_help_exit();
}
