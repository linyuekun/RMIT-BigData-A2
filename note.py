#!/usr/bin/python
from pig_util import outputSchema

@outputSchema("category:chararray")
def price_note(total_price):
    if total_price >= 300:
        return "high value"
    elif 300 > total_price >= 100:
        return "medium"
    else:
        return "low value"
