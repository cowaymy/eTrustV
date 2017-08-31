package com.coway.trust.biz.sales.promotion.impl;

import java.util.List;
import java.util.Map;

import com.coway.trust.biz.sales.order.vo.SalesOrderMVO;
import com.coway.trust.biz.sales.promotion.vo.SalesPromoDVO;
import com.coway.trust.biz.sales.promotion.vo.SalesPromoFreeGiftVO;
import com.coway.trust.biz.sales.promotion.vo.SalesPromoMVO;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Mapper("promotionRegisterMapper")
public interface PromotionRegisterMapper {

	void insertSalesPromoM(SalesPromoMVO salesPromoMVO);

	void insertSalesPromoD(SalesPromoDVO salesPromoDVO);

	void insertSalesPromoFreeGift(SalesPromoFreeGiftVO salesPromoFreeGiftVO);
}
