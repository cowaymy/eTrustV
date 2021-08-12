package com.coway.trust.web.common;

import com.coway.trust.biz.common.CommStatusFormVO;
import com.coway.trust.cmmn.model.GridDataSet;

public class CommStatusVO {

	private GridDataSet<CommStatusGridData> gridDataSet;
	private CommStatusFormVO commStatusVO;
	
	public GridDataSet<CommStatusGridData> getGridDataSet() {
		return gridDataSet;
	}
	public void setGridDataSet(GridDataSet<CommStatusGridData> gridDataSet) {
		this.gridDataSet = gridDataSet;
	}
	public CommStatusFormVO getCommStatusVO() {
		return commStatusVO;
	}
	public void setCommStatusVO(CommStatusFormVO commStatusVO) {
		this.commStatusVO = commStatusVO;
	}
	
}
