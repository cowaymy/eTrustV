package com.coway.trust.biz.sales.promotion.impl;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Mapper("promotionListMapper")
public interface PromotionListMapper {

	List<EgovMap> selectPromotionList(Map<String, Object> params);
}
