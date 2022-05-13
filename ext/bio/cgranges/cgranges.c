#include "cgranges.h"

#define SIZEOF_INT32 4
#define SIZEOF_INT64 8

#if SIZEOF_SHORT == SIZEOF_INT32
#define NUM2UINT32 NUM2USHORT
#define NUM2INT32 NUM2SHORT
#define UINT32_2NUM USHORT2NUM
#define INT32_2NUM SHORT2NUM
#elif SIZEOF_INT == SIZEOF_INT32
#define NUM2UINT32 NUM2UINT
#define NUM2INT32 NUM2INT
#define UINT32_2NUM UINT2NUM
#define INT32_2NUM INT2NUM
#elif SIZEOF_LONG == SIZEOF_INT32
#define NUM2UINT32 NUM2ULONG
#define NUM2INT32 NUM2LONG
#define UINT32_2NUM ULONG2NUM
#define INT32_2NUM LONG2NUM
#else
#error "Neither int, long, nor short is the same size as int32_t"
#endif

#if SIZEOF_INT == SIZEOF_INT64
#define NUM2UINT64 NUM2UINT
#define NUM2INT64 NUM2INT
#define UINT64_2NUM UINT2NUM
#define INT64_2NUM INT2NUM
#elif SIZEOF_LONG == SIZEOF_INT64
#define NUM2UINT64 NUM2ULONG
#define NUM2INT64 NUM2LONG
#define UINT64_2NUM ULONG2NUM
#define INT64_2NUM LONG2NUM
#elif SIZEOF_LONGLONG == SIZEOF_INT64
#define NUM2UINT64 NUM2ULL
#define NUM2INT64 NUM2LL
#define UINT64_2NUM ULL2NUM
#define INT64_2NUM LL2NUM
#else
#error "Neither int, long, nor short is the same size as int64_t"
#endif

VALUE rb_Bio;
VALUE rb_CGRanges;
VALUE rb_eNoIndexError;
VALUE rb_eIndexedError;

static void cgranges_free(void *ptr);
static size_t cgranges_memsize(const void *ptr);

static const rb_data_type_t cgranges_type = {
    "cgranges",
    {
        0,
        cgranges_free,
        cgranges_memsize,
    },
    0,
    0,
    RUBY_TYPED_FREE_IMMEDIATELY,
};

static void
cgranges_free(void *ptr)
{
  if(ptr)
  {
    cr_destroy(ptr);
  }
}

static size_t
cgranges_memsize(const void *ptr)
{
  const cgranges_t *data = ptr;

  return data ? sizeof(*data) : 0;
}

static cgranges_t *get_cganges(VALUE self)
{
  cgranges_t *ptr = NULL;
  TypedData_Get_Struct(self, cgranges_t, &cgranges_type, ptr);

  return ptr;
}

static VALUE
cgranges_allocate(VALUE klass)
{
  cgranges_t *ptr = NULL;

  return TypedData_Wrap_Struct(klass, &cgranges_type, ptr);
}

static VALUE
cgranges_init(VALUE self)
{
  cgranges_t *cr = NULL;

  cr = cr_init();
  DATA_PTR(self) = cr;

  rb_ivar_set(self, rb_intern("@indexed"), Qfalse);

  return self;
}

static VALUE
cgranges_add(VALUE self, VALUE rb_ctg, VALUE rb_st, VALUE rb_en, VALUE rb_label)
{
  cgranges_t *cr = get_cganges(self);
  cr_intv_t *intv = NULL;
  char *ctg = NULL;
  int32_t st = 0;
  int32_t en = 0;
  int32_t label = 0;

  if (RTEST(rb_ivar_get(self, rb_intern("@indexed"))))
  {
    rb_raise(rb_eIndexedError, "Cannot add intervals to an indexed CGRanges");
    return Qnil;
  }

  if (rb_ctg != Qnil)
  {
    ctg = StringValueCStr(rb_ctg);
  }

  if (rb_st != Qnil)
  {
    st = NUM2INT32(rb_st);
  }

  if (rb_en != Qnil)
  {
    en = NUM2INT32(rb_en);
  }

  if (rb_label != Qnil)
  {
    label = NUM2INT32(rb_label);
  }

  intv = cr_add(cr, ctg, st, en, label);

  if (!intv)
  {
    rb_raise(rb_eRuntimeError, "Error adding interval");
    return Qnil;
  }

  return self;
}

static VALUE
cgranges_index(VALUE self)
{
  if(RTEST(rb_ivar_get(self, rb_intern("@indexed"))))
  {
    rb_raise(rb_eIndexedError, "CGRanges already indexed");
    return Qnil;
  }

  cgranges_t *cr = get_cganges(self);
  cr_index(cr);
  
  rb_ivar_set(self, rb_intern("@indexed"), Qtrue);

  return self;
}

static VALUE
cgranges_overlap(VALUE self, VALUE rb_ctg, VALUE rb_st, VALUE rb_en)
{
  cgranges_t *cr = get_cganges(self);
  char *ctg = NULL;
  int32_t st = 0;
  int32_t en = 0;

  int64_t *b = NULL;
  int64_t m_b = 0;
  int64_t n = 0;

  if (!RTEST(rb_ivar_get(self, rb_intern("@indexed"))))
  {
    rb_raise(rb_eNoIndexError, "CGRanges not indexed");
    return Qnil;
  }

  ctg = StringValueCStr(rb_ctg);
  st = NUM2INT32(rb_st);
  en = NUM2INT32(rb_en);
  
  n = cr_overlap(cr, ctg, st, en, &b, &m_b);

  if (n < 0)
  {
    rb_raise(rb_eRuntimeError, "Error finding overlaps");
    return Qnil;
  }

  VALUE result = rb_ary_new2(n);

  for (int64_t i = 0; i < n; i++)
  {
    VALUE rb_intv = rb_ary_new3(
      4, rb_ctg, INT32_2NUM(cr_start(cr, b[i])), INT32_2NUM(cr_end(cr, b[i])), INT32_2NUM(cr_label(cr, b[i]))
    );
    rb_ary_push(result, rb_intv);
  }

  return result;
}

static VALUE
cgranges_count_overlap(VALUE self, VALUE rb_ctg, VALUE rb_st, VALUE rb_en)
{
  cgranges_t *cr = get_cganges(self);
  char *ctg = NULL;
  int32_t st = 0;
  int32_t en = 0;

  int64_t *b = NULL;
  int64_t m_b = 0;
  int64_t n = 0;

  if (!RTEST(rb_ivar_get(self, rb_intern("@indexed"))))
  {
    rb_raise(rb_eNoIndexError, "CGRanges not indexed");
    return Qnil;
  }

  ctg = StringValueCStr(rb_ctg);
  st = NUM2INT32(rb_st);
  en = NUM2INT32(rb_en);
  
  n = cr_overlap(cr, ctg, st, en, &b, &m_b);

  if (n < 0)
  {
    rb_raise(rb_eRuntimeError, "Error finding overlaps");
    return Qnil;
  }

  return INT64_2NUM(n);
}

static VALUE
cgranges_contain(VALUE self, VALUE rb_ctg, VALUE rb_st, VALUE rb_en)
{
  cgranges_t *cr = get_cganges(self);
  char *ctg = NULL;
  int32_t st = 0;
  int32_t en = 0;

  int64_t *b = NULL;
  int64_t m_b = 0;
  int64_t n = 0;

  if (!RTEST(rb_ivar_get(self, rb_intern("@indexed"))))
  {
    rb_raise(rb_eNoIndexError, "CGRanges not indexed");
    return Qnil;
  }

  ctg = StringValueCStr(rb_ctg);
  st = NUM2INT32(rb_st);
  en = NUM2INT32(rb_en);
  
  n = cr_contain(cr, ctg, st, en, &b, &m_b);

  if (n < 0)
  {
    rb_raise(rb_eRuntimeError, "Error finding contained");
    return Qnil;
  }

  VALUE result = rb_ary_new2(n);

  for (int64_t i = 0; i < n; i++)
  {
    VALUE rb_intv = rb_ary_new3(
      4, rb_ctg, INT32_2NUM(cr_start(cr, b[i])), INT32_2NUM(cr_end(cr, b[i])), INT32_2NUM(cr_label(cr, b[i]))
    );
    rb_ary_push(result, rb_intv);
  }

  return result;
}

static VALUE
cgranges_count_contain(VALUE self, VALUE rb_ctg, VALUE rb_st, VALUE rb_en)
{
  cgranges_t *cr = get_cganges(self);
  char *ctg = NULL;
  int32_t st = 0;
  int32_t en = 0;

  int64_t *b = NULL;
  int64_t m_b = 0;
  int64_t n = 0;

  if (!RTEST(rb_ivar_get(self, rb_intern("@indexed"))))
  {
    rb_raise(rb_eNoIndexError, "CGRanges not indexed");
    return Qnil;
  }

  ctg = StringValueCStr(rb_ctg);
  st = NUM2INT32(rb_st);
  en = NUM2INT32(rb_en);
  
  n = cr_contain(cr, ctg, st, en, &b, &m_b);

  if (n < 0)
  {
    rb_raise(rb_eRuntimeError, "Error finding contained");
    return Qnil;
  }

  return INT64_2NUM(n);
}

void Init_cgranges(void)
{
  rb_Bio = rb_define_module("Bio");
  rb_CGRanges = rb_define_class_under(rb_Bio, "CGRanges", rb_cObject);
  rb_eNoIndexError = rb_define_class_under(rb_CGRanges, "NoIndexError", rb_eStandardError);
  rb_eIndexedError = rb_define_class_under(rb_CGRanges, "IndexedError", rb_eStandardError);

  rb_define_alloc_func(rb_CGRanges, cgranges_allocate);

  rb_define_method(rb_CGRanges, "initialize", cgranges_init, 0);
  rb_define_method(rb_CGRanges, "add", cgranges_add, 4);
  rb_define_method(rb_CGRanges, "index", cgranges_index, 0);
  rb_define_method(rb_CGRanges, "overlap", cgranges_overlap, 3);
  rb_define_method(rb_CGRanges, "count_overlap", cgranges_count_overlap, 3);
  rb_define_method(rb_CGRanges, "contain", cgranges_contain, 3);
  rb_define_method(rb_CGRanges, "count_contain", cgranges_count_contain, 3);
}