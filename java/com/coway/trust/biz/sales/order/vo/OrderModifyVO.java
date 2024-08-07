package com.coway.trust.biz.sales.order.vo;

import java.io.Serializable;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

import com.coway.trust.cmmn.model.GridDataSet;
import com.fasterxml.jackson.annotation.JsonIgnoreProperties;

/**
 *
 *
 */
@JsonIgnoreProperties(ignoreUnknown = true)
public class OrderModifyVO implements Serializable {
	
	private static final long serialVersionUID = 1L;

	private GridDataSet<ReferralVO> gridReferralVOList;
	
	private List<ReferralVO> referralVOList;
	
	private int salesOrdId;

	public GridDataSet<ReferralVO> getGridReferralVOList() {
		return gridReferralVOList;
	}

	public void setGridReferralVOList(GridDataSet<ReferralVO> gridReferralVOList) {
		this.gridReferralVOList = gridReferralVOList;
	}

	public List<ReferralVO> getReferralVOList() {
		return referralVOList;
	}

	public void setReferralVOList(List<ReferralVO> referralVOList) {
		this.referralVOList = referralVOList;
	}

	public int getSalesOrdId() {
		return salesOrdId;
	}

	public void setSalesOrdId(int salesOrdId) {
		this.salesOrdId = salesOrdId;
	}

}