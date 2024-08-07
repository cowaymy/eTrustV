package com.coway.trust.biz.sales.order;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.util.EgovMap;

public interface OrderColorGridService {

	List<EgovMap> colorGridList(Map<String, Object> params);

	List<EgovMap> colorGridCmbProduct();

	String getMemID(Map<String, Object> params);

}
