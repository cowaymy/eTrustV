package com.coway.trust.biz.sales.promotion.vo;

import java.io.Serializable;
import com.coway.trust.cmmn.model.GridDataSet;
import com.fasterxml.jackson.annotation.JsonIgnoreProperties;

/**
 *
 *
 */
@JsonIgnoreProperties(ignoreUnknown = true)
public class PromotionVO implements Serializable {

	private static final long serialVersionUID = 1L;

	private SalesPromoMVO salesPromoMVO; //SALES PROMOTION MASTER

	private GridDataSet<SalesPromoMVO> salesPromoMGridDataSetList; //SALES PROMOTION DETAILS GRID DATASET

	private GridDataSet<SalesPromoDVO> salesPromoDGridDataSetList; //SALES PROMOTION DETAILS GRID DATASET

	private GridDataSet<SalesPromoFreeGiftVO> freeGiftGridDataSetList; //SALES PROMOTION FREE GIFT GRID DATASET

	public SalesPromoMVO getSalesPromoMVO() {
		return salesPromoMVO;
	}

	public void setSalesPromoMVO(SalesPromoMVO salesPromoMVO) {
		this.salesPromoMVO = salesPromoMVO;
	}

	public GridDataSet<SalesPromoDVO> getSalesPromoDGridDataSetList() {
		return salesPromoDGridDataSetList;
	}

	public void setSalesPromoDGridDataSetList(GridDataSet<SalesPromoDVO> salesPromoDGridDataSetList) {
		this.salesPromoDGridDataSetList = salesPromoDGridDataSetList;
	}

	public GridDataSet<SalesPromoFreeGiftVO> getFreeGiftGridDataSetList() {
		return freeGiftGridDataSetList;
	}

	public void setFreeGiftGridDataSetList(GridDataSet<SalesPromoFreeGiftVO> freeGiftGridDataSetList) {
		this.freeGiftGridDataSetList = freeGiftGridDataSetList;
	}

	public GridDataSet<SalesPromoMVO> getSalesPromoMGridDataSetList() {
		return salesPromoMGridDataSetList;
	}

	public void setSalesPromoMGridDataSetList(GridDataSet<SalesPromoMVO> salesPromoMGridDataSetList) {
		this.salesPromoMGridDataSetList = salesPromoMGridDataSetList;
	}

}