String storyShortenText(String text, {int maxLength = 3}) {
  if (text.length <= maxLength) {
    return text;
  } else {
    return text.substring(0, maxLength);
  }
}

String historyShortText(String text, {int maxLength = 30}) {
  if (text.length <= maxLength) {
    return text;
  } else {
    return '${text.substring(0, maxLength)}..';
  }
}

String vendorShortText(String text, {int maxLength = 12}) {
  if (text.length <= maxLength) {
    return text;
  } else {
    return '${text.substring(0, maxLength)}..';
  }
}

String vendorNShortText(String text, {int maxLength = 25}) {
  if (text.length <= maxLength) {
    return text;
  } else {
    return '${text.substring(0, maxLength)}..';
  }
}

String locationShortText(String text, {int maxLength = 22}) {
  if (text.length <= maxLength) {
    return text;
  } else {
    return '${text.substring(0, maxLength)}..';
  }
}

String serviceShortText(String text, {int maxLength = 90}) {
  if (text.length <= maxLength) {
    return text;
  } else {
    return '${text.substring(0, maxLength)}..';
  }
}
