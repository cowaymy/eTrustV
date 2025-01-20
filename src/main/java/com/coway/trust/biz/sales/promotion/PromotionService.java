/**
 *
 */
package com.coway.trust.biz.sales.promotion;

import java.util.List;
import java.util.Map;

import com.coway.trust.biz.sales.promotion.vo.PromotionVO;
import com.coway.trust.biz.sales.promotion.vo.SalesPromoDVO;
import com.coway.trust.cmmn.model.SessionVO;

import egovframework.rte.psl.dataaccess.util.EgovMap;

/**
 * @author Yunseok_Jang
 *
 */
public interface PromotionService {
	List<EgovMap> selectPromotionList(Map<String, Object> params);

	void updatePromoStatus(PromotionVO promotionVO, SessionVO sessionVO);

	void registerPromotion(PromotionVO promotionVO, SessionVO sessionVO);

	List<EgovMap> selectMembershipPkg(Map<String, Object> params);

	List<SalesPromoDVO> selectPriceInfo(PromotionVO promotionVO);

	EgovMap selectPromotionDetail(Map<String, Object> params);

	List<EgovMap> selectPromotionPrdList(Map<String, Object> params);

	List<EgovMap> selectPromotionFreeGiftList(Map<String, Object> params);

	void updatePromotion(PromotionVO promotionVO, SessionVO sessionVO);

	List<EgovMap> selectPromotionPrdWithPriceList(Map<String, Object> params);

	List<EgovMap> selectProductCodeList(Map<String, Object> params);

	List<EgovMap> selectProductCategoryList();

	List<EgovMap> selectFreeGiftCodeList(Map<String, Object> params);

	List<EgovMap> selectPromotionApprovalList(Map<String, Object> params);

	EgovMap selectPromoReqstInfo(Map<String, Object> params);

	List<EgovMap> selectPromoReqstPrdList(Map<String, Object> params);

	void updatePromoReqst(PromotionVO promotionVO, SessionVO sessionVO);

	void registerPromoReqst(PromotionVO promotionVO, SessionVO sessionVO);

	void updatePromoReqstApproval(Map<String, Object> params);

	int cntInPrgrsPromoReqst(int promoId);

	List<EgovMap> selectPromoHistList(Map<String, Object> params);

	List<EgovMap> selectPromoReqstPrdHistList(Map<String, Object> params);

	List<EgovMap> selectExcelPromoList(Map<String, Object> params);

	List<EgovMap> selectProductCompntConfigList(Map<String, Object> params);

	List<EgovMap> selectProductCompntConfigItmList( Map<String, Object> params ) throws Exception;

	List<EgovMap> selectProductCompnt( Map<String, Object> params );

	List<EgovMap> selectProductCompntPromotionList(Map<String, Object> params) throws Exception;

	Map<String, Object> registerProductCompntConfig( Map<String, Object> params ) throws Exception;

	Map<String, Object> updateProductCompntConfig( Map<String, Object> params ) throws Exception;

}
