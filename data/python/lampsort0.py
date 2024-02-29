class LampSort:

	def __init__(self, data):
		self.data = data

	def sort(self):
		intervals = set([range(0, len(self.data))])
		while intervals:
			selectedInterval = self.selectInterval(intervals)
			if len(selectedInterval) > 1:
				self.joinIntervals(intervals, self.partition(selectedInterval))
		return self.data
		
	def partition(self, interval):
		pivot = self.selectPivot(interval)
		self.swap(interval.start, interval.stop-1)
		pivotIndex = interval.start
		for i in range(interval.start, interval.stop-1):
			if self.data[i] < pivot:
				self.swap(i, pivotIndex)
				pivotIndex += 1
		self.swap(interval.stop-1, pivotIndex)
		return self.splitInterval(interval, pivotIndex)
	
	def selectInterval(self, intervals):
		return intervals.pop()
		
	def joinIntervals(self, intervals, newIntervals):
		intervals.update(newIntervals)
	
	def selectPivot(self, interval):
		return self.data[interval.start]
		
	def splitInterval(self, interval, pivotIndex):
		left = range(interval.start, pivotIndex)
		right = range(pivotIndex+1, interval.stop)
		return [left, right]
		
	def swap(self, index1, index2):
		tmp = self.data[index1]
		self.data[index1] = self.data[index2]
		self.data[index2] = tmp
