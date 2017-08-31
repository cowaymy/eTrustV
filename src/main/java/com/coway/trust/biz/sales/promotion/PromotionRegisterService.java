package com.coway.trust.biz.sales.promotion;

import java.text.ParseException;

import com.coway.trust.biz.sales.promotion.vo.PromotionVO;
import com.coway.trust.cmmn.model.SessionVO;

public interface PromotionRegisterService {

	void registerPromotion(PromotionVO promotionVO, SessionVO sessionVO);

}
