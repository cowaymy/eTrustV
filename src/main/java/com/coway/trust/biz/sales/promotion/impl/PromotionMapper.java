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

	EgovMap selectRentMemPriceInfo(Map<String, Object> params);

	EgovMap selectOutMemPriceInfo(Map<String, Object> params);

	EgovMap selectFilterPriceInfo(Map<String, Object> params);

	void insertSalesPromoM(SalesPromoMVO salesPromoMVO);

	void insertSalesPromoD(SalesPromoDVO salesPromoDVO);

	void insertSalesPromoFreeGift(SalesPromoFreeGiftVO salesPromoFreeGiftVO);

	EgovMap selectPromotionDetail(Map<String, Object> params);

	List<EgovMap> selectPromotionPrdList(Map<String, Object> params);

	List<EgovMap> selectPromotionPrdWithPriceList(Map<String, Object> params);

	List<EgovMap> selectRentMemPromotionPrdWithPriceList(Map<String, Object> params);

	List<EgovMap> selectOutMemPromotionPrdWithPriceList(Map<String, Object> params);

	List<EgovMap> selectFilterPromotionPrdWithPriceList(Map<String, Object> params);

	List<EgovMap> selectPromotionFreeGiftList(Map<String, Object> params);

	void updateSalesPromoM(SalesPromoMVO salesPromoMVO);

	void updateSalesPromoD(SalesPromoDVO salesPromoDVO);

	void updateSalesPromoFreeGift(SalesPromoFreeGiftVO salesPromoFreeGiftVO);

	List<EgovMap> selectProductCodeList(Map<String, Object> params);

	List<EgovMap> selectFreeGiftCodeList(Map<String, Object> params);

	List<EgovMap> selectProductCategoryList();

	void insertPromoReqstM(SalesPromoMVO salesPromoMVO);

	void insertPromoReqstD(SalesPromoDVO salesPromoDVO);
	void updatePromoReqstItmId(SalesPromoDVO salesPromoDVO);

	List<EgovMap> selectPromotionApprovalList(Map<String, Object> params);
	EgovMap selectPromoReqstInfo(Map<String, Object> params);

	List<EgovMap> selectPromoReqstPrdList(Map<String, Object> params);
	List<EgovMap> selectPromoReqstPrdUpdateList(Map<String, Object> params);

	void updatePromoReqstApproval(Map<String, Object> params);

	int cntInPrgrsPromoReqst(int promoId);

	void updateReqstPromoId(SalesPromoMVO salesPromoMVO);

	List<EgovMap> selectPromoHistList(Map<String, Object> params);
	List<EgovMap> selectPromoReqstPrdHistList(Map<String, Object> params);

	List<EgovMap> selectExcelPromoList(Map<String, Object> params);

	void insertSalesPromoAddtValue(EgovMap params);
	void insertSalesPromoRequestAddtValue(EgovMap params);

	List<EgovMap> selectProductCompntConfigList(Map<String, Object> params);

	List<EgovMap> selectProductCompntConfigItmList(Map<String, Object> params);

	List<EgovMap> selectProductCompntPromotionList (Map<String, Object> params);

	List<EgovMap> selectProductCompnt( Map<String, Object> params );

	void insertProductCompntConfig( Map<String, Object> params );

	void updateProductCompntConfig( Map<String, Object> params );

	int selectCntComponentExists(Map<String, Object> params);

}
