package com.coway.trust.biz.logistics.courier.impl;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Mapper("courierMapper")
public interface CourierMapper {

	List<EgovMap> selectCourierList(Map<String, Object> params);

	List<EgovMap> selectCourierDetail(Map<String, Object> params);

	void motifyCourier(Map<String, Object> params);

	void insertCourier(Map<String, Object> params);

	List<EgovMap> selectCourierId(String chkId);

	void updateDocNo(Map upmap);

	List<EgovMap> selectCourierComboList(Map<String, Object> params);

}
