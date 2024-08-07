package com.coway.trust.biz.homecare.services.install.impl;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Mapper("hcOrderCallListMapper")
public interface HcOrderCallListMapper {

	/**
	 * Save Call Log Result [ENHANCE OLD insertCallResult]
	 * @Author KR-SH
	 * @Date 2019. 12. 11.
	 * @param prams
	 * @return
	 */
	public Map<String, Object> selectHcOrderCall(Map<String, Object> prams);

	/**
	 * TO-DO Description
	 * @Author KR-SH
	 * @Date 2019. 12. 12.
	 * @param params
	 * @return
	 */
	public List<EgovMap> selectBaseList(Map<String, Object> params);

	/**
	 * Search Order Call List
	 * @Author KR-SH
	 * @Date 2019. 12. 26.
	 * @param params
	 * @return
	 */
	public List<EgovMap> searchHcOrderCallList(Map<String, Object> params);

}
