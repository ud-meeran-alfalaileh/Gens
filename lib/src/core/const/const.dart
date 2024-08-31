class Constants {
 static bool isVideoFile(String file) {
  return file.endsWith('.mp4') ||
         file.endsWith('.mov') ||
         file.endsWith('.avi') ||
         file.endsWith('.wmv') ||
         file.endsWith('.webm');
}
}