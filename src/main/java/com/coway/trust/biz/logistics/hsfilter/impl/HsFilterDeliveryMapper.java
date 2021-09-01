
package com.coway.trust.biz.logistics.hsfilter.impl;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Mapper("HsFilterDeliveryMapper")
public interface HsFilterDeliveryMapper{

	List<EgovMap> selectHSFilterDeliveryBranchList(Map<String, Object> params);
	List<EgovMap> selectHSFilterDeliveryList(Map<String, Object> params);
	List<EgovMap> selectHSFilterDeliveryPickingList(Map<String, Object> params);

}
