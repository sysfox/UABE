#pragma once

#ifdef UABE_macOS_EXPORTS
#define UABE_macOS_API __attribute__((visibility("default")))
#else
#define UABE_macOS_API
#endif