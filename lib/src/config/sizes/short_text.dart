String storyShortenText(String text, {int maxLength = 20}) {
  if (text.length <= maxLength) {
    return text;
  } else {
    return '${text.substring(0, maxLength)}..';
  }
}

String historyShortText(String text, {int maxLength = 30}) {
  if (text.length <= maxLength) {
    return text;
  } else {
    return '${text.substring(0, maxLength)}..';
  }
}
