/* j/5/dujs_ne.c
**
*/

#include <math.h>
#include <stdlib.h>
#include "all.h"

/* define macros
*/

  #define _DUJS_NE_NAN  0x7ff8000000000000
  #define _DUJS_NE_PINF 0x7ff0000000000000
  #define _DUJS_NE_NING 0xfff0000000000000

/* structures
*/

  union doub {
    float64_t d;
    c3_d c;
  };

/* jet interface functions
*/
  u3_weak
  u3qe_dujs_ne(u3_noun a)
  {
    if ( u3_nul == a )
      return u3_none;

    u3_noun s, p;
    u3x_cell(a, &s, &p);
    if ( _(u3du(s)) || (u3r_met(3, s) != 1) )
      return u3_none;

    c3_y *byt_y = u3a_string(s);
    if ( (byt_y == NULL) ) {
      return u3_none;
    } else if ( byt_y[0] != 'n' ) {
      u3a_free(byt_y);
      return u3_none;
    }
    u3a_free(byt_y);

    byt_y = u3a_string(p);
    if ( (byt_y == NULL) )
      return u3_none;

    c3_y *end_y;
    union doub res_u;
    res_u.d = strtod(byt_y, &end_y);
    if (end_y[0] != 0)
      res_u.c = _DUJS_NE_NAN;
    else if (res == HUGE_VAL)
      res_u.c = _DUJS_NE_PINF;
    else if (res == -HUGE_VAL)
      res_u.c = _DUJS_NE_NINF;

    u3a_free(byt_y);
    return u3i_chub(res_u.c)
  }

  u3_weak
  u3ke_dujs_ne(u3_noun a)
  {
    u3_noun res = u3qe_dujs_ne(a);
    u3z(a);
    return res;
  }

  u3_weak
  u3we_dujs_ne(u3_noun cor)
  {
    return u3qe_dujs_ne(u3x_at(u3x_sam, cor));
  }

/* undefine macros
*/

  #undef _DUJS_NE_DOUBNAN
  #undef _DUJS_NE_PINF
  #undef _DUJS_NE_NINF
