import pandas
from gtoolkit_bridge import gtView

class Movie:
	def __init__(self, series):
		self.series  = series

	@gtView
	def gtViewDescription(self, builder):
		text = builder.textEditor()
		text.title("Description")
		text.priority(30)
		text.setString(str(self.series))
		return text

	@gtView
	def gtViewDetails(self, builder):
		clist = builder.columnedList()
		clist.title("Details")
		clist.priority(20)
		clist.items(lambda: list(self.series.index))
		clist.column('Key', lambda each: each)
		clist.column('Value', lambda each: str(self.series[each]))
		clist.set_accessor(lambda each: self.series[each])
		return clist

class MovieCollection:
	def __init__(self, dataFrame):
		self.df = dataFrame
		
	def size(self):
		return len(self.df.index)

	def movieAtPosition(self, index):
		return Movie(self.df.loc[index])

	def directors(self):
		values = self.df["Directors"].astype(str).unique()
		values.sort()
		return map(lambda each: [each, self.moviesWithDirector(each)], values)
	
	def years(self):
		values = self.df["Year"].unique().tolist()
		values.sort()
		return map(lambda each: [each, self.moviesReleasedInYear(each)], values)
	
	def moviesReleasedInYear(self, year):
		return MovieCollection(self.df[self.df["Year"] == year].reset_index(drop=True))
	
	def moviesWithDirector(self, director):
		return MovieCollection(self.df[self.df["Directors"] == director].reset_index(drop=True))

	@gtView
	def gtViewYears(self, builder):
		clist = builder.columnedList()
		clist.title("Years")
		clist.priority(30)
		clist.items(lambda: self.years())
		clist.column("Year", lambda each: str(each[0]))
		clist.column("Count", lambda each: str(each[1].size()))
		clist.set_accessor(lambda each: [*self.years()][each][1])
		return clist

	@gtView
	def gtViewDirectors(self, builder):
		clist = builder.columnedList()
		clist.title("Directors")
		clist.priority(20)
		clist.items(lambda: self.directors())
		clist.column("Director", lambda each: str(each[0]))
		clist.column("Count", lambda each: str(each[1].size()))
		clist.set_accessor(lambda each: [*self.directors()][each][1])
		return clist

	@gtView
	def gtViewMovies(self, aBuilder):
		table = aBuilder.columnedList()
		table.title("Movies")
		table.priority(50)
		table.items(lambda: list(self.df.index))
		table.column("Title", lambda index: str(self.df.at[index, "Title"]))
		table.column("Release date", lambda index: str(self.df.at[index, "Release Date"]))
		table.column("Directors", lambda index: str(self.df.at[index, "Directors"]))
		table.column("Genres", lambda index: str(self.df.at[index, "Genres"]))
		return table
		
	def gtViewMoviesDetails(self, aBuilder):
		table = aBuilder.columnedList()
		table.title("Movies with details")
		table.priority(50)
		table.items(lambda: list(self.df.index))
		for each in self.df.columns:
			(lambda col: table.column(col, lambda index: str(self.df.at[index, col])))(each)
		table.set_accessor(lambda each: Movie(self.df.loc[list(self.df.index)[each]]))
		return table

