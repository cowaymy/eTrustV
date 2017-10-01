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
}
