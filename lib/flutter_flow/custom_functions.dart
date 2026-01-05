import 'dart:convert';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'lat_lng.dart';
import 'place.dart';
import 'uploaded_file.dart';
import '/backend/sqlite/sqlite_manager.dart';

DateTime? strToDate(String dateString) {
  return DateTime.parse(dateString);
}

/// Checks if item contains searchQuery (case-insensitive)
bool doesItContain(
  String item,
  String searchQuery,
) {
  return item.toLowerCase().contains(searchQuery.toLowerCase());
}

bool shouldShowPage(
  int itemIndex,
  int? pageIndex,
  int startIndex,
) {
  if (pageIndex != null) {
    return itemIndex == pageIndex ||
        itemIndex == (pageIndex - 1) ||
        itemIndex == (pageIndex + 1);
  } else {
    return itemIndex == startIndex;
  }
}
