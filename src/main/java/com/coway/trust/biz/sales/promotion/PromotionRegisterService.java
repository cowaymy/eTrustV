package com.coway.trust.biz.sales.promotion;

import java.text.ParseException;
import java.util.List;
import java.util.Map;

import com.coway.trust.biz.sales.promotion.vo.PromotionVO;
import com.coway.trust.biz.sales.promotion.vo.SalesPromoDVO;
import com.coway.trust.cmmn.model.SessionVO;

import egovframework.rte.psl.dataaccess.util.EgovMap;

public interface PromotionRegisterService {

	void registerPromotion(PromotionVO promotionVO, SessionVO sessionVO);

	List<EgovMap> selectMembershipPkg(Map<String, Object> params);

	List<SalesPromoDVO> selectPriceInfo(PromotionVO promotionVO);

}
