package com.coway.trust.biz.sales.customer;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.util.EgovMap;

public interface ExpiredCustomerService {

	  List<EgovMap> selectExpiredCustomerList(Map<String, Object> params);

}
