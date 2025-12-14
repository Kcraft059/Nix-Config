#include <AppKit/AppKit.h>
#import <Cocoa/Cocoa.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

void vibrateTimes(long occurrences, double time);
void interactiveLoop();
void performFeedback();
void printHelp(const char* cmd);

long occurrences = 1;
double timeInterval = 1;

int main(int argc, const char* argv[]) {
  @autoreleasepool {

    for (int argi = 1; argi < argc; argi++) {
      const char* crtArg = argv[argi];

      if (crtArg[0] == '-') {
        switch (crtArg[1]) {
        case 'h':
          printHelp(argv[0]);
          return 0;

        case 'n': {
          char* check;
          long tmpval;
          if (argi + 1 >= argc) return 1;

          tmpval = strtol(argv[argi + 1], &check, 10);

          if (*check != '\0') return 1;

          occurrences = tmpval;
          break;
        }

        case 't': {
          char* check;
          double tmpval;
          if (argi + 1 >= argc) return 1;

          tmpval = strtod(argv[argi + 1], &check);

          if (*check != '\0') return 1;

          timeInterval = tmpval;
          break;
        }

        case 'r':
          interactiveLoop();
          return 0;
        }
      }
    }
    vibrateTimes(occurrences, timeInterval);
  }
  return 0;
}

void performFeedback() {
  [[NSHapticFeedbackManager defaultPerformer]
      performFeedbackPattern:NSHapticFeedbackPatternGeneric
             performanceTime:NSHapticFeedbackPerformanceTimeNow];
}

void interactiveLoop() {
  printf("\"exit\" to quit interactive mode.\n");
  while (1) {
    int readLength = 32;
    char input[readLength];

    fgets(input, readLength, stdin);
    input[strcspn(input, "\n")] = '\0';

    if (!strcmp(input, "exit")) break;

    performFeedback();
  }
}

void printHelp(const char* cmd) {
  printf("Usage: \n\n\
Vibrate Trackpad:\t%s -n <occurences> -t <time_interval>\n\
Interactive mode:\t%s -r\n\
Show this menu:\t\t%s -h\n\nExemple:\n\n\
Vibrate 3 time spaced out by 0.5s: \t%s -n 3 -t 0.5\n",cmd,cmd,cmd,cmd);
}

void vibrateTimes(long occurrences, double interval) {
  __block long remaining = occurrences;
  CFRunLoopRef loop = CFRunLoopGetCurrent();

  performFeedback();

  if (--remaining <= 0) return;

  [NSTimer scheduledTimerWithTimeInterval:interval
                                  repeats:YES
                                    block:^(NSTimer* t) {
                                      performFeedback();
                                      if (--remaining <= 0) {
                                        [t invalidate];
                                        CFRunLoopStop(loop);
                                        return;
                                      }
                                    }];

  CFRunLoopRun();
}