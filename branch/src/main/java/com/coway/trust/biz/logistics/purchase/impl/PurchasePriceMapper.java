package com.coway.trust.biz.logistics.purchase.impl;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Mapper("purchasePriceMapper")
public interface PurchasePriceMapper {

	List<EgovMap> purchasePriceList(Map<String, Object> params);

}
