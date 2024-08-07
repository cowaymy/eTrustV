package com.coway.trust.biz.sales.order.vo;

import java.io.Serializable;
import com.coway.trust.cmmn.model.GridDataSet;
import com.fasterxml.jackson.annotation.JsonIgnoreProperties;


/**
 * The persistent class for the SAL0213M database table.
 *
 */
@JsonIgnoreProperties(ignoreUnknown = true)
public class PreBookingOrderListVO implements Serializable {
	private static final long serialVersionUID = 1L;

    private GridDataSet<PreBookingOrderVO> preBookingOrderVOList;

	public GridDataSet<PreBookingOrderVO> getPreBookingOrderVOList() {
		return preBookingOrderVOList;
	}

	public void setPreOrderVOList(GridDataSet<PreBookingOrderVO> preBookingOrderVOList) {
		this.preBookingOrderVOList = preBookingOrderVOList;
	}

}