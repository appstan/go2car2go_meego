
#ifndef __M_UTILS__
#define __M_UTILS__

#include <QString>

class QMetaObject;
class QStringList;

namespace Utils {

typedef enum { PORTRAIT, LANDSCAPE, AUTO } Orientation;
typedef enum { LINUX, SYMBIAN, MAEMO, WINDOWS, OSX } Environment;


static const char PropertyPrefix[] = "db_";

void setOrientation(const Orientation &arg = PORTRAIT);

void extractObjectProperties(const QMetaObject *object,
                             QStringList *list,
                             bool cleanup = false,
                             const char *prefix = PropertyPrefix);

double calculateDistance(double latFrom, double lonFrom, double latTo, double lonTo);

int environment();


bool requireLogin();


}

#endif
