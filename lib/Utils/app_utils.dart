

class DistanceCal{

  kmToMm(value){
    var a = value / 1000;
    return a;
  }
}


List<int> getNextAndPrevious({required List<int> myList,required int index}) {
  if (index >= 0 && index < myList.length) {
    int? nextIndex = index + 1 < myList.length ? index + 1 : null;
    int? prevIndex = index - 1 >= 0 ? index - 1 : null;

    int nextValue = nextIndex != null ? myList[nextIndex] : 0;
    int prevValue = prevIndex != null ? myList[prevIndex] : 0;

    return [prevValue, nextValue];
  } else {
    print("Index out of range.");
    return [0, 0];
  }
}