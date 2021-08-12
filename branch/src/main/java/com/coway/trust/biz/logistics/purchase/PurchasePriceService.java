package com.coway.trust.biz.logistics.purchase;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.util.EgovMap;

public interface PurchasePriceService {

	List<EgovMap> purchasePriceList(Map<String, Object> params);

}
