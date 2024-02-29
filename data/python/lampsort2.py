from gtoolkit_bridge.PythonBridge.telemetry import gtTrace
from gtoolkit_bridge.PythonBridge.telemetry import TelemetrySignal

class LampSort:
	def __init__(self, data):
		self.data = data

	@gtTrace
	def sort(self):
		intervals = set([range(0, len(self.data))])
		while intervals:
			selectedInterval = self.selectInterval(intervals)
			if len(selectedInterval) > 1:
				self.joinIntervals(intervals, self.partition(selectedInterval))
		return self.data
		
	@gtTrace
	def partition(self, interval):
		pivot = self.selectPivot(interval)
		TelemetrySignal("stash_pivot")
		self.swap(interval.start, interval.stop-1)
		pivotIndex = interval.start
		for i in range(interval.start, interval.stop-1):
			if self.data[i] < pivot:
				TelemetrySignal("smaller_than_pivot")
				self.swap(i, pivotIndex)
				pivotIndex += 1
			else:
				TelemetrySignal("larger_than_pivot")
		TelemetrySignal("restore_pivot")
		self.swap(interval.stop-1, pivotIndex)
		return self.splitInterval(interval, pivotIndex)
	
	@gtTrace
	def selectInterval(self, intervals):
		return intervals.pop()
		
	@gtTrace
	def joinIntervals(self, intervals, newIntervals):
		intervals.update(newIntervals)
	
	@gtTrace
	def selectPivot(self, interval):
		return self.data[interval.start]
		
	@gtTrace
	def splitInterval(self, interval, pivotIndex):
		left = range(interval.start, pivotIndex)
		right = range(pivotIndex+1, interval.stop)
		return [left, right]
		
	@gtTrace
	def swap(self, index1, index2):
		tmp = self.data[index1]
		self.data[index1] = self.data[index2]
		self.data[index2] = tmp
