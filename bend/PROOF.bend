import Base
import ./LAWS.bend as L
import ./tiers.bend as T

# Proofs: exhaustive case analysis over every combination of signals.

def L.short_2027_never_open(a, c, d, e, t):
  match a c d e t:
    case False{} False{} False{} False{} False{}:
      {==}
    case False{} False{} False{} False{} True{}:
      {==}
    case False{} False{} False{} True{} False{}:
      {==}
    case False{} False{} False{} True{} True{}:
      {==}
    case False{} False{} True{} False{} False{}:
      {==}
    case False{} False{} True{} False{} True{}:
      {==}
    case False{} False{} True{} True{} False{}:
      {==}
    case False{} False{} True{} True{} True{}:
      {==}
    case False{} True{} False{} False{} False{}:
      {==}
    case False{} True{} False{} False{} True{}:
      {==}
    case False{} True{} False{} True{} False{}:
      {==}
    case False{} True{} False{} True{} True{}:
      {==}
    case False{} True{} True{} False{} False{}:
      {==}
    case False{} True{} True{} False{} True{}:
      {==}
    case False{} True{} True{} True{} False{}:
      {==}
    case False{} True{} True{} True{} True{}:
      {==}
    case True{} False{} False{} False{} False{}:
      {==}
    case True{} False{} False{} False{} True{}:
      {==}
    case True{} False{} False{} True{} False{}:
      {==}
    case True{} False{} False{} True{} True{}:
      {==}
    case True{} False{} True{} False{} False{}:
      {==}
    case True{} False{} True{} False{} True{}:
      {==}
    case True{} False{} True{} True{} False{}:
      {==}
    case True{} False{} True{} True{} True{}:
      {==}
    case True{} True{} False{} False{} False{}:
      {==}
    case True{} True{} False{} False{} True{}:
      {==}
    case True{} True{} False{} True{} False{}:
      {==}
    case True{} True{} False{} True{} True{}:
      {==}
    case True{} True{} True{} False{} False{}:
      {==}
    case True{} True{} True{} False{} True{}:
      {==}
    case True{} True{} True{} True{} False{}:
      {==}
    case True{} True{} True{} True{} True{}:
      {==}

def L.short_2027_never_tight(a, c, d, e, t):
  match a c d e t:
    case False{} False{} False{} False{} False{}:
      {==}
    case False{} False{} False{} False{} True{}:
      {==}
    case False{} False{} False{} True{} False{}:
      {==}
    case False{} False{} False{} True{} True{}:
      {==}
    case False{} False{} True{} False{} False{}:
      {==}
    case False{} False{} True{} False{} True{}:
      {==}
    case False{} False{} True{} True{} False{}:
      {==}
    case False{} False{} True{} True{} True{}:
      {==}
    case False{} True{} False{} False{} False{}:
      {==}
    case False{} True{} False{} False{} True{}:
      {==}
    case False{} True{} False{} True{} False{}:
      {==}
    case False{} True{} False{} True{} True{}:
      {==}
    case False{} True{} True{} False{} False{}:
      {==}
    case False{} True{} True{} False{} True{}:
      {==}
    case False{} True{} True{} True{} False{}:
      {==}
    case False{} True{} True{} True{} True{}:
      {==}
    case True{} False{} False{} False{} False{}:
      {==}
    case True{} False{} False{} False{} True{}:
      {==}
    case True{} False{} False{} True{} False{}:
      {==}
    case True{} False{} False{} True{} True{}:
      {==}
    case True{} False{} True{} False{} False{}:
      {==}
    case True{} False{} True{} False{} True{}:
      {==}
    case True{} False{} True{} True{} False{}:
      {==}
    case True{} False{} True{} True{} True{}:
      {==}
    case True{} True{} False{} False{} False{}:
      {==}
    case True{} True{} False{} False{} True{}:
      {==}
    case True{} True{} False{} True{} False{}:
      {==}
    case True{} True{} False{} True{} True{}:
      {==}
    case True{} True{} True{} False{} False{}:
      {==}
    case True{} True{} True{} False{} True{}:
      {==}
    case True{} True{} True{} True{} False{}:
      {==}
    case True{} True{} True{} True{} True{}:
      {==}

def L.persistent_iff_all_short(s):
  match s:
    case T.Sig{a, b, c, d, e, t}:
      match a b c d e t:
        case False{} False{} False{} False{} False{} False{}:
          {==}
        case False{} False{} False{} False{} False{} True{}:
          {==}
        case False{} False{} False{} False{} True{} False{}:
          {==}
        case False{} False{} False{} False{} True{} True{}:
          {==}
        case False{} False{} False{} True{} False{} False{}:
          {==}
        case False{} False{} False{} True{} False{} True{}:
          {==}
        case False{} False{} False{} True{} True{} False{}:
          {==}
        case False{} False{} False{} True{} True{} True{}:
          {==}
        case False{} False{} True{} False{} False{} False{}:
          {==}
        case False{} False{} True{} False{} False{} True{}:
          {==}
        case False{} False{} True{} False{} True{} False{}:
          {==}
        case False{} False{} True{} False{} True{} True{}:
          {==}
        case False{} False{} True{} True{} False{} False{}:
          {==}
        case False{} False{} True{} True{} False{} True{}:
          {==}
        case False{} False{} True{} True{} True{} False{}:
          {==}
        case False{} False{} True{} True{} True{} True{}:
          {==}
        case False{} True{} False{} False{} False{} False{}:
          {==}
        case False{} True{} False{} False{} False{} True{}:
          {==}
        case False{} True{} False{} False{} True{} False{}:
          {==}
        case False{} True{} False{} False{} True{} True{}:
          {==}
        case False{} True{} False{} True{} False{} False{}:
          {==}
        case False{} True{} False{} True{} False{} True{}:
          {==}
        case False{} True{} False{} True{} True{} False{}:
          {==}
        case False{} True{} False{} True{} True{} True{}:
          {==}
        case False{} True{} True{} False{} False{} False{}:
          {==}
        case False{} True{} True{} False{} False{} True{}:
          {==}
        case False{} True{} True{} False{} True{} False{}:
          {==}
        case False{} True{} True{} False{} True{} True{}:
          {==}
        case False{} True{} True{} True{} False{} False{}:
          {==}
        case False{} True{} True{} True{} False{} True{}:
          {==}
        case False{} True{} True{} True{} True{} False{}:
          {==}
        case False{} True{} True{} True{} True{} True{}:
          {==}
        case True{} False{} False{} False{} False{} False{}:
          {==}
        case True{} False{} False{} False{} False{} True{}:
          {==}
        case True{} False{} False{} False{} True{} False{}:
          {==}
        case True{} False{} False{} False{} True{} True{}:
          {==}
        case True{} False{} False{} True{} False{} False{}:
          {==}
        case True{} False{} False{} True{} False{} True{}:
          {==}
        case True{} False{} False{} True{} True{} False{}:
          {==}
        case True{} False{} False{} True{} True{} True{}:
          {==}
        case True{} False{} True{} False{} False{} False{}:
          {==}
        case True{} False{} True{} False{} False{} True{}:
          {==}
        case True{} False{} True{} False{} True{} False{}:
          {==}
        case True{} False{} True{} False{} True{} True{}:
          {==}
        case True{} False{} True{} True{} False{} False{}:
          {==}
        case True{} False{} True{} True{} False{} True{}:
          {==}
        case True{} False{} True{} True{} True{} False{}:
          {==}
        case True{} False{} True{} True{} True{} True{}:
          {==}
        case True{} True{} False{} False{} False{} False{}:
          {==}
        case True{} True{} False{} False{} False{} True{}:
          {==}
        case True{} True{} False{} False{} True{} False{}:
          {==}
        case True{} True{} False{} False{} True{} True{}:
          {==}
        case True{} True{} False{} True{} False{} False{}:
          {==}
        case True{} True{} False{} True{} False{} True{}:
          {==}
        case True{} True{} False{} True{} True{} False{}:
          {==}
        case True{} True{} False{} True{} True{} True{}:
          {==}
        case True{} True{} True{} False{} False{} False{}:
          {==}
        case True{} True{} True{} False{} False{} True{}:
          {==}
        case True{} True{} True{} False{} True{} False{}:
          {==}
        case True{} True{} True{} False{} True{} True{}:
          {==}
        case True{} True{} True{} True{} False{} False{}:
          {==}
        case True{} True{} True{} True{} False{} True{}:
          {==}
        case True{} True{} True{} True{} True{} False{}:
          {==}
        case True{} True{} True{} True{} True{} True{}:
          {==}

def L.open_iff_clean(s):
  match s:
    case T.Sig{a, b, c, d, e, t}:
      match a b c d e t:
        case False{} False{} False{} False{} False{} False{}:
          {==}
        case False{} False{} False{} False{} False{} True{}:
          {==}
        case False{} False{} False{} False{} True{} False{}:
          {==}
        case False{} False{} False{} False{} True{} True{}:
          {==}
        case False{} False{} False{} True{} False{} False{}:
          {==}
        case False{} False{} False{} True{} False{} True{}:
          {==}
        case False{} False{} False{} True{} True{} False{}:
          {==}
        case False{} False{} False{} True{} True{} True{}:
          {==}
        case False{} False{} True{} False{} False{} False{}:
          {==}
        case False{} False{} True{} False{} False{} True{}:
          {==}
        case False{} False{} True{} False{} True{} False{}:
          {==}
        case False{} False{} True{} False{} True{} True{}:
          {==}
        case False{} False{} True{} True{} False{} False{}:
          {==}
        case False{} False{} True{} True{} False{} True{}:
          {==}
        case False{} False{} True{} True{} True{} False{}:
          {==}
        case False{} False{} True{} True{} True{} True{}:
          {==}
        case False{} True{} False{} False{} False{} False{}:
          {==}
        case False{} True{} False{} False{} False{} True{}:
          {==}
        case False{} True{} False{} False{} True{} False{}:
          {==}
        case False{} True{} False{} False{} True{} True{}:
          {==}
        case False{} True{} False{} True{} False{} False{}:
          {==}
        case False{} True{} False{} True{} False{} True{}:
          {==}
        case False{} True{} False{} True{} True{} False{}:
          {==}
        case False{} True{} False{} True{} True{} True{}:
          {==}
        case False{} True{} True{} False{} False{} False{}:
          {==}
        case False{} True{} True{} False{} False{} True{}:
          {==}
        case False{} True{} True{} False{} True{} False{}:
          {==}
        case False{} True{} True{} False{} True{} True{}:
          {==}
        case False{} True{} True{} True{} False{} False{}:
          {==}
        case False{} True{} True{} True{} False{} True{}:
          {==}
        case False{} True{} True{} True{} True{} False{}:
          {==}
        case False{} True{} True{} True{} True{} True{}:
          {==}
        case True{} False{} False{} False{} False{} False{}:
          {==}
        case True{} False{} False{} False{} False{} True{}:
          {==}
        case True{} False{} False{} False{} True{} False{}:
          {==}
        case True{} False{} False{} False{} True{} True{}:
          {==}
        case True{} False{} False{} True{} False{} False{}:
          {==}
        case True{} False{} False{} True{} False{} True{}:
          {==}
        case True{} False{} False{} True{} True{} False{}:
          {==}
        case True{} False{} False{} True{} True{} True{}:
          {==}
        case True{} False{} True{} False{} False{} False{}:
          {==}
        case True{} False{} True{} False{} False{} True{}:
          {==}
        case True{} False{} True{} False{} True{} False{}:
          {==}
        case True{} False{} True{} False{} True{} True{}:
          {==}
        case True{} False{} True{} True{} False{} False{}:
          {==}
        case True{} False{} True{} True{} False{} True{}:
          {==}
        case True{} False{} True{} True{} True{} False{}:
          {==}
        case True{} False{} True{} True{} True{} True{}:
          {==}
        case True{} True{} False{} False{} False{} False{}:
          {==}
        case True{} True{} False{} False{} False{} True{}:
          {==}
        case True{} True{} False{} False{} True{} False{}:
          {==}
        case True{} True{} False{} False{} True{} True{}:
          {==}
        case True{} True{} False{} True{} False{} False{}:
          {==}
        case True{} True{} False{} True{} False{} True{}:
          {==}
        case True{} True{} False{} True{} True{} False{}:
          {==}
        case True{} True{} False{} True{} True{} True{}:
          {==}
        case True{} True{} True{} False{} False{} False{}:
          {==}
        case True{} True{} True{} False{} False{} True{}:
          {==}
        case True{} True{} True{} False{} True{} False{}:
          {==}
        case True{} True{} True{} False{} True{} True{}:
          {==}
        case True{} True{} True{} True{} False{} False{}:
          {==}
        case True{} True{} True{} True{} False{} True{}:
          {==}
        case True{} True{} True{} True{} True{} False{}:
          {==}
        case True{} True{} True{} True{} True{} True{}:
          {==}
