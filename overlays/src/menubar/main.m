#include <Carbon/Carbon.h>
#include <Foundation/Foundation.h>
#include <libproc.h>
#include <stdbool.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#import <AppKit/NSRunningApplication.h>
#import <Cocoa/Cocoa.h>

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
    printf("Accessibilty Permissions Needed.");
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

void select_menu_option_index(AXUIElementRef app, int index) {
  CFArrayRef children_ref = ax_get_menu_options_child_ref(app);
  if (!children_ref) return;

  if (index < CFArrayGetCount(children_ref)) {
    AXUIElementRef item = CFArrayGetValueAtIndex(children_ref, index);
    ax_perform_click(item);
  }

  CFRelease(children_ref);
}

void select_menu_extra_index(AXUIElementRef app, uint32_t index, BOOL hosted_view) {
  CFArrayRef children_ref = ax_get_menu_extras_child_ref(app);
  if (!children_ref) return;

  if (index < CFArrayGetCount(children_ref)) {
    AXUIElementRef item = CFArrayGetValueAtIndex(children_ref, index);
    if (hosted_view) {
      CFArrayRef childs = NULL;
      if (AXUIElementCopyAttributeValue(item, kAXChildrenAttribute, (CFTypeRef*)&childs) != kAXErrorSuccess) return;
      item = CFArrayGetValueAtIndex(childs, 0);
      // childs should be freed after item use
    }

    ax_perform_click(item);
  }

  CFRelease(children_ref);
}

void select_menu_extra_id(AXUIElementRef app, char* id, BOOL hosted_view) {
  CFArrayRef children_ref = ax_get_menu_extras_child_ref(app);
  if (!children_ref) return;

  uint32_t count = CFArrayGetCount(children_ref);
  for (uint32_t i = 0; i < count; i++) {
    AXUIElementRef item = CFArrayGetValueAtIndex(children_ref, i);

    if (hosted_view) {
      CFArrayRef childs = NULL;
      if (AXUIElementCopyAttributeValue(item, kAXChildrenAttribute, (CFTypeRef*)&childs) != kAXErrorSuccess) continue;
      item = CFArrayGetValueAtIndex(childs, 0);
      // childs should be freed after item use
    }

    CFStringRef identifier = NULL;
    AXUIElementCopyAttributeValue(item, kAXIdentifierAttribute, (CFTypeRef*)&identifier);

    if (identifier && strcmp(id, CFStringGetCStringPtr(identifier, kCFStringEncodingUTF8)) == 0) {
      ax_perform_click(item);
      CFRelease(identifier);
      break;
    }
  }

  CFRelease(children_ref);
}

void print_menu_options(AXUIElementRef app) {
  CFArrayRef children_ref = ax_get_menu_options_child_ref(app);
  if (!children_ref) return;

  uint32_t count = CFArrayGetCount(children_ref);
  for (uint32_t i = 0; i < count; i++) {
    AXUIElementRef item = CFArrayGetValueAtIndex(children_ref, i);
    CFStringRef title = NULL;

    AXError error = AXUIElementCopyAttributeValue(item,
                                                  kAXTitleAttribute,
                                                  (CFTypeRef*)&title);
    if (error != kAXErrorSuccess || !title) continue;

    uint32_t buffer_len = 2 * CFStringGetLength(title);
    char buffer[2 * CFStringGetLength(title)];
    CFStringGetCString(title, buffer, buffer_len, kCFStringEncodingUTF8);
    printf(verbose ? "title: \"%s\"\n" : "%s\n",buffer);
    CFRelease(title);
  }

  CFRelease(children_ref);
}
void print_menu_extras() {
  NSWorkspace* workspace = [NSWorkspace sharedWorkspace];
  for (NSRunningApplication* app in workspace.runningApplications) {
    CFArrayRef children_ref = ax_get_menu_extras_child_ref(AXUIElementCreateApplication(app.processIdentifier));
    if (!children_ref) continue;

    uint32_t count = CFArrayGetCount(children_ref);
    for (uint32_t i = 0; i < count; i++) {
      AXUIElementRef item = CFArrayGetValueAtIndex(children_ref, i);

      if ([app.bundleIdentifier isEqualToString:@"com.apple.MenuBarAgent"]) {
        CFArrayRef childs = NULL;
        if (AXUIElementCopyAttributeValue(item, kAXChildrenAttribute, (CFTypeRef*)&childs) != kAXErrorSuccess) continue;
        if (!childs || CFArrayGetCount(childs) <= 0) continue;
        item = CFArrayGetValueAtIndex(childs, 0);
        // childs should be freed after item use
      }

      CFStringRef identifier = NULL;
      AXUIElementCopyAttributeValue(item, kAXIdentifierAttribute, (CFTypeRef*)&identifier);

      if (identifier) {
        printf(verbose ? "app: \"%s\", id: \"%s\"\n" : "%s,%s\n", [app.bundleIdentifier UTF8String], CFStringGetCStringPtr(identifier, kCFStringEncodingUTF8));
        CFRelease(identifier);
      } else
        printf(verbose ? "app: \"%s\", index: %u\n" : "%s,%d\n", [app.bundleIdentifier UTF8String], i);
    };
    CFRelease(children_ref);
  }
};

void display_help_exit() {
  printf("Usage: \n\
	menubar [menu|item] list {-m} \n\
	menubar menu select <index> \n\
	menubar item select <pid|bundle> <index|identifier>\n");
  exit(EXIT_FAILURE);
}

int main(int argc, char** argv) {
  ax_init();

  if (argc < 3) display_help_exit();

  if (strcmp(argv[1], "menu") == 0) {   // MenuOption
    if (strcmp(argv[2], "list") == 0) { // List
      verbose = (argc >= 4 && strcmp(argv[3], "-m") == 0) ? false : true;
      print_menu_options(ax_get_front_app());

    } else if (strcmp(argv[2], "select") == 0) { // Select
      if (argc < 4) display_help_exit();
      int index;
      if (sscanf(argv[3], "%d", &index) == 0) display_help_exit();
      select_menu_option_index(ax_get_front_app(), index);

    } else display_help_exit();
  } else if (strcmp(argv[1], "item") == 0) { // MenuExtra
    if (strcmp(argv[2], "list") == 0) {      // List
      verbose = (argc >= 4 && strcmp(argv[3], "-m") == 0) ? false : true;
      print_menu_extras();

    } else if (strcmp(argv[2], "select") == 0) { // Select
      if (argc < 5) display_help_exit();
      char app_bundle[255], identifier[255];
      int pid, index;
      BOOL hosted_view;
      AXUIElementRef app = NULL;

      if (sscanf(argv[3], "%d", &pid) == 1) {
        if (kill(pid, 0) != -1)
          app = AXUIElementCreateApplication(pid);
        NSRunningApplication* app = [NSRunningApplication runningApplicationWithProcessIdentifier:pid];
        strncpy(app_bundle, [app.bundleIdentifier UTF8String], sizeof(app_bundle) - 1);

      } else if (sscanf(argv[3], "%s", app_bundle) == 1) {
        if ((pid = get_pid_from_bundle_id(app_bundle)) != -1)
          app = AXUIElementCreateApplication(pid);

      } else display_help_exit();

      if (!app) {
        printf("App not running.");
        exit(EXIT_FAILURE);
      }
      hosted_view = (strcmp(app_bundle, "com.apple.MenuBarAgent") == 0);

      if (sscanf(argv[4], "%d", &index) == 1) {
        select_menu_extra_index(app, index, hosted_view);

      } else if (sscanf(argv[4], "%s", identifier) == 1) {
        select_menu_extra_id(app, identifier, hosted_view);

      } else display_help_exit();

    } else display_help_exit();
  } else display_help_exit();
}
