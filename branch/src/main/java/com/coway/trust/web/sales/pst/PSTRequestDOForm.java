package com.coway.trust.web.sales.pst;

import com.coway.trust.biz.sales.pst.PSTSalesMVO;
import com.coway.trust.cmmn.model.GridDataSet;

public class PSTRequestDOForm {

	private GridDataSet<PSTStockListGridForm> dataSet;
	private PSTSalesMVO pstSalesMVO;

	public GridDataSet<PSTStockListGridForm> getDataSet() {
		return dataSet;
	}

	public void setDataSet(GridDataSet<PSTStockListGridForm> dataSet) {
		this.dataSet = dataSet;
	}

	public PSTSalesMVO getPstSalesMVO() {
		return pstSalesMVO;
	}

	public void setPstSalesMVO(PSTSalesMVO pstSalesMVO) {
		this.pstSalesMVO = pstSalesMVO;
	}

}
