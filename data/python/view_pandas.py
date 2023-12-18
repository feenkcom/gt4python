import pandas


#
# This file contains GToolkit Remote Phlow gtView definitions
# for some of the key pandas classes: DataFrame & Series
# These are added as extensions on the actual objects
#

#
# pandas.DataFrame.gtViewColumns
#

def dataframe_gt_view_columns(self, builder):
    clist = builder.columnedList()
    clist.title('Columns')
    clist.priority(10)
    clist.items(lambda: list(range(0, len(self.columns))))
    clist.column('Position', lambda each: each)
    clist.column('Column', lambda each: str(self.columns.values[each]))
    clist.column('Type', lambda each: str(self.dtypes.values[each]))
    clist.set_accessor(lambda each: self[self.columns.values[each]])
    return clist


setattr(pandas.DataFrame, 'gtViewColumns', dataframe_gt_view_columns)


#
# pandas.DataFrame.gtViewTable
#

def dataframe_gt_view_table(self, builder):
    if self.empty:
        return builder.empty()
    if self.shape[0] > 100:
        return builder.empty()
    clist = builder.columnedList()
    clist.title('Table')
    clist.priority(15)
    clist.items(lambda: list(self.index))
    clist.column('#', lambda index: index)
    for column in self.columns:
        (lambda col: clist.column(col, lambda index: str(self.at[index, col])))(column)
    clist.set_accessor(lambda each: self.loc[list(self.index)[each]])
    return clist


setattr(pandas.DataFrame, 'gtViewTable', dataframe_gt_view_table)


#
# pandas.DataFrame.gtViewHead
#

def dataframe_gt_view_head(self, builder):
    if self.empty:
        return builder.empty()
    if self.shape[0] <= 100:
        return builder.empty()
    forward = builder.forward()
    forward.title('Head')
    forward.priority(16)
    forward.object(lambda: self.head())
    forward.view('gtViewTable')
    return forward


setattr(pandas.DataFrame, 'gtViewHead', dataframe_gt_view_head)


#
# pandas.DataFrame.gtViewTail
#

def dataframe_gt_view_tail(self, builder):
    if self.empty:
        return builder.empty()
    if self.shape[0] <= 100:
        return builder.empty()
    forward = builder.forward()
    forward.title('Tail')
    forward.priority(17)
    forward.object(lambda: self.tail())
    forward.view('gtViewTable')
    return forward


setattr(pandas.DataFrame, 'gtViewTail', dataframe_gt_view_tail)


#
# pandas.DataFrame.gtViewSummary
#

def dataframe_gt_view_summary(self, builder):
    forward = builder.forward()
    forward.title('Summary')
    forward.priority(20)
    forward.object(lambda: self.describe())
    forward.view('gtViewTable')
    return forward


setattr(pandas.DataFrame, 'gtViewSummary', dataframe_gt_view_summary)


#
# pandas.Series.gtViewSeries
#

def series_gt_view_series(self, builder):
    if self.empty:
        return builder.empty()
    if self.shape[0] > 100:
        return builder.empty()
    clist = builder.columnedList()
    clist.title('Series')
    clist.priority(10)
    clist.items(lambda: list(self.index))
    clist.column('Key', lambda each: each)
    clist.column('Value', lambda each: str(self.at[each]))
    clist.set_accessor(lambda each: self[each])
    return clist


setattr(pandas.Series, 'gtViewSeries', series_gt_view_series)


#
# pandas.Series.gtViewHead
#

def series_gt_view_head(self, builder):
    if self.empty:
        return builder.empty()
    if self.shape[0] <= 100:
        return builder.empty()
    forward = builder.forward()
    forward.title('Head')
    forward.priority(11)
    forward.object(lambda: self.head())
    forward.view('gtViewSeries')
    return forward


setattr(pandas.Series, 'gtViewHead', series_gt_view_head)


#
# pandas.Series.gtViewTail
#

def series_gt_view_tail(self, builder):
    if self.empty:
        return builder.empty()
    if self.shape[0] <= 100:
        return builder.empty()
    forward = builder.forward()
    forward.title('Tail')
    forward.priority(12)
    forward.object(lambda: self.tail())
    forward.view('gtViewSeries')
    return forward


setattr(pandas.Series, 'gtViewTail', series_gt_view_tail)


#
# pandas.Series.gtViewSummary
#

def series_gt_view_summary(self, builder):
    forward = builder.forward()
    forward.title('Summary')
    forward.priority(20)
    forward.object(lambda: self.describe())
    forward.view('gtViewSeries')
    return forward


setattr(pandas.Series, 'gtViewSummary', series_gt_view_summary)
