package com.coway.trust.biz.sales.promotion.impl;

import java.util.List;
import java.util.Map;

import com.coway.trust.biz.sales.promotion.vo.SalesPromoDVO;
import com.coway.trust.biz.sales.promotion.vo.SalesPromoFreeGiftVO;
import com.coway.trust.biz.sales.promotion.vo.SalesPromoMVO;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Mapper("promotionMapper")
public interface PromotionMapper {

	List<EgovMap> selectPromotionList(Map<String, Object> params);
	
	void updatePromoStatus(SalesPromoMVO salesPromoMVO);
	
	List<EgovMap> selectMembershipPkg(Map<String, Object> params);
	
	EgovMap selectPriceInfo(Map<String, Object> params);
	
	void insertSalesPromoM(SalesPromoMVO salesPromoMVO);

	void insertSalesPromoD(SalesPromoDVO salesPromoDVO);

	void insertSalesPromoFreeGift(SalesPromoFreeGiftVO salesPromoFreeGiftVO);

	EgovMap selectPromotionDetail(Map<String, Object> params);

	List<EgovMap> selectPromotionPrdList(Map<String, Object> params);
	
	List<EgovMap> selectPromotionFreeGiftList(Map<String, Object> params);

	void updateSalesPromoM(SalesPromoMVO salesPromoMVO);

	void updateSalesPromoD(SalesPromoDVO salesPromoDVO);

	void deleteSalesPromoD(SalesPromoDVO salesPromoDVO);

	void deleteSalesPromoFreeGift(SalesPromoFreeGiftVO salesPromoFreeGiftVO);

}
