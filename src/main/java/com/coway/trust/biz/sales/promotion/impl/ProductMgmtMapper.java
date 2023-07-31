package com.coway.trust.biz.sales.promotion.impl;

import java.util.List;
import java.util.Map;

import com.coway.trust.biz.sales.promotion.vo.SalesPromoDVO;
import com.coway.trust.biz.sales.promotion.vo.SalesPromoFreeGiftVO;
import com.coway.trust.biz.sales.promotion.vo.SalesPromoMVO;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Mapper("productMgmtMapper")
public interface ProductMgmtMapper {

	List<EgovMap> selectProductMgmtList(Map<String, Object> params);
	List<EgovMap> selectPromotionListByStkId(Map<String, Object> params);
	EgovMap selectProductDiscontinued(Map<String, Object> params);

	EgovMap selectAdminKeyinCount(Map<String, Object> params);
	EgovMap selecteKeyinCount(Map<String, Object> params);
	EgovMap selectQuotaCount(Map<String, Object> params);

	void updateProductCtrl(Map<String, Object> params);
	void updatePromotionCtrl(Map<String, Object> params);

	List<EgovMap> selectPriceReqstList(Map<String, Object> params);
	EgovMap selectPriceReqstInfo(Map<String, Object> params);
	List<EgovMap> selectPriceHistoryInfo2(Map<String, Object> params);

}
